import 'package:flutter/foundation.dart';
import '../avatar/marine_avatar_config.dart';
import 'supabase_service.dart';

/// Citizen Profile Data Model for "جمهورية قاع الهامور"
class CitizenProfile {
  final String id; // e.g. #0001
  final String name;
  final String handle; // e.g. @sponge_0001
  final String species;
  final String speciesEmoji;
  final String job;
  final String crime;
  final String clan;
  final String nationalNumber;
  final String bloodType;
  final DateTime registeredAt;
  final MarineAvatarConfig avatarConfig;

  const CitizenProfile({
    required this.id,
    required this.name,
    required this.handle,
    required this.species,
    required this.speciesEmoji,
    required this.job,
    required this.crime,
    required this.clan,
    required this.nationalNumber,
    required this.bloodType,
    required this.registeredAt,
    this.avatarConfig = const MarineAvatarConfig(),
  });

  CitizenProfile copyWith({
    String? id,
    String? name,
    String? handle,
    String? species,
    String? speciesEmoji,
    String? job,
    String? crime,
    String? clan,
    String? nationalNumber,
    String? bloodType,
    DateTime? registeredAt,
    MarineAvatarConfig? avatarConfig,
  }) {
    return CitizenProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      species: species ?? this.species,
      speciesEmoji: speciesEmoji ?? this.speciesEmoji,
      job: job ?? this.job,
      crime: crime ?? this.crime,
      clan: clan ?? this.clan,
      nationalNumber: nationalNumber ?? this.nationalNumber,
      bloodType: bloodType ?? this.bloodType,
      registeredAt: registeredAt ?? this.registeredAt,
      avatarConfig: avatarConfig ?? this.avatarConfig,
    );
  }
}

/// Species Option
class CitizenSpeciesOption {
  final String name;
  final String emoji;
  final String defaultClan;

  const CitizenSpeciesOption({
    required this.name,
    required this.emoji,
    required this.defaultClan,
  });
}

/// Global Citizen Profile & Shells Economy Service with Supabase & Local Session Recovery
class CitizenService {
  static final CitizenService instance = CitizenService._internal();
  CitizenService._internal();

  static int _citizenCounter = 1;

  final ValueNotifier<CitizenProfile?> currentProfile = ValueNotifier<CitizenProfile?>(null);
  final ValueNotifier<int> shellsBalance = ValueNotifier<int>(100);
  final ValueNotifier<bool> isGuestOrAuthenticated = ValueNotifier<bool>(false);

  bool get hasProfile => currentProfile.value != null;

  /// Auto-restore persisted session on app launch or web refresh (F5)
  Future<void> init() async {
    try {
      final isBypass = await SupabaseService.instance.getGuestBypass();
      final hasAuth = SupabaseService.instance.hasAuthSession;

      final data = await SupabaseService.instance.loadCitizenProfile();
      if (data != null) {
        final profile = CitizenProfile(
          id: data['id'] ?? '#0001',
          name: data['name'] ?? 'مواطن مائي',
          handle: data['handle'] ?? '@citizen_0001',
          species: data['species'] ?? 'إسفنجة بحرية',
          speciesEmoji: data['speciesEmoji'] ?? '🧽',
          job: data['job'] ?? availableJobs.first,
          crime: data['crime'] ?? availableCrimes.first,
          clan: data['clan'] ?? 'عشيرة الإسفنجيات',
          nationalNumber: data['nationalNumber'] ?? '298071000000000',
          bloodType: data['bloodType'] ?? availableBloodTypes.first,
          registeredAt: DateTime.tryParse(data['registeredAt'] ?? '') ?? DateTime.now(),
          avatarConfig: data['avatarConfig'] != null
              ? MarineAvatarConfig.fromJson(Map<String, dynamic>.from(data['avatarConfig']))
              : MarineAvatarConfig.fromSpeciesName(data['species'] ?? 'إسفنجة'),
        );

        shellsBalance.value = (data['shells'] is int) ? data['shells'] as int : 100;
        currentProfile.value = profile;
        isGuestOrAuthenticated.value = true;

        final numId = int.tryParse(profile.id.replaceAll('#', ''));
        if (numId != null && numId >= _citizenCounter) {
          _citizenCounter = numId + 1;
        }
      } else if (hasAuth || isBypass) {
        isGuestOrAuthenticated.value = true;
      }
    } catch (e) {
      if (kDebugMode) print('CitizenService init session recovery error: $e');
    }
  }

  void setAuthenticatedOrGuest(bool val) {
    isGuestOrAuthenticated.value = val;
    SupabaseService.instance.setGuestBypass(val);
  }

  /// Deduct shells if balance is sufficient
  bool spendShells(int amount) {
    if (shellsBalance.value >= amount) {
      shellsBalance.value -= amount;
      if (currentProfile.value != null) {
        SupabaseService.instance.updateShellsBalance(
          currentProfile.value!.nationalNumber,
          shellsBalance.value,
        );
      }
      return true;
    }
    return false;
  }

  /// Add shells (earnings, rewards, tips)
  void addShells(int amount) {
    shellsBalance.value += amount;
    if (currentProfile.value != null) {
      SupabaseService.instance.updateShellsBalance(
        currentProfile.value!.nationalNumber,
        shellsBalance.value,
      );
    }
  }

  static const List<CitizenSpeciesOption> availableSpecies = [
    CitizenSpeciesOption(
      name: 'إسفنجة بحرية',
      emoji: '🧽',
      defaultClan: 'عشيرة الإسفنجيات والأناناس',
    ),
    CitizenSpeciesOption(
      name: 'نجم بحر',
      emoji: '⭐',
      defaultClan: 'عشيرة النجوم الكسلانة',
    ),
    CitizenSpeciesOption(
      name: 'أخطبوط مثقف',
      emoji: '🐙',
      defaultClan: 'حلف الرخويات والموسيقى الفاشلة',
    ),
    CitizenSpeciesOption(
      name: 'سرطان بحري',
      emoji: '🦀',
      defaultClan: 'قبيلة القشريات أصحاب الفلوس',
    ),
    CitizenSpeciesOption(
      name: 'سمكة بلطي بلدي',
      emoji: '🐟',
      defaultClan: 'اتحاد الأسماك الغلابة',
    ),
    CitizenSpeciesOption(
      name: 'قنديل بحر لاسع',
      emoji: '🪼',
      defaultClan: 'طائفة القناديل المكهربة',
    ),
    CitizenSpeciesOption(
      name: 'سنجاب غطاس',
      emoji: '🐿️',
      defaultClan: 'رابطة الغواصين البرمائيين',
    ),
  ];

  static const List<String> availableJobs = [
    'شيف مقرمشات وملك البرجر 🍔',
    'مهندس فقاعات صابونية معتمد 🫧',
    'عاطل محترف تحت الصخرة 🪨',
    'عازف كلارينيت مزعج للجيران 🎺',
    'صائد قناديل بحر محترف 🪼',
    'تاجر صدف وسوق سودا مائية 🐚',
    'سائق توكتوك غواصة متهور 🚤',
    'جاسوس لصالح شمشون بالقطعة 🧆',
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

  /// Register a new citizen and assign sequential ID starting from #0001
  Future<CitizenProfile> registerCitizen({
    required String name,
    required CitizenSpeciesOption species,
    required String job,
    required String crime,
    String? customClan,
    String? bloodType,
    String? customHandle,
  }) async {
    final sequentialId = '#${_citizenCounter.toString().padLeft(4, '0')}';
    _citizenCounter++;

    final now = DateTime.now();
    final randomDigits = (100000000 + now.microsecondsSinceEpoch % 900000000).toString();
    final nationalId = '298071$randomDigits';

    final cleanName = name.trim().isEmpty ? 'مواطن مائي مجهول' : name.trim();
    final autoHandle = customHandle != null && customHandle.trim().isNotEmpty
        ? (customHandle.startsWith('@') ? customHandle.trim() : '@${customHandle.trim()}')
        : '@${cleanName.replaceAll(' ', '_')}_${sequentialId.replaceAll('#', '')}';

    final avatar = MarineAvatarConfig.fromSpeciesName(species.name);

    final profile = CitizenProfile(
      id: sequentialId,
      name: cleanName,
      handle: autoHandle,
      species: species.name,
      speciesEmoji: species.emoji,
      job: job,
      crime: crime,
      clan: customClan ?? species.defaultClan,
      nationalNumber: nationalId,
      bloodType: bloodType ?? availableBloodTypes.first,
      registeredAt: now,
      avatarConfig: avatar,
    );

    currentProfile.value = profile;
    isGuestOrAuthenticated.value = true;

    // Persist session to local storage & sync to Supabase
    await SupabaseService.instance.saveCitizenProfile(profile, shellsBalance.value);

    return profile;
  }

  void updateProfile(CitizenProfile updated) {
    currentProfile.value = updated;
    SupabaseService.instance.saveCitizenProfile(updated, shellsBalance.value);
  }

  Future<void> logoutOrReset() async {
    currentProfile.value = null;
    isGuestOrAuthenticated.value = false;
    shellsBalance.value = 100;
    await SupabaseService.instance.signOut();
  }
}
