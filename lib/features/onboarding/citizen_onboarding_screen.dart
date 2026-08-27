import 'package:flutter/material.dart';
import '../../core/services/citizen_service.dart';
import '../../core/theme/bikini_theme.dart';
import '../../core/widgets/bikini_badge.dart';
import '../../core/widgets/bikini_button.dart';

/// Citizen Onboarding & ID Creation Screen for "جمهورية قاع الهامور"
class CitizenOnboardingScreen extends StatefulWidget {
  final VoidCallback? onComplete;

  const CitizenOnboardingScreen({
    super.key,
    this.onComplete,
  });

  @override
  State<CitizenOnboardingScreen> createState() => _CitizenOnboardingScreenState();
}

class _CitizenOnboardingScreenState extends State<CitizenOnboardingScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: 'سبونج بوب سكوير بانتس');
  final TextEditingController _handleController =
      TextEditingController(text: 'sponge_bob');

  late CitizenSpeciesOption _selectedSpecies;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedSpecies = CitizenService.availableSpecies.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _handleController.dispose();
    super.dispose();
  }

  void _handleIssueId() async {
    final name = _nameController.text.trim();
    final rawHandle = _handleController.text.trim();
    final handle = rawHandle.startsWith('@') ? rawHandle.substring(1) : rawHandle;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: BikiniColors.krabsRed,
          content: Text(
            'يا باشا اكتب اسمك الرسمي، قاع الهامور مفيهوش مواطنين مجهولين! 🦀',
            style: BikiniTypography.bodyMedium(color: BikiniColors.pureWhite),
          ),
        ),
      );
      return;
    }

    // Handle validation regex: ^[a-z0-9_]{3,20}$
    final handleRegex = RegExp(r'^[a-z0-9_]{3,20}$');
    if (!handleRegex.hasMatch(handle)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: BikiniColors.krabsRed,
          content: Text(
            'الهاندل يجب أن يحتوي على حروف إنجليزية صغيرة وأرقام و_ فقط، وبطول 3-20 حرفاً! (مثال: sponge_001)',
            style: BikiniTypography.bodyMedium(color: BikiniColors.pureWhite),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final profile = await CitizenService.instance.registerCitizen(
        legalName: name,
        handle: handle,
        species: _selectedSpecies,
      );

      if (mounted) {
        _showCelebrationDialog(profile);
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = e.toString().replaceAll('Exception:', '').trim();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: BikiniColors.krabsRed,
            content: Text(
              'خطأ في التسجيل: $errorMsg',
              style: BikiniTypography.bodyMedium(color: BikiniColors.pureWhite),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showCelebrationDialog(CitizenProfile profile) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: BikiniColors.warmSand,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: BikiniColors.cartoonBlack,
                width: 3.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: BikiniColors.cartoonBlack,
                  offset: Offset(6, 6),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top celebratory badge & icon
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: BikiniColors.spongeYellow,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: BikiniColors.cartoonBlack,
                      width: 3,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: BikiniColors.cartoonBlack,
                        offset: Offset(3, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      profile.speciesEmoji,
                      style: const TextStyle(fontSize: 42),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                BikiniBadge.active(
                  text: 'رقم القيد الرسمي: ${profile.id}',
                ),

                const SizedBox(height: 12),

                Text(
                  'أهلاً بيك رسمياً كمواطن في جمهورية قاع الهامور العظمى! 🪪✨',
                  style: BikiniTypography.displaySmall(
                    color: BikiniColors.deepNavy,
                  ).copyWith(fontSize: 19),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: BikiniColors.pureWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: BikiniColors.cartoonBlack,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'يا مرحب بالمواطن "${profile.name}"، تم استخراج بطاقتك وتوثيقها بختم النسر المائي!',
                        style: BikiniTypography.bodyMedium(
                          color: BikiniColors.cartoonBlack,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'دلوقتي تقدر تطلب سلطع برجر بالتقسيط، تشتكي شفيق للبلدية، وتشارك في رغي قهوة العم فيش! ☕🦀',
                        style: BikiniTypography.bodyRegular(
                          color: const Color(0xFF555555),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                BikiniButton.primary(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    if (widget.onComplete != null) {
                      widget.onComplete!();
                    }
                  },
                  text: 'ادخل الجمهورية دلوقتي 🍍🚀',
                  isFullWidth: true,
                  height: 52,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              // Nautical Header Card
              _buildHeaderCard(),

              const SizedBox(height: 16),

              // Live ID Card Preview
              _buildLiveCardPreview(),

              const SizedBox(height: 20),

              // Form: Citizen Name
              _buildNameField(),

              const SizedBox(height: 10),

              // Permanent Name Warning Alert
              _buildPermanentNameAlert(),

              const SizedBox(height: 18),

              // Form: Citizen Handle (@handle)
              _buildHandleField(),

              const SizedBox(height: 18),

              // Form: Species Selector
              _buildSpeciesSelector(),

              const SizedBox(height: 24),

              // Action Button to Issue ID (Single Primary Yellow Button on screen)
              BikiniButton.primary(
                onPressed: _isLoading ? null : _handleIssueId,
                text: _isLoading ? 'جاري استخراج البطاقة وتوثيقها... ⏳' : 'استخرج بطاقة مواطن قاع الهامور 🌊',
                isFullWidth: true,
                height: 52,
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BikiniColors.spongeYellow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: BikiniColors.cartoonBlack,
          width: 3.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: BikiniColors.cartoonBlack,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: BikiniColors.marineCyan,
                  shape: BoxShape.circle,
                  border: Border.all(color: BikiniColors.cartoonBlack, width: 2),
                ),
                child: const Text('🏛️', style: TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ديوان السجل المدني والتجنيد',
                      style: BikiniTypography.displaySmall().copyWith(fontSize: 17),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'جمهورية قاع الهامور العظمى 🔱',
                      style: BikiniTypography.bodyMedium(
                        color: const Color(0xFF333333),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              BikiniBadge.active(text: 'تسجيل رسمي'),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: BikiniColors.cartoonBlack, thickness: 1.8),
          const SizedBox(height: 6),
          Text(
            'استخرج بطاقة هويتك المائية وسجل بياناتك عشان تدخل الجمهورية وتاخد حصتك التموينية من سبونج بوب!',
            style: BikiniTypography.bodyRegular(
              color: const Color(0xFF222222),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveCardPreview() {
    final name = _nameController.text.trim().isEmpty
        ? 'مواطن تحت الإنشاء'
        : _nameController.text.trim();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF9E6), Color(0xFFFDE89C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: BikiniColors.cartoonBlack,
          width: 3.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: BikiniColors.cartoonBlack,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Text('🌊', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'جمهورية قاع الهامور',
                        style: BikiniTypography.titleBold(color: BikiniColors.deepNavy),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              BikiniBadge(
                text: 'معاينة حية 👁️',
                backgroundColor: BikiniColors.marineCyan,
                textColor: BikiniColors.cartoonBlack,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: BikiniColors.cartoonBlack, thickness: 1.5),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar box
              Container(
                width: 72,
                height: 88,
                decoration: BoxDecoration(
                  color: BikiniColors.spongeYellow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: BikiniColors.cartoonBlack,
                    width: 2.2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: BikiniColors.cartoonBlack,
                      offset: Offset(2, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _selectedSpecies.emoji,
                      style: const TextStyle(fontSize: 34),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _selectedSpecies.name,
                      style: BikiniTypography.caption().copyWith(fontSize: 8.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الاسم: $name',
                      style: BikiniTypography.bodyLarge().copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'المهنة: مواطن مائي 🌊',
                      style: BikiniTypography.bodyRegular(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'التهمة: بدون سوابق',
                      style: BikiniTypography.bodyRegular(
                        color: BikiniColors.krabsRed,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'القبيلة: ${_selectedSpecies.defaultClan}',
                      style: BikiniTypography.caption(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'ختم النسر المائي 🦅',
                  style: BikiniTypography.captionBold(color: BikiniColors.krabsRed),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'الرقم: 2980710001',
                style: BikiniTypography.caption(color: const Color(0xFF666666)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '١. الاسم الرسمى للمواطن (Legal Name) ✍️',
          style: BikiniTypography.titleBold(),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: BikiniColors.pureWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: BikiniColors.cartoonBlack,
              width: 2.8,
            ),
            boxShadow: const [
              BoxShadow(
                color: BikiniColors.cartoonBlack,
                offset: Offset(3, 3),
                blurRadius: 0,
              ),
            ],
          ),
          child: TextField(
            controller: _nameController,
            onChanged: (_) => setState(() {}),
            style: BikiniTypography.bodyLarge(),
            decoration: InputDecoration(
              hintText: 'اكتب اسمك البحري الرسمي...',
              hintStyle: BikiniTypography.inputHint(),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPermanentNameAlert() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BikiniColors.cartoonBlack, width: 2),
      ),
      child: Row(
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'تنبيه هام: الاسم الرسمي ثابت مدى الحياة ولا يمكن تغييره إطلاقاً بعد التسجيل بقرار ديوان السجل المدني!',
              style: BikiniTypography.captionBold(color: BikiniColors.cartoonBlack).copyWith(fontSize: 11.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '٢. اسم المعرّف الفريد (Handle) 🏷️',
          style: BikiniTypography.titleBold(),
        ),
        const SizedBox(height: 2),
        Text(
          'حروف إنجليزية صغيرة وأرقام و_ فقط (من 3 إلى 20 حرفاً)',
          style: BikiniTypography.caption(color: const Color(0xFF555555)),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: BikiniColors.pureWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: BikiniColors.cartoonBlack,
              width: 2.8,
            ),
            boxShadow: const [
              BoxShadow(
                color: BikiniColors.cartoonBlack,
                offset: Offset(3, 3),
                blurRadius: 0,
              ),
            ],
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: TextField(
              controller: _handleController,
              onChanged: (_) => setState(() {}),
              style: BikiniTypography.bodyLarge(),
              decoration: InputDecoration(
                prefixText: '@ ',
                prefixStyle: BikiniTypography.titleBold(color: BikiniColors.marineCyan),
                hintText: 'sponge_001',
                hintStyle: BikiniTypography.inputHint(),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeciesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '٢. فصيلة الكائن البحري 🧬',
          style: BikiniTypography.titleBold(),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: CitizenService.availableSpecies.map((species) {
            final isSelected = species.name == _selectedSpecies.name;
            return GestureDetector(
              onTap: () => setState(() => _selectedSpecies = species),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected
                      ? BikiniColors.spongeYellow
                      : BikiniColors.pureWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: BikiniColors.cartoonBlack,
                    width: isSelected ? 2.5 : 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: BikiniColors.cartoonBlack,
                      offset: isSelected ? const Offset(1, 1) : const Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(species.emoji, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Text(
                      species.name,
                      style: BikiniTypography.bodyMedium(
                        color: BikiniColors.cartoonBlack,
                      ).copyWith(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
