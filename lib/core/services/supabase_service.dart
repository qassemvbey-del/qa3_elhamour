import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase Integration, Auth & Local Storage Persistence Service
class SupabaseService {
  static final SupabaseService instance = SupabaseService._internal();
  SupabaseService._internal();

  static const String supabaseUrl = 'https://mxfndmnifvxvpizmbbcj.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im14Zm5kbW5pZnZ4dnBpem1iYmNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODc0NzQzNjgsImV4cCI6MjEwMzA1MDM2OH0.VY_skdcDXGd8_xiliY1HXb09RTw_ZQdhDxYgYbRzvVo';

  bool _initialized = false;
  bool get isInitialized => _initialized;
  bool enableCloudSync = true;

  SupabaseClient? get client {
    if (!_initialized || !enableCloudSync) return null;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  User? get currentUser => client?.auth.currentUser;
  Session? get currentSession => client?.auth.currentSession;
  bool get hasAuthSession => currentUser != null;

  /// Initialize Supabase Flutter SDK
  Future<void> init() async {
    if (_initialized) return;
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        // ignore: deprecated_member_use
        anonKey: supabaseAnonKey,
        realtimeClientOptions: const RealtimeClientOptions(
          eventsPerSecond: 10,
        ),
      );
      _initialized = true;
      if (kDebugMode) {
        print('✅ Supabase initialized successfully for qa3_elhamour');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Supabase init skipped or offline mode: $e');
      }
    }
  }

  // ==========================================
  // Authentication Methods (Google OAuth Only)
  // ==========================================

  /// Sign In with Google OAuth
  Future<bool> signInWithGoogle() async {
    if (!_initialized || client == null) {
      throw Exception('خدمة الجمارك المائية غير متصلة حالياً!');
    }
    final redirectUrl = kIsWeb ? null : 'io.supabase.qa3elhamour://login-callback';
    return await client!.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: redirectUrl,
    );
  }

  /// Sign Out
  Future<void> signOut() async {
    try {
      await client?.auth.signOut();
    } catch (_) {}
  }

  // ==========================================
  // Citizen Profile Cloud Fetching
  // ==========================================

  /// Fetch current authenticated citizen profile row from Supabase
  Future<Map<String, dynamic>?> fetchCurrentCitizenProfile() async {
    final user = currentUser;
    if (user == null || !_initialized || client == null) return null;

    final res = await client!
        .from('citizens')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    return res;
  }

  // ==========================================
  // Café Game Rooms Cloud Sync
  // ==========================================

  /// Sync Game Room to Cloud (Non-blocking)
  Future<void> upsertGameRoom({
    required String roomCode,
    required String title,
    required String currentGame,
    required String ownerNationalId,
    required List<Map<String, dynamic>> activePlayers,
    required List<Map<String, dynamic>> spectators,
    Map<String, dynamic>? gameState,
  }) async {
    if (!_initialized || !enableCloudSync || client == null) return;
    client!.from('game_rooms').upsert({
      'room_code': roomCode,
      'title': title,
      'current_game': currentGame,
      'owner_national_id': ownerNationalId,
      'active_players': activePlayers,
      'spectators': spectators,
      'game_state': gameState ?? {},
    }).catchError((e) {
      if (kDebugMode) print('Supabase upsertGameRoom error: $e');
    });
  }

  /// Fetch single game room from Cloud
  Future<Map<String, dynamic>?> fetchGameRoom(String roomCode) async {
    if (!_initialized || !enableCloudSync || client == null) return null;
    try {
      final res = await client!
          .from('game_rooms')
          .select()
          .eq('room_code', roomCode)
          .maybeSingle();
      return res;
    } catch (e) {
      if (kDebugMode) print('Supabase fetchGameRoom error: $e');
      return null;
    }
  }

  /// Send Room Chat Message to Cloud (Non-blocking)
  Future<void> sendRoomMessage({
    required String roomCode,
    required String senderName,
    required String senderEmoji,
    required String message,
    String? color,
  }) async {
    if (!_initialized || !enableCloudSync || client == null) return;
    client!.from('room_messages').insert({
      'room_code': roomCode,
      'sender_name': senderName,
      'sender_emoji': senderEmoji,
      'message': message,
      'color': color ?? '0xFFFFFFFF',
    }).catchError((e) {
      if (kDebugMode) print('Supabase sendRoomMessage error: $e');
    });
  }

  /// Fetch recent room messages from Cloud
  Future<List<Map<String, dynamic>>> fetchRoomMessages(String roomCode) async {
    if (!_initialized || !enableCloudSync || client == null) return [];
    try {
      final List<dynamic> res = await client!
          .from('room_messages')
          .select()
          .eq('room_code', roomCode)
          .order('created_at', ascending: true)
          .limit(50);
      return res.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (e) {
      if (kDebugMode) print('Supabase fetchRoomMessages error: $e');
      return [];
    }
  }

  /// Realtime channel subscription for Room Messages
  RealtimeChannel? subscribeToRoomMessages(
    String roomCode,
    void Function(Map<String, dynamic> payload) onMessageReceived,
  ) {
    if (!_initialized || !enableCloudSync || client == null) return null;
    try {
      final channel = client!.channel('room_messages:$roomCode');
      channel.onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'room_messages',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'room_code',
          value: roomCode,
        ),
        callback: (payload) {
          onMessageReceived(payload.newRecord);
        },
      ).subscribe();
      return channel;
    } catch (e) {
      if (kDebugMode) print('Supabase subscribeToRoomMessages error: $e');
      return null;
    }
  }

  /// Realtime channel subscription for Game Room Updates (e.g. Game Switch)
  RealtimeChannel? subscribeToGameRoom(
    String roomCode,
    void Function(Map<String, dynamic> payload) onRoomUpdated,
  ) {
    if (!_initialized || !enableCloudSync || client == null) return null;
    try {
      final channel = client!.channel('game_rooms:$roomCode');
      channel.onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'game_rooms',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'room_code',
          value: roomCode,
        ),
        callback: (payload) {
          onRoomUpdated(payload.newRecord);
        },
      ).subscribe();
      return channel;
    } catch (e) {
      if (kDebugMode) print('Supabase subscribeToGameRoom error: $e');
      return null;
    }
  }
}
