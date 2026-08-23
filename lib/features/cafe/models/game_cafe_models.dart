import 'package:flutter/material.dart';

/// Available Games in Uncle Fish Café
enum CafeGameType {
  dominoes,
  tawla,
  chess,
  basra,
}

extension CafeGameTypeExtension on CafeGameType {
  String get title {
    switch (this) {
      case CafeGameType.dominoes:
        return 'دومينو القاع 🁓';
      case CafeGameType.tawla:
        return 'طاولة الزهر 🎲';
      case CafeGameType.chess:
        return 'شطرنج شفيق ♟️';
      case CafeGameType.basra:
        return 'كوتشينة بصرة مائية 🃏';
    }
  }

  String get shortName {
    switch (this) {
      case CafeGameType.dominoes:
        return 'دومينو';
      case CafeGameType.tawla:
        return 'طاولة';
      case CafeGameType.chess:
        return 'شطرنج';
      case CafeGameType.basra:
        return 'بصرة';
    }
  }

  String get emoji {
    switch (this) {
      case CafeGameType.dominoes:
        return '🁓';
      case CafeGameType.tawla:
        return '🎲';
      case CafeGameType.chess:
        return '♟️';
      case CafeGameType.basra:
        return '🃏';
    }
  }

  int get minPlayers {
    switch (this) {
      case CafeGameType.dominoes:
        return 2;
      case CafeGameType.tawla:
        return 2;
      case CafeGameType.chess:
        return 2;
      case CafeGameType.basra:
        return 2;
    }
  }

  int get maxPlayers {
    switch (this) {
      case CafeGameType.dominoes:
        return 4;
      case CafeGameType.tawla:
        return 2;
      case CafeGameType.chess:
        return 2;
      case CafeGameType.basra:
        return 4;
    }
  }

  Color get themeColor {
    switch (this) {
      case CafeGameType.dominoes:
        return const Color(0xFFFFCCD5);
      case CafeGameType.tawla:
        return const Color(0xFFFFE6A7);
      case CafeGameType.chess:
        return const Color(0xFFD0E1FD);
      case CafeGameType.basra:
        return const Color(0xFFD8F3DC);
    }
  }

  String get description {
    switch (this) {
      case CafeGameType.dominoes:
        return 'دومينو مصري أصيل ٢٨ حجر.. دوبل بلاطة وشد على الطرفين وقفل الدور!';
      case CafeGameType.tawla:
        return 'طاولة زهر كلاسيكية ٢٤ خانة.. رمية الدوشيش وحبس القواشيط وتطليع الحجر!';
      case CafeGameType.chess:
        return 'شطرنج أعماق البحار التكتيكي.. كش ملك وقفل على الملك قبل ما يهرب!';
      case CafeGameType.basra:
        return 'كوتشينة بصرة ٥٢ كارت.. قش الطربيزة بالولد أو كومي ٧ واكسب بصرة!';
    }
  }
}

/// Participant Role in the Game Room
enum CafePlayerRole {
  player,
  spectator,
}

/// Participant at a Café Game Table
class CafeParticipant {
  final String id;
  final String name;
  final String avatar;
  final CafePlayerRole role;
  final bool isOwner;
  final int seatIndex; // -1 for spectator, 0..3 for players

  const CafeParticipant({
    required this.id,
    required this.name,
    required this.avatar,
    required this.role,
    this.isOwner = false,
    this.seatIndex = -1,
  });

  CafeParticipant copyWith({
    String? id,
    String? name,
    String? avatar,
    CafePlayerRole? role,
    bool? isOwner,
    int? seatIndex,
  }) {
    return CafeParticipant(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      isOwner: isOwner ?? this.isOwner,
      seatIndex: seatIndex ?? this.seatIndex,
    );
  }
}

/// A Game Room / Table in Uncle Fish Café
class CafeRoom {
  final String id; // 6-digit unique code, e.g. "492015"
  final String title;
  final String ownerId;
  final String ownerName;
  final CafeGameType activeGame;
  final List<CafeParticipant> participants;
  final List<Map<String, String>> chatMessages;
  final bool isPrivate;
  final DateTime createdAt;

  const CafeRoom({
    required this.id,
    required this.title,
    required this.ownerId,
    required this.ownerName,
    required this.activeGame,
    required this.participants,
    required this.chatMessages,
    this.isPrivate = false,
    required this.createdAt,
  });

  List<CafeParticipant> get players =>
      participants.where((p) => p.role == CafePlayerRole.player).toList();

  List<CafeParticipant> get spectators =>
      participants.where((p) => p.role == CafePlayerRole.spectator).toList();

  bool isUserOwner(String userId) => ownerId == userId;

  bool isUserPlayer(String userId) =>
      players.any((p) => p.id == userId);

  CafeParticipant? getParticipant(String userId) {
    try {
      return participants.firstWhere((p) => p.id == userId);
    } catch (_) {
      return null;
    }
  }

  CafeRoom copyWith({
    String? id,
    String? title,
    String? ownerId,
    String? ownerName,
    CafeGameType? activeGame,
    List<CafeParticipant>? participants,
    List<Map<String, String>>? chatMessages,
    bool? isPrivate,
    DateTime? createdAt,
  }) {
    return CafeRoom(
      id: id ?? this.id,
      title: title ?? this.title,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      activeGame: activeGame ?? this.activeGame,
      participants: participants ?? this.participants,
      chatMessages: chatMessages ?? this.chatMessages,
      isPrivate: isPrivate ?? this.isPrivate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
