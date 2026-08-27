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
          backgroundColor: BikiniColors.danger,
          content: Text(
            'يا باشا اكتب اسمك الرسمي، قاع الهامور مفيهوش مواطنين مجهولين! 🦀',
            style: BikiniTypography.body(color: BikiniColors.card),
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
          backgroundColor: BikiniColors.danger,
          content: Text(
            'الهاندل يجب أن يحتوي على حروف إنجليزية صغيرة وأرقام و_ فقط، وبطول 3-20 حرفاً! (مثال: sponge_001)',
            style: BikiniTypography.body(color: BikiniColors.card),
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
            backgroundColor: BikiniColors.danger,
            content: Text(
              'خطأ في التسجيل: $errorMsg',
              style: BikiniTypography.body(color: BikiniColors.card),
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
          insetPadding: const EdgeInsets.symmetric(horizontal: BikiniRadius.screenMargin),
          child: Container(
            padding: const EdgeInsets.all(BikiniSpacing.space24),
            decoration: BikiniDecorations.interactiveCard(
              backgroundColor: BikiniColors.card,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top celebratory badge & icon
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: BikiniColors.support,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: BikiniColors.ink,
                      width: BikiniRadius.borderWidth,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      profile.speciesEmoji,
                      style: const TextStyle(fontSize: 42),
                    ),
                  ),
                ),

                const SizedBox(height: BikiniSpacing.space12),

                BikiniBadge.active(
                  text: 'رقم القيد الرسمي: ${profile.id}',
                ),

                const SizedBox(height: BikiniSpacing.space12),

                Text(
                  'أهلاً بيك رسمياً كمواطن في جمهورية قاع الهامور العظمى! 🪪✨',
                  style: BikiniTypography.h2(color: BikiniColors.deep),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: BikiniSpacing.space12),

                Container(
                  padding: const EdgeInsets.all(BikiniSpacing.space12),
                  decoration: BikiniDecorations.staticCard(
                    backgroundColor: BikiniColors.paper,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'يا مرحب بالمواطن "${profile.name}"، تم استخراج بطاقتك وتوثيقها بختم النسر المائي!',
                        style: BikiniTypography.body(color: BikiniColors.ink),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: BikiniSpacing.space4),
                      Text(
                        'دلوقتي تقدر تطلب سلطع برجر بالتقسيط، تشتكي شفيق للبلدية، وتشارك في رغي قهوة العم فيش! ☕🦀',
                        style: BikiniTypography.caption(color: BikiniColors.muted),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: BikiniSpacing.space24),

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
      backgroundColor: BikiniColors.paper,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: BikiniRadius.screenMargin,
              vertical: BikiniSpacing.space16,
            ),
            children: [
              // Nautical Header Card
              _buildHeaderCard(),

              const SizedBox(height: BikiniSpacing.space16),

              // Live ID Card Preview
              _buildLiveCardPreview(),

              const SizedBox(height: BikiniSpacing.space16),

              // Form: Citizen Name
              _buildNameField(),

              const SizedBox(height: BikiniSpacing.space8),

              // Permanent Name Warning Alert
              _buildPermanentNameAlert(),

              const SizedBox(height: BikiniSpacing.space16),

              // Form: Citizen Handle (@handle)
              _buildHandleField(),

              const SizedBox(height: BikiniSpacing.space16),

              // Form: Species Selector
              _buildSpeciesSelector(),

              const SizedBox(height: BikiniSpacing.space24),

              // Action Button to Issue ID (Single Primary Yellow Button on screen)
              BikiniButton.primary(
                onPressed: _isLoading ? null : _handleIssueId,
                text: _isLoading ? 'جاري استخراج البطاقة وتوثيقها... ⏳' : 'استخرج بطاقة مواطن قاع الهامور 🌊',
                isFullWidth: true,
                height: 52,
              ),

              const SizedBox(height: BikiniSpacing.space32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(BikiniSpacing.space16),
      decoration: BikiniDecorations.interactiveCard(
        backgroundColor: BikiniColors.card,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: BikiniColors.support,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: BikiniColors.ink,
                    width: BikiniRadius.borderWidth,
                  ),
                ),
                child: const Text('🏛️', style: TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: BikiniSpacing.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ديوان السجل المدني والتجنيد',
                      style: BikiniTypography.h2(color: BikiniColors.deep),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'جمهورية قاع الهامور العظمى 🔱',
                      style: BikiniTypography.caption(color: BikiniColors.muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: BikiniSpacing.space8),
              const BikiniBadge(
                text: 'تسجيل رسمي',
                backgroundColor: BikiniColors.support,
                textColor: BikiniColors.ink,
              ),
            ],
          ),
          const SizedBox(height: BikiniSpacing.space12),
          const Divider(color: BikiniColors.line, thickness: 1.5),
          const SizedBox(height: BikiniSpacing.space8),
          Text(
            'استخرج بطاقة هويتك المائية وسجل بياناتك عشان تدخل الجمهورية وتاخد حصتك التموينية من سبونج بوب!',
            style: BikiniTypography.body(color: BikiniColors.ink),
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
      padding: const EdgeInsets.all(BikiniSpacing.space16),
      decoration: BikiniDecorations.interactiveCard(
        backgroundColor: BikiniColors.card,
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
                    const SizedBox(width: BikiniSpacing.space8),
                    Flexible(
                      child: Text(
                        'جمهورية قاع الهامور',
                        style: BikiniTypography.h3(color: BikiniColors.deep),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: BikiniSpacing.space8),
              const BikiniBadge(
                text: 'معاينة حية 👁️',
                backgroundColor: BikiniColors.support,
                textColor: BikiniColors.ink,
              ),
            ],
          ),
          const SizedBox(height: BikiniSpacing.space8),
          const Divider(color: BikiniColors.line, thickness: 1.5),
          const SizedBox(height: BikiniSpacing.space8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar box
              Container(
                width: 72,
                height: 88,
                decoration: BoxDecoration(
                  color: BikiniColors.paper,
                  borderRadius: BorderRadius.circular(BikiniRadius.button),
                  border: Border.all(
                    color: BikiniColors.ink,
                    width: BikiniRadius.borderWidth,
                  ),
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
                      style: BikiniTypography.caption(color: BikiniColors.muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: BikiniSpacing.space12),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الاسم: $name',
                      style: BikiniTypography.label(color: BikiniColors.ink),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'المهنة: مواطن مائي 🌊',
                      style: BikiniTypography.caption(color: BikiniColors.muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'التهمة: بدون سوابق',
                      style: BikiniTypography.caption(color: BikiniColors.alert),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'القبيلة: ${_selectedSpecies.defaultClan}',
                      style: BikiniTypography.caption(color: BikiniColors.muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: BikiniSpacing.space8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'ختم النسر المائي 🦅',
                  style: BikiniTypography.caption(color: BikiniColors.alert),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: BikiniSpacing.space8),
              Text(
                'الرقم: 2980710001',
                style: BikiniTypography.mono(color: BikiniColors.muted),
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
          style: BikiniTypography.h3(color: BikiniColors.deep),
        ),
        const SizedBox(height: BikiniSpacing.space8),
        Container(
          decoration: BikiniDecorations.staticCard(
            backgroundColor: BikiniColors.card,
            radius: BikiniRadius.button,
          ),
          child: TextField(
            controller: _nameController,
            onChanged: (_) => setState(() {}),
            style: BikiniTypography.body(color: BikiniColors.ink),
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
      padding: const EdgeInsets.all(BikiniSpacing.space12),
      decoration: BoxDecoration(
        color: BikiniColors.paper,
        borderRadius: BorderRadius.circular(BikiniRadius.button),
        border: Border.all(
          color: BikiniColors.alert,
          width: BikiniRadius.borderWidth,
        ),
      ),
      child: Row(
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 22)),
          const SizedBox(width: BikiniSpacing.space8),
          Expanded(
            child: Text(
              'تنبيه هام: الاسم الرسمي ثابت مدى الحياة ولا يمكن تغييره إطلاقاً بعد التسجيل بقرار ديوان السجل المدني!',
              style: BikiniTypography.caption(color: BikiniColors.alert),
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
          style: BikiniTypography.h3(color: BikiniColors.deep),
        ),
        const SizedBox(height: BikiniSpacing.space4),
        Text(
          'حروف إنجليزية صغيرة وأرقام و_ فقط (من 3 إلى 20 حرفاً)',
          style: BikiniTypography.caption(color: BikiniColors.muted),
        ),
        const SizedBox(height: BikiniSpacing.space8),
        Container(
          decoration: BikiniDecorations.staticCard(
            backgroundColor: BikiniColors.card,
            radius: BikiniRadius.button,
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: TextField(
              controller: _handleController,
              onChanged: (_) => setState(() {}),
              style: BikiniTypography.mono(color: BikiniColors.ink),
              decoration: InputDecoration(
                prefixText: '@ ',
                prefixStyle: BikiniTypography.mono(color: BikiniColors.support),
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
          '٣. فصيلة الكائن البحري 🧬',
          style: BikiniTypography.h3(color: BikiniColors.deep),
        ),
        const SizedBox(height: BikiniSpacing.space8),
        Wrap(
          spacing: BikiniSpacing.space8,
          runSpacing: BikiniSpacing.space8,
          children: CitizenService.availableSpecies.map((species) {
            final isSelected = species.name == _selectedSpecies.name;
            return GestureDetector(
              onTap: () => setState(() => _selectedSpecies = species),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? BikiniColors.support
                      : BikiniColors.card,
                  borderRadius: BorderRadius.circular(BikiniRadius.button),
                  border: Border.all(
                    color: BikiniColors.ink,
                    width: BikiniRadius.borderWidth,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: BikiniColors.ink,
                      offset: isSelected ? const Offset(1, 1) : const Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(species.emoji, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: BikiniSpacing.space8),
                    Text(
                      species.name,
                      style: BikiniTypography.label(
                        color: isSelected ? BikiniColors.ink : BikiniColors.muted,
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

