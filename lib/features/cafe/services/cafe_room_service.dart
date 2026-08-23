import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/citizen_service.dart';
import '../../../core/services/supabase_service.dart';
import '../models/game_cafe_models.dart';

/// Global Café Game Rooms Management Service with Supabase Cloud & Realtime Sync
class CafeRoomService {
  static final CafeRoomService instance = CafeRoomService._internal();
  CafeRoomService._internal() {
    _initSeededRooms();
  }

  final ValueNotifier<List<CafeRoom>> rooms = ValueNotifier<List<CafeRoom>>([]);
  final Random _random = Random();
  final Map<String, RealtimeChannel> _activeChannels = {};

  void _initSeededRooms() {
    rooms.value = [
      CafeRoom(
        id: '492015',
        title: 'ترابيزة هبيدة الدومينو الكبرى 🁓',
        ownerId: 'crab_01',
        ownerName: 'المعلم عضلات 🦞',
        activeGame: CafeGameType.dominoes,
        isPrivate: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        participants: [
          const CafeParticipant(
            id: 'crab_01',
            name: 'المعلم عضلات 🦞',
            avatar: '🦞',
            role: CafePlayerRole.player,
            isOwner: true,
            seatIndex: 0,
          ),
          const CafeParticipant(
            id: 'sponge_01',
            name: 'سبونج بوب 🍍',
            avatar: '🧽',
            role: CafePlayerRole.player,
            isOwner: false,
            seatIndex: 1,
          ),
          const CafeParticipant(
            id: 'patrick_01',
            name: 'بسيط نجم ⭐',
            avatar: '⭐',
            role: CafePlayerRole.spectator,
            isOwner: false,
          ),
          const CafeParticipant(
            id: 'squid_01',
            name: 'شفيق المروق 🎺',
            avatar: '🎺',
            role: CafePlayerRole.spectator,
            isOwner: false,
          ),
          const CafeParticipant(
            id: 'fish_01',
            name: 'سمكة بلطي 🐟',
            avatar: '🐟',
            role: CafePlayerRole.spectator,
            isOwner: false,
          ),
        ],
        chatMessages: [
          {
            'sender': 'المعلم عضلات 🏋️ (🦞)',
            'avatar': '🦞',
            'text': 'يا عم فيش نزل واحد شاي طحالب على حساب الطربيزة! 🫖',
            'time': '12:30 م',
            'color': '0xFFFFCCD5',
          },
          {
            'sender': 'سبونج بوب 🍍 (🧽)',
            'avatar': '🧽',
            'text': 'أنا جاهز ومبسوط يا رجالة! هيه هيه هيه! 🍍',
            'time': '12:32 م',
            'color': '0xFFFEE12B',
          },
          {
            'sender': 'بسيط نجم ⭐ (⭐)',
            'avatar': '⭐',
            'text': 'مين اللي قفل البلاطة؟ الحجر دا شكله زي الطعمية!',
            'time': '12:35 م',
            'color': '0xFFD0E1FD',
          },
        ],
      ),
      CafeRoom(
        id: '813942',
        title: 'تحدي طاولة الزهر بين سلطع وشفيق 🎲',
        ownerId: 'krabs_01',
        ownerName: 'مستر سلطع 💰',
        activeGame: CafeGameType.tawla,
        isPrivate: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        participants: [
          const CafeParticipant(
            id: 'krabs_01',
            name: 'مستر سلطع 💰',
            avatar: '🦀',
            role: CafePlayerRole.player,
            isOwner: true,
            seatIndex: 0,
          ),
          const CafeParticipant(
            id: 'squid_01',
            name: 'شفيق المروق 🎺',
            avatar: '🎺',
            role: CafePlayerRole.player,
            isOwner: false,
            seatIndex: 1,
          ),
          const CafeParticipant(
            id: 'plankton_01',
            name: 'شمشون العبقري 🧆',
            avatar: '🧆',
            role: CafePlayerRole.spectator,
            isOwner: false,
          ),
          const CafeParticipant(
            id: 'sponge_01',
            name: 'سبونج بوب 🍍',
            avatar: '🧽',
            role: CafePlayerRole.spectator,
            isOwner: false,
          ),
        ],
        chatMessages: [
          {
            'sender': 'مستر سلطع 💰 (🦀)',
            'avatar': '🦀',
            'text': 'المشاريب دي على حساب مين؟ مفيش حاجة ببلاش في القهوة! 💰',
            'time': '11:50 ص',
            'color': '0xFFFFE6A7',
          },
          {
            'sender': 'شفيق المروق 🎺 (🎺)',
            'avatar': '🎺',
            'text': 'توت توووت! ارمي الزهر بدل ما تاخد ضربة بالكلارينيت!',
            'time': '11:52 ص',
            'color': '0xFFD0E1FD',
          },
        ],
      ),
      CafeRoom(
        id: '104829',
        title: 'شطرنج الأساتذة تحت الصخرة ♟️',
        ownerId: 'squid_01',
        ownerName: 'شفيق الفنان 🎺',
        activeGame: CafeGameType.chess,
        isPrivate: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
        participants: [
          const CafeParticipant(
            id: 'squid_01',
            name: 'شفيق الفنان 🎺',
            avatar: '🎺',
            role: CafePlayerRole.player,
            isOwner: true,
            seatIndex: 0,
          ),
          const CafeParticipant(
            id: 'sandy_01',
            name: 'ساندي أمور 🐿️',
            avatar: '🐿️',
            role: CafePlayerRole.player,
            isOwner: false,
            seatIndex: 1,
          ),
          const CafeParticipant(
            id: 'jelly_01',
            name: 'قنديل البحر 🪼',
            avatar: '🪼',
            role: CafePlayerRole.spectator,
            isOwner: false,
          ),
        ],
        chatMessages: [
          {
            'sender': 'شفيق الفنان 🎺 (🎺)',
            'avatar': '🎺',
            'text': 'هعملك كش ملك بالحصان البحري في نقلتين يا ساندي!',
            'time': '1:10 م',
            'color': '0xFFD0E1FD',
          },
          {
            'sender': 'ساندي أمور 🐿️ (🐿️)',
            'avatar': '🐿️',
            'text': 'في تكساس بنلعب الشطرنج بسرعة الصوت.. جهز خطتك!',
            'time': '1:12 م',
            'color': '0xFFFFCCD5',
          },
        ],
      ),
      CafeRoom(
        id: '739201',
        title: 'بصرة الحارة البحرية وقش الطربيزة 🃏',
        ownerId: 'sponge_01',
        ownerName: 'سبونج بوب 🍍',
        activeGame: CafeGameType.basra,
        isPrivate: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        participants: [
          const CafeParticipant(
            id: 'sponge_01',
            name: 'سبونج بوب 🍍',
            avatar: '🧽',
            role: CafePlayerRole.player,
            isOwner: true,
            seatIndex: 0,
          ),
          const CafeParticipant(
            id: 'patrick_01',
            name: 'بسيط نجم ⭐',
            avatar: '⭐',
            role: CafePlayerRole.player,
            isOwner: false,
            seatIndex: 1,
          ),
          const CafeParticipant(
            id: 'puff_01',
            name: 'مدام نفيخة 🐡',
            avatar: '🐡',
            role: CafePlayerRole.player,
            isOwner: false,
            seatIndex: 2,
          ),
          const CafeParticipant(
            id: 'larry_01',
            name: 'المعلم عضلات 🦞',
            avatar: '🦞',
            role: CafePlayerRole.player,
            isOwner: false,
            seatIndex: 3,
          ),
        ],
        chatMessages: [
          {
            'sender': 'سبونج بوب 🍍 (🧽)',
            'avatar': '🧽',
            'text': 'معايا الولد وهقش الطربيزة كلها بصرة في عين الحسود! 🃏🔥',
            'time': '1:20 م',
            'color': '0xFFFEE12B',
          },
          {
            'sender': 'مدام نفيخة 🐡 (🐡)',
            'avatar': '🐡',
            'text': 'لو قشيت الطربيزة هسحب رخصة قيادة القوارب بتاعتك يا سبونج بوب!',
            'time': '1:21 م',
            'color': '0xFFD8F3DC',
          },
        ],
      ),
    ];
  }

  /// Search room by 6-digit code or partial title (In-Memory + Supabase Cloud Lookup)
  CafeRoom? findRoomByCode(String code) {
    final clean = code.trim().replaceAll('#', '');
    try {
      return rooms.value.firstWhere(
        (r) => r.id == clean || r.id.toLowerCase() == clean.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Async Search supporting Cloud Supabase table lookup
  Future<CafeRoom?> findOrFetchRoomByCode(String code) async {
    final cached = findRoomByCode(code);
    if (cached != null) return cached;

    final clean = code.trim().replaceAll('#', '');
    final cloudRoom = await SupabaseService.instance.fetchGameRoom(clean);
    if (cloudRoom != null) {
      final currentGameStr = cloudRoom['current_game'] ?? 'dominoes';
      final game = CafeGameType.values.firstWhere(
        (g) => g.name == currentGameStr,
        orElse: () => CafeGameType.dominoes,
      );

      final room = CafeRoom(
        id: cloudRoom['room_code'] ?? clean,
        title: cloudRoom['title'] ?? 'ترابيزة القاع #$clean',
        ownerId: cloudRoom['owner_national_id'] ?? 'owner',
        ownerName: 'صاحب الترابيزة',
        activeGame: game,
        isPrivate: false,
        createdAt: DateTime.tryParse(cloudRoom['created_at'] ?? '') ?? DateTime.now(),
        participants: [
          CafeParticipant(
            id: cloudRoom['owner_national_id'] ?? 'owner',
            name: 'صاحب الترابيزة 👑',
            avatar: '👑',
            role: CafePlayerRole.player,
            isOwner: true,
            seatIndex: 0,
          ),
        ],
        chatMessages: [
          {
            'sender': 'العم فيش ☕ (النظام)',
            'avatar': '☕',
            'text': 'تم العثور على الترابيزة من سحابة قاع الهامور! 🌊',
            'time': 'الآن',
            'color': '0xFF00F5D4',
          },
        ],
      );

      rooms.value = [room, ...rooms.value];
      return room;
    }

    return null;
  }

  /// Create a new private or public custom table (Synced to Supabase Cloud)
  CafeRoom createRoom({
    required String title,
    required CafeGameType initialGame,
    required CitizenProfile owner,
    bool isPrivate = false,
  }) {
    // Generate unique 6-digit ID
    String newId;
    do {
      newId = (100000 + _random.nextInt(900000)).toString();
    } while (rooms.value.any((r) => r.id == newId));

    final roomTitle = title.trim().isEmpty ? 'ترابيزة القاع الخاصة #$newId' : title.trim();

    final room = CafeRoom(
      id: newId,
      title: roomTitle,
      ownerId: owner.id,
      ownerName: owner.name,
      activeGame: initialGame,
      isPrivate: isPrivate,
      createdAt: DateTime.now(),
      participants: [
        CafeParticipant(
          id: owner.id,
          name: owner.name,
          avatar: owner.speciesEmoji,
          role: CafePlayerRole.player,
          isOwner: true,
          seatIndex: 0,
        ),
      ],
      chatMessages: [
        {
          'sender': 'العم فيش ☕ (ديوان القهوة)',
          'avatar': '☕',
          'text': 'ألف مبروك فتح الترابيزة! اطلبوا مشاريب واقعدوا رايقين يا رجالة! 🫖',
          'time': 'الآن',
          'color': '0xFF00F5D4',
        },
      ],
    );

    rooms.value = [room, ...rooms.value];

    // Async Cloud Sync
    SupabaseService.instance.upsertGameRoom(
      roomCode: newId,
      title: roomTitle,
      currentGame: initialGame.name,
      ownerNationalId: owner.nationalNumber,
      activePlayers: [
        {'id': owner.id, 'name': owner.name, 'avatar': owner.speciesEmoji}
      ],
      spectators: [],
    );

    SupabaseService.instance.sendRoomMessage(
      roomCode: newId,
      senderName: 'العم فيش ☕',
      senderEmoji: '☕',
      message: 'ألف مبروك فتح الترابيزة! اطلبوا مشاريب واقعدوا رايقين يا رجالة! 🫖',
      color: '0xFF00F5D4',
    );

    return room;
  }

  /// Switch the active game in a room (Admin only - Synced to Supabase)
  void switchGame(String roomId, CafeGameType newGame) {
    final list = List<CafeRoom>.from(rooms.value);
    final index = list.indexWhere((r) => r.id == roomId);
    if (index == -1) return;

    final current = list[index];
    // If player count exceeds new game's max players, relegate excess players to spectators
    final updatedParticipants = <CafeParticipant>[];
    int assignedPlayers = 0;

    for (final p in current.participants) {
      if (p.role == CafePlayerRole.player) {
        if (assignedPlayers < newGame.maxPlayers) {
          updatedParticipants.add(p.copyWith(seatIndex: assignedPlayers));
          assignedPlayers++;
        } else {
          updatedParticipants.add(p.copyWith(
            role: CafePlayerRole.spectator,
            seatIndex: -1,
          ));
        }
      } else {
        updatedParticipants.add(p);
      }
    }

    final newChat = List<Map<String, String>>.from(current.chatMessages)
      ..add({
        'sender': 'العم فيش ☕ (النظام)',
        'avatar': '👑',
        'text': 'صاحب الترابيزة غيّر اللعبة إلى ${newGame.title}! 🎮',
        'time': 'الآن',
        'color': '0xFFFEE12B',
      });

    list[index] = current.copyWith(
      activeGame: newGame,
      participants: updatedParticipants,
      chatMessages: newChat,
    );

    rooms.value = list;

    // Cloud Supabase Sync
    SupabaseService.instance.upsertGameRoom(
      roomCode: roomId,
      title: current.title,
      currentGame: newGame.name,
      ownerNationalId: current.ownerId,
      activePlayers: updatedParticipants
          .where((p) => p.role == CafePlayerRole.player)
          .map((p) => {'id': p.id, 'name': p.name, 'avatar': p.avatar})
          .toList(),
      spectators: updatedParticipants
          .where((p) => p.role == CafePlayerRole.spectator)
          .map((p) => {'id': p.id, 'name': p.name, 'avatar': p.avatar})
          .toList(),
    );

    SupabaseService.instance.sendRoomMessage(
      roomCode: roomId,
      senderName: 'العم فيش ☕ (النظام)',
      senderEmoji: '👑',
      message: 'صاحب الترابيزة غيّر اللعبة إلى ${newGame.title}! 🎮',
      color: '0xFFFEE12B',
    );
  }

  /// Assign seat or role to a participant
  void assignRole(String roomId, String participantId, CafePlayerRole role, {int seatIndex = -1}) {
    final list = List<CafeRoom>.from(rooms.value);
    final index = list.indexWhere((r) => r.id == roomId);
    if (index == -1) return;

    final current = list[index];
    final updated = current.participants.map((p) {
      if (p.id == participantId) {
        return p.copyWith(role: role, seatIndex: seatIndex);
      }
      return p;
    }).toList();

    list[index] = current.copyWith(participants: updated);
    rooms.value = list;
  }

  /// Join Room as player or spectator
  CafeRoom joinRoom(String roomId, CitizenProfile citizen, {bool asPlayer = false}) {
    final list = List<CafeRoom>.from(rooms.value);
    final index = list.indexWhere((r) => r.id == roomId);
    if (index == -1) throw Exception('الترابيزة غير موجودة');

    final current = list[index];
    final existingIndex = current.participants.indexWhere((p) => p.id == citizen.id);

    if (existingIndex != -1) {
      return current; // already joined
    }

    final canBePlayer = asPlayer && current.players.length < current.activeGame.maxPlayers;
    final role = canBePlayer ? CafePlayerRole.player : CafePlayerRole.spectator;
    final seatIndex = canBePlayer ? current.players.length : -1;

    final newParticipant = CafeParticipant(
      id: citizen.id,
      name: citizen.name,
      avatar: citizen.speciesEmoji,
      role: role,
      isOwner: current.ownerId == citizen.id,
      seatIndex: seatIndex,
    );

    final updatedParticipants = List<CafeParticipant>.from(current.participants)
      ..add(newParticipant);

    final updated = current.copyWith(participants: updatedParticipants);
    list[index] = updated;
    rooms.value = list;
    return updated;
  }

  /// Add message to Room Chat (Broadcast to Supabase Cloud)
  void addChatMessage(String roomId, Map<String, String> message) {
    final list = List<CafeRoom>.from(rooms.value);
    final index = list.indexWhere((r) => r.id == roomId);
    if (index == -1) return;

    final current = list[index];
    final updatedChat = List<Map<String, String>>.from(current.chatMessages)..add(message);
    list[index] = current.copyWith(chatMessages: updatedChat);
    rooms.value = list;

    // Send message to Supabase Realtime table
    SupabaseService.instance.sendRoomMessage(
      roomCode: roomId,
      senderName: message['sender'] ?? 'مواطن',
      senderEmoji: message['avatar'] ?? '🤿',
      message: message['text'] ?? '',
      color: message['color'],
    );
  }

  /// Subscribe to Realtime messages and room state updates
  void subscribeToRoomRealtime(String roomId) {
    if (_activeChannels.containsKey(roomId)) return;

    // 1. Subscribe to Chat Messages
    final msgChannel = SupabaseService.instance.subscribeToRoomMessages(roomId, (payload) {
      final text = payload['message']?.toString() ?? '';
      final senderName = payload['sender_name']?.toString() ?? 'مواطن';
      final senderEmoji = payload['sender_emoji']?.toString() ?? '🤿';
      final color = payload['color']?.toString() ?? '0xFFFFFFFF';

      final list = List<CafeRoom>.from(rooms.value);
      final index = list.indexWhere((r) => r.id == roomId);
      if (index == -1) return;

      final current = list[index];
      // Avoid duplicate local messages
      final isAlreadyPresent = current.chatMessages.any(
        (m) => m['text'] == text && m['sender'] == senderName,
      );

      if (!isAlreadyPresent) {
        final updatedChat = List<Map<String, String>>.from(current.chatMessages)
          ..add({
            'sender': senderName,
            'avatar': senderEmoji,
            'text': text,
            'time': 'الآن',
            'color': color,
          });
        list[index] = current.copyWith(chatMessages: updatedChat);
        rooms.value = list;
      }
    });

    if (msgChannel != null) {
      _activeChannels['$roomId:messages'] = msgChannel;
    }

    // 2. Subscribe to Game Room Updates (e.g. Game Switch)
    final roomChannel = SupabaseService.instance.subscribeToGameRoom(roomId, (payload) {
      final currentGameStr = payload['current_game']?.toString();
      if (currentGameStr == null) return;

      final newGame = CafeGameType.values.firstWhere(
        (g) => g.name == currentGameStr,
        orElse: () => CafeGameType.dominoes,
      );

      final list = List<CafeRoom>.from(rooms.value);
      final index = list.indexWhere((r) => r.id == roomId);
      if (index == -1) return;

      if (list[index].activeGame != newGame) {
        list[index] = list[index].copyWith(activeGame: newGame);
        rooms.value = list;
      }
    });

    if (roomChannel != null) {
      _activeChannels['$roomId:room'] = roomChannel;
    }
  }

  /// Unsubscribe from Realtime room updates
  void unsubscribeFromRoomRealtime(String roomId) {
    final msgChannel = _activeChannels.remove('$roomId:messages');
    msgChannel?.unsubscribe();

    final roomChannel = _activeChannels.remove('$roomId:room');
    roomChannel?.unsubscribe();
  }

  /// Reset or re-seed
  void reset() {
    _activeChannels.forEach((_, ch) => ch.unsubscribe());
    _activeChannels.clear();
    _initSeededRooms();
  }
}
