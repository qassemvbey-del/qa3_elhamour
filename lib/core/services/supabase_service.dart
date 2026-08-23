import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'citizen_service.dart';

/// Supabase Integration & Local Storage Persistence Service
class SupabaseService {
  static final SupabaseService instance = SupabaseService._internal();
  SupabaseService._internal();

  static const String supabaseUrl = 'https://mxfndmnifvxvpizmbbcj.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im14Zm5kbW5pZnZ4dnBpem1iYmNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODc0NzQzNjgsImV4cCI6MjEwMzA1MDM2OH0.VY_skdcDXGd8_xiliY1HXb09RTw_ZQdhDxYgYbRzvVo';

  static const String _prefKeyCitizen = 'qa3_citizen_profile_v1';
  static const String _prefKeyShells = 'qa3_citizen_shells_v1';

  bool _initialized = false;
  bool get isInitialized => _initialized;

  SupabaseClient? get client {
    if (!_initialized) return null;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

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

  /// Save citizen profile to local storage & sync with Supabase citizens table
  Future<void> saveCitizenProfile(CitizenProfile profile, int shells) async {
    // 1. Local Storage (Immediate Persistence for Web refresh)
    try {
      final prefs = await SharedPreferences.getInstance();
      final map = {
        'id': profile.id,
        'name': profile.name,
        'species': profile.species,
        'speciesEmoji': profile.speciesEmoji,
        'job': profile.job,
        'crime': profile.crime,
        'clan': profile.clan,
        'nationalNumber': profile.nationalNumber,
        'bloodType': profile.bloodType,
        'registeredAt': profile.registeredAt.toIso8601String(),
        'shells': shells,
      };
      await prefs.setString(_prefKeyCitizen, jsonEncode(map));
      await prefs.setInt(_prefKeyShells, shells);
    } catch (e) {
      if (kDebugMode) print('Local storage write error: $e');
    }

    // 2. Cloud Supabase Sync
    if (_initialized && client != null) {
      try {
        await client!.from('citizens').upsert({
          'national_id': profile.nationalNumber,
          'full_name': profile.name,
          'job_title': profile.job,
          'shells_balance': shells,
          'species': profile.species,
          'crime': profile.crime,
          'avatar_emoji': profile.speciesEmoji,
        });
      } catch (e) {
        if (kDebugMode) print('Supabase citizen cloud sync error: $e');
      }
    }
  }

  /// Load persisted citizen profile from local storage or cloud
  Future<Map<String, dynamic>?> loadCitizenProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final str = prefs.getString(_prefKeyCitizen);
      if (str != null && str.isNotEmpty) {
        final decoded = jsonDecode(str) as Map<String, dynamic>;
        final shells = prefs.getInt(_prefKeyShells) ?? decoded['shells'] ?? 100;
        decoded['shells'] = shells;
        return decoded;
      }
    } catch (e) {
      if (kDebugMode) print('Local storage read error: $e');
    }
    return null;
  }

  /// Update shells balance in local storage & cloud
  Future<void> updateShellsBalance(String nationalId, int shells) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_prefKeyShells, shells);
    } catch (_) {}

    if (_initialized && client != null) {
      try {
        await client!
            .from('citizens')
            .update({'shells_balance': shells})
            .eq('national_id', nationalId);
      } catch (e) {
        if (kDebugMode) print('Supabase update shells error: $e');
      }
    }
  }

  /// Clear session
  Future<void> clearCitizenProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefKeyCitizen);
      await prefs.remove(_prefKeyShells);
    } catch (_) {}
  }

  /// Sync Game Room to Cloud
  Future<void> upsertGameRoom({
    required String roomCode,
    required String title,
    required String currentGame,
    required String ownerNationalId,
    required List<Map<String, dynamic>> activePlayers,
    required List<Map<String, dynamic>> spectators,
    Map<String, dynamic>? gameState,
  }) async {
    if (!_initialized || client == null) return;
    try {
      await client!.from('game_rooms').upsert({
        'room_code': roomCode,
        'title': title,
        'current_game': currentGame,
        'owner_national_id': ownerNationalId,
        'active_players': activePlayers,
        'spectators': spectators,
        'game_state': gameState ?? {},
      });
    } catch (e) {
      if (kDebugMode) print('Supabase upsertGameRoom error: $e');
    }
  }

  /// Fetch single game room from Cloud
  Future<Map<String, dynamic>?> fetchGameRoom(String roomCode) async {
    if (!_initialized || client == null) return null;
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

  /// Send Room Chat Message to Cloud
  Future<void> sendRoomMessage({
    required String roomCode,
    required String senderName,
    required String senderEmoji,
    required String message,
    String? color,
  }) async {
    if (!_initialized || client == null) return;
    try {
      await client!.from('room_messages').insert({
        'room_code': roomCode,
        'sender_name': senderName,
        'sender_emoji': senderEmoji,
        'message': message,
        'color': color ?? '0xFFFFFFFF',
      });
    } catch (e) {
      if (kDebugMode) print('Supabase sendRoomMessage error: $e');
    }
  }

  /// Fetch recent room messages from Cloud
  Future<List<Map<String, dynamic>>> fetchRoomMessages(String roomCode) async {
    if (!_initialized || client == null) return [];
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
    if (!_initialized || client == null) return null;
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
    if (!_initialized || client == null) return null;
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
