import 'package:flutter/foundation.dart';
import '../avatar/marine_avatar_config.dart';
import 'supabase_service.dart';

/// Citizen Profile Data Model matching Supabase citizens table schema in 01-database.md
class CitizenProfile {
  final String userId; // user_id (uuid PK = auth.uid())
  final String nationalId; // national_id (text unique, 14 digits)
  final int citizenNo; // citizen_no (int unique, #0001)
  final String legalName; // legal_name (text, immutable)
  final String displayName; // display_name (text, mutable)
  final String handle; // handle (text unique)
  final String species; // species (sponge/starfish/squid/crab/squirrel/fish)
  final String bloodType; // blood_type
  final String residence; // residence
  final MarineAvatarConfig avatarConfig; // avatar_config jsonb
  final String jobKey; // job_key (default 'citizen')
  final DateTime? jobChangedAt; // job_changed_at
  final int shells; // shells (read-only)
  final bool isWanted; // is_wanted (read-only)
  final int debtTotal; // debt_total (read-only)
  final List<String> badges; // badges (read-only)
  final DateTime? lastSeenAt;
  final DateTime? createdAt;

  const CitizenProfile({
    required this.userId,
    required this.nationalId,
    required this.citizenNo,
    required this.legalName,
    required this.displayName,
    required this.handle,
    required this.species,
    required this.bloodType,
    required this.residence,
    required this.avatarConfig,
    required this.jobKey,
    this.jobChangedAt,
    required this.shells,
    required this.isWanted,
    required this.debtTotal,
    required this.badges,
    this.lastSeenAt,
    this.createdAt,
  });

  CitizenProfile copyWith({
    String? userId,
    String? nationalId,
    int? citizenNo,
    String? legalName,
    String? displayName,
    String? handle,
    String? species,
    String? bloodType,
    String? residence,
    MarineAvatarConfig? avatarConfig,
    String? jobKey,
    DateTime? jobChangedAt,
    int? shells,
    bool? isWanted,
    int? debtTotal,
    List<String>? badges,
    DateTime? lastSeenAt,
    DateTime? createdAt,
  }) {
    return CitizenProfile(
      userId: userId ?? this.userId,
      nationalId: nationalId ?? this.nationalId,
      citizenNo: citizenNo ?? this.citizenNo,
      legalName: legalName ?? this.legalName,
      displayName: displayName ?? this.displayName,
      handle: handle ?? this.handle,
      species: species ?? this.species,
      bloodType: bloodType ?? this.bloodType,
      residence: residence ?? this.residence,
      avatarConfig: avatarConfig ?? this.avatarConfig,
      jobKey: jobKey ?? this.jobKey,
      jobChangedAt: jobChangedAt ?? this.jobChangedAt,
      shells: shells ?? this.shells,
      isWanted: isWanted ?? this.isWanted,
      debtTotal: debtTotal ?? this.debtTotal,
      badges: badges ?? this.badges,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // UI Backward Compatibility Getters
  String get id => '#${citizenNo.toString().padLeft(4, '0')}';
  String get name => displayName.isNotEmpty ? displayName : legalName;
  String get nationalNumber => nationalId;
  String get job => jobKey;
  String get speciesEmoji {
    final opt = CitizenService.availableSpecies.firstWhere(
      (s) => s.key == species,
      orElse: () => CitizenService.availableSpecies.first,
    );
    return opt.emoji;
  }
  String get crime => 'بدون سوابق مسجلة';
  String get clan => 'عشيرة قاع الهامور';
  DateTime get registeredAt => createdAt ?? DateTime.now();

  factory CitizenProfile.fromMap(Map<String, dynamic> map) {
    MarineAvatarConfig cfg = const MarineAvatarConfig();
    if (map['avatar_config'] != null) {
      try {
        cfg = MarineAvatarConfig.fromJson(Map<String, dynamic>.from(map['avatar_config']));
      } catch (_) {
        cfg = MarineAvatarConfig.fromSpeciesName(map['species'] ?? 'sponge');
      }
    }

    return CitizenProfile(
      userId: map['user_id'] as String? ?? '',
      nationalId: map['national_id'] as String? ?? '',
      citizenNo: map['citizen_no'] as int? ?? 0,
      legalName: map['legal_name'] as String? ?? '',
      displayName: map['display_name'] as String? ?? '',
      handle: map['handle'] as String? ?? '',
      species: map['species'] as String? ?? 'sponge',
      bloodType: map['blood_type'] as String? ?? '',
      residence: map['residence'] as String? ?? '',
      avatarConfig: cfg,
      jobKey: map['job_key'] as String? ?? 'citizen',
      jobChangedAt: map['job_changed_at'] != null
          ? DateTime.tryParse(map['job_changed_at'].toString())
          : null,
      shells: map['shells'] as int? ?? 0,
      isWanted: map['is_wanted'] as bool? ?? false,
      debtTotal: map['debt_total'] as int? ?? 0,
      badges: map['badges'] != null ? List<String>.from(map['badges']) : const [],
      lastSeenAt: map['last_seen_at'] != null
          ? DateTime.tryParse(map['last_seen_at'].toString())
          : null,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
    );
  }
}

/// Species Option
class CitizenSpeciesOption {
  final String key;
  final String name;
  final String emoji;
  final String defaultClan;

  const CitizenSpeciesOption({
    required this.key,
    required this.name,
    required this.emoji,
    required this.defaultClan,
  });
}

/// Global Citizen Profile & Shells Economy Service with Supabase Single Source of Truth
class CitizenService {
  static final CitizenService instance = CitizenService._internal();
  CitizenService._internal();

  final ValueNotifier<CitizenProfile?> currentProfile = ValueNotifier<CitizenProfile?>(null);
  final ValueNotifier<int> shellsBalance = ValueNotifier<int>(0);

  bool get hasProfile => currentProfile.value != null;

  /// Fetch profile from Supabase on app init or login
  Future<void> init() async {
    try {
      if (SupabaseService.instance.hasAuthSession) {
        final data = await SupabaseService.instance.fetchCurrentCitizenProfile();
        if (data != null) {
          final profile = CitizenProfile.fromMap(data);
          currentProfile.value = profile;
          shellsBalance.value = profile.shells;
        } else {
          currentProfile.value = null;
        }
      } else {
        currentProfile.value = null;
      }
    } catch (e) {
      if (kDebugMode) print('CitizenService init fetch error: $e');
    }
  }

  /// Deduct shells if balance is sufficient
  bool spendShells(int amount) {
    if (shellsBalance.value >= amount) {
      shellsBalance.value -= amount;
      return true;
    }
    return false;
  }

  /// Add shells
  void addShells(int amount) {
    shellsBalance.value += amount;
  }

  static const List<CitizenSpeciesOption> availableSpecies = [
    CitizenSpeciesOption(
      key: 'sponge',
      name: 'إسفنجة بحرية',
      emoji: '🧽',
      defaultClan: 'عشيرة الإسفنجيات والأناناس',
    ),
    CitizenSpeciesOption(
      key: 'starfish',
      name: 'نجم بحر',
      emoji: '⭐',
      defaultClan: 'عشيرة النجوم الكسلانة',
    ),
    CitizenSpeciesOption(
      key: 'squid',
      name: 'أخطبوط مثقف',
      emoji: '🐙',
      defaultClan: 'حلف الرخويات والموسيقى الفاشلة',
    ),
    CitizenSpeciesOption(
      key: 'crab',
      name: 'سرطان بحري',
      emoji: '🦀',
      defaultClan: 'قبيلة القشريات أصحاب الفلوس',
    ),
    CitizenSpeciesOption(
      key: 'fish',
      name: 'سمكة بلطي بلدي',
      emoji: '🐟',
      defaultClan: 'اتحاد الأسماك الغلابة',
    ),
    CitizenSpeciesOption(
      key: 'squirrel',
      name: 'سنجاب غطاس',
      emoji: '🐿️',
      defaultClan: 'رابطة الغواصين البرمائيين',
    ),
  ];

  static const List<String> availableJobs = [
    'شيف مقرمشات 🍔',
    'مهندس فقاعات 🫧',
    'عاطل محترف 🪨',
    'عازف كلارينيت 🎺',
    'صائد قناديل 🪼',
    'تاجر صدف 🐚',
    'سائق توكتوك غواصة 🚤',
  ];

  static const List<String> availableCrimes = [
    'سرقة سر الخلطة من خزنة سلطع 🍔',
    'تخميس بتوكتوك مائي على عجلتين 🚤',
    'إزعاج شفيق بالضحك العالي طوال الليل 🎺',
    'النوم المتواصل 18 ساعة تحت الصخرة ⭐',
    'أكل وجبات دلو الصدا وتسميم الحارة 🧆',
    'تفجير فقاعة عملاقة في وش العمدة 🫧',
    'التنكر في شكل طعمية مائية 🧆',
  ];

  static const List<String> availableBloodTypes = [
    'كتشب ومايونيز سلطع',
    'صوص باربيكيو حار',
    'مية مالحة وطحالب',
    'زيت قلي مقرمشات',
  ];

  /// Register a new citizen using Supabase rpc('register_citizen') ONLY
  Future<CitizenProfile> registerCitizen({
    required String legalName,
    required String handle,
    required CitizenSpeciesOption species,
    MarineAvatarConfig? avatarConfig,
  }) async {
    final client = SupabaseService.instance.client;
    if (client == null) {
      throw Exception('خدمة الداتابيز غير متصلة حالياً!');
    }

    final cleanName = legalName.trim();
    final cleanHandle = handle.trim().startsWith('@')
        ? handle.trim().substring(1)
        : handle.trim();

    final avatarMap = (avatarConfig ?? MarineAvatarConfig.fromSpeciesName(species.name)).toJson();

    // Call RPC register_citizen strictly as specified in 01-database.md
    await client.rpc('register_citizen', params: {
      'p_legal_name': cleanName,
      'p_handle': cleanHandle,
      'p_species': species.key,
      'p_avatar': avatarMap,
    });

    // Fetch newly created citizen row from DB
    final data = await SupabaseService.instance.fetchCurrentCitizenProfile();
    if (data == null) {
      throw Exception('فشل استرجاع بيانات المواطن من الداتابيز بعد التسجيل!');
    }

    final profile = CitizenProfile.fromMap(data);
    currentProfile.value = profile;
    shellsBalance.value = profile.shells;

    return profile;
  }

  void updateProfile(CitizenProfile updated) {
    currentProfile.value = updated;
  }

  Future<void> logoutOrReset() async {
    currentProfile.value = null;
    shellsBalance.value = 0;
    await SupabaseService.instance.signOut();
  }
}
