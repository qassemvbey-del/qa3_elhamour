import 'package:flutter/material.dart';
import '../../core/avatar/marine_avatar_config.dart';
import '../../core/avatar/marine_avatar_renderer.dart';
import '../../core/services/citizen_service.dart';
import '../../core/theme/bikini_theme.dart';
import '../../core/widgets/bikini_badge.dart';
import '../../core/widgets/bikini_button.dart';
import '../../core/widgets/wooden_top_bar.dart';
import '../home/widgets/notifications_modal.dart';
import 'widgets/egyptian_sea_id_card.dart';

/// Civil ID & Custom Marine Avatar Studio Screen for "جمهورية قاع الهامور"
class CivilIdScreen extends StatefulWidget {
  const CivilIdScreen({super.key});

  @override
  State<CivilIdScreen> createState() => _CivilIdScreenState();
}

class _CivilIdScreenState extends State<CivilIdScreen> {
  final GlobalKey _cardBoundaryKey = GlobalKey();
  final TextEditingController _handleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profile = CitizenService.instance.currentProfile.value;
    if (profile != null) {
      _handleController.text = profile.handle;
    }
  }

  @override
  void dispose() {
    _handleController.dispose();
    super.dispose();
  }

  void _exportCardPng() async {
    final img = await _cardBoundaryKey.captureAsImage();

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: BikiniColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BikiniRadius.card),
            side: const BorderSide(color: BikiniColors.ink, width: BikiniRadius.borderWidth),
          ),
          title: Row(
            children: [
              const Text('📸', style: TextStyle(fontSize: 26)),
              const SizedBox(width: BikiniSpacing.space8),
              Text(
                'تم حفظ البطاقة بنجاح!',
                style: BikiniTypography.h2(color: BikiniColors.deep),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(BikiniSpacing.space12),
                decoration: BoxDecoration(
                  color: BikiniColors.paper,
                  borderRadius: BorderRadius.circular(BikiniRadius.button),
                  border: Border.all(color: BikiniColors.ink, width: 1.5),
                ),
                child: Text(
                  img != null
                      ? 'تم تجهيز صورة بطاقة الرقم القومي البحرية بدقة HD (3x) للرفع والمشاركة على مواقع التواصل القاعي! 🌊🎉'
                      : 'تم التقاط صورة بطاقة الرقم القومي بنجاح! 🌊',
                  style: BikiniTypography.body(color: BikiniColors.ink),
                ),
              ),
            ],
          ),
          actions: [
            BikiniButton.primary(
              onPressed: () => Navigator.pop(ctx),
              text: 'مباشرة العيشة في القاع ⚓',
              height: 48,
            ),
          ],
        ),
      ),
    );
  }

  void _updateHandle() {
    final text = _handleController.text.trim();
    if (text.isEmpty) return;

    final formatted = text.startsWith('@') ? text : '@$text';
    final current = CitizenService.instance.currentProfile.value;
    if (current != null) {
      final updated = current.copyWith(handle: formatted);
      CitizenService.instance.updateProfile(updated);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: BikiniColors.deep,
          content: Text(
            'تم تحديث الهاندل البحري لـ $formatted بنجاح! 🏷️',
            style: BikiniTypography.body(color: BikiniColors.card),
          ),
        ),
      );
    }
  }

  void _updateAvatarConfig(MarineAvatarConfig newConfig) {
    final current = CitizenService.instance.currentProfile.value;
    if (current != null) {
      final updated = current.copyWith(avatarConfig: newConfig);
      CitizenService.instance.updateProfile(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BikiniColors.paper,
      appBar: WoodenTopBar(
        title: 'السجل المدني والآفاتار',
        unreadCount: 3,
        onNotificationTap: () => NotificationsModal.show(context),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<CitizenProfile?>(
          valueListenable: CitizenService.instance.currentProfile,
          builder: (context, profile, _) {
            if (profile == null) {
              return Center(
                child: Text(
                  'لم يتم استخراج بطاقة مواطن بعد! 🌊',
                  style: BikiniTypography.h2(color: BikiniColors.deep),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: BikiniRadius.screenMargin,
                vertical: BikiniSpacing.space12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Section Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'بطاقة تحقيق الشخصية البحرية 🆔',
                          style: BikiniTypography.h3(color: BikiniColors.deep),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: BikiniSpacing.space8),
                      const BikiniBadge(
                        text: 'انقر لقلب البطاقة 🔄',
                        backgroundColor: BikiniColors.support,
                        textColor: BikiniColors.ink,
                      ),
                    ],
                  ),

                  const SizedBox(height: BikiniSpacing.space12),

                  // 3D Flippable Sea ID Card
                  EgyptianSeaIdCard(
                    profile: profile,
                    boundaryKey: _cardBoundaryKey,
                  ),

                  const SizedBox(height: BikiniSpacing.space16),

                  // Export PNG Button (The ONLY Primary Yellow Button on screen)
                  BikiniButton.primary(
                    onPressed: _exportCardPng,
                    text: '📸 حفظ البطاقة كصورة (Export PNG)',
                    isFullWidth: true,
                    height: 48,
                  ),

                  const SizedBox(height: BikiniSpacing.space16),

                  // Unique Handle Editor Section
                  _buildHandleEditorSection(profile),

                  const SizedBox(height: BikiniSpacing.space16),

                  // Interactive Avatar Studio Section
                  _buildAvatarStudioSection(profile),

                  const SizedBox(height: BikiniRadius.navBarClearance),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHandleEditorSection(CitizenProfile profile) {
    return Container(
      padding: const EdgeInsets.all(BikiniSpacing.space16),
      decoration: BikiniDecorations.interactiveCard(
        backgroundColor: BikiniColors.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🏷️', style: TextStyle(fontSize: 20)),
              const SizedBox(width: BikiniSpacing.space8),
              Expanded(
                child: Text(
                  'الهاندل البحري الفريد (Unique Handle):',
                  style: BikiniTypography.h3(color: BikiniColors.deep),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: BikiniSpacing.space8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: BikiniColors.paper,
                    borderRadius: BorderRadius.circular(BikiniRadius.button),
                    border: Border.all(color: BikiniColors.ink, width: 1.5),
                  ),
                  child: TextField(
                    controller: _handleController,
                    style: BikiniTypography.mono(color: BikiniColors.ink),
                    decoration: InputDecoration(
                      hintText: '@username',
                      hintStyle: BikiniTypography.inputHint(),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: BikiniSpacing.space8),
              BikiniButton.secondary(
                onPressed: _updateHandle,
                text: 'حفظ 🏷️',
                height: 48,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarStudioSection(CitizenProfile profile) {
    final avatar = profile.avatarConfig;

    return Container(
      padding: const EdgeInsets.all(BikiniSpacing.space16),
      decoration: BikiniDecorations.interactiveCard(
        backgroundColor: BikiniColors.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MarineAvatarRenderer(
                config: avatar,
                size: 54,
                showBackground: true,
              ),
              const SizedBox(width: BikiniSpacing.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'استوديو تخصيص الآفاتار 🎨',
                      style: BikiniTypography.h3(color: BikiniColors.deep),
                    ),
                    Text(
                      'غير الفصيلة، التعبيرات، الطاقية، والملابس بحرية!',
                      style: BikiniTypography.caption(color: BikiniColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: BikiniSpacing.space12),
          const Divider(color: BikiniColors.line, thickness: 1.5),
          const SizedBox(height: BikiniSpacing.space12),

          // 1. Body Type Picker
          Text('١. فصيلة الكائن:', style: BikiniTypography.label(color: BikiniColors.deep)),
          const SizedBox(height: BikiniSpacing.space8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: MarineBodyType.values.map((type) {
                final isSelected = avatar.bodyType == type;
                return Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: FilterChip(
                    label: Text(
                      _getBodyTypeName(type),
                      style: BikiniTypography.caption(
                        color: isSelected ? BikiniColors.ink : BikiniColors.muted,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: BikiniColors.support,
                    backgroundColor: BikiniColors.paper,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(BikiniRadius.button),
                      side: const BorderSide(color: BikiniColors.ink, width: 1.5),
                    ),
                    onSelected: (_) {
                      _updateAvatarConfig(avatar.copyWith(bodyType: type));
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: BikiniSpacing.space12),

          // 2. Expression Picker
          Text('٢. ملامح الوجه والعيون:', style: BikiniTypography.label(color: BikiniColors.deep)),
          const SizedBox(height: BikiniSpacing.space8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: MarineExpression.values.map((expr) {
                final isSelected = avatar.expression == expr;
                return Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: FilterChip(
                    label: Text(
                      _getExpressionName(expr),
                      style: BikiniTypography.caption(
                        color: isSelected ? BikiniColors.ink : BikiniColors.muted,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: BikiniColors.support,
                    backgroundColor: BikiniColors.paper,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(BikiniRadius.button),
                      side: const BorderSide(color: BikiniColors.ink, width: 1.5),
                    ),
                    onSelected: (_) {
                      _updateAvatarConfig(avatar.copyWith(expression: expr));
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: BikiniSpacing.space12),

          // 3. Hat / Hair Picker
          Text('٣. الطاقية / الشعر:', style: BikiniTypography.label(color: BikiniColors.deep)),
          const SizedBox(height: BikiniSpacing.space8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: MarineHat.values.map((hat) {
                final isSelected = avatar.hat == hat;
                return Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: FilterChip(
                    label: Text(
                      _getHatName(hat),
                      style: BikiniTypography.caption(
                        color: isSelected ? BikiniColors.ink : BikiniColors.muted,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: BikiniColors.support,
                    backgroundColor: BikiniColors.paper,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(BikiniRadius.button),
                      side: const BorderSide(color: BikiniColors.ink, width: 1.5),
                    ),
                    onSelected: (_) {
                      _updateAvatarConfig(avatar.copyWith(hat: hat));
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: BikiniSpacing.space12),

          // 4. Outfit Picker
          Text('٤. الملابس والبدلة:', style: BikiniTypography.label(color: BikiniColors.deep)),
          const SizedBox(height: BikiniSpacing.space8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: MarineOutfit.values.map((outfit) {
                final isSelected = avatar.outfit == outfit;
                return Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: FilterChip(
                    label: Text(
                      _getOutfitName(outfit),
                      style: BikiniTypography.caption(
                        color: isSelected ? BikiniColors.ink : BikiniColors.muted,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: BikiniColors.support,
                    backgroundColor: BikiniColors.paper,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(BikiniRadius.button),
                      side: const BorderSide(color: BikiniColors.ink, width: 1.5),
                    ),
                    onSelected: (_) {
                      _updateAvatarConfig(avatar.copyWith(outfit: outfit));
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _getBodyTypeName(MarineBodyType type) {
    switch (type) {
      case MarineBodyType.sponge:
        return '🧽 إسفنجة';
      case MarineBodyType.starfish:
        return '⭐ نجم بحر';
      case MarineBodyType.squid:
        return '🐙 أخطبوط';
      case MarineBodyType.crab:
        return '🦀 سرطان';
      case MarineBodyType.squirrel:
        return '🐿️ سنجاب';
      case MarineBodyType.fish:
        return '🐟 سمكة';
    }
  }

  String _getExpressionName(MarineExpression expr) {
    switch (expr) {
      case MarineExpression.happy:
        return '😀 سعيد ومسطول';
      case MarineExpression.bored:
        return '😒 زهقان من شفيق';
      case MarineExpression.angry:
        return '😡 غاضب مثل سلطع';
      case MarineExpression.dumb:
        return '🤪 غبي مثل بسيط';
    }
  }

  String _getHatName(MarineHat hat) {
    switch (hat) {
      case MarineHat.none:
        return 'بدون طاقية';
      case MarineHat.krustyVisor:
        return '🧢 كاب مقرمشات سلطع';
      case MarineHat.pirateHat:
        return '🏴‍☠️ طاقية قراصنة';
      case MarineHat.squidWig:
        return '💇‍♂️ باروكة شفيق';
      case MarineHat.kingCrown:
        return '👑 تاج الملك نبتون';
      case MarineHat.seaCap:
        return '⚓ كاب بحار';
    }
  }

  String _getOutfitName(MarineOutfit outfit) {
    switch (outfit) {
      case MarineOutfit.none:
        return 'بدون ملابس';
      case MarineOutfit.tieShirt:
        return '👔 كرافتة وقميص';
      case MarineOutfit.flowerTrunks:
        return '🩳 مايو شاطئ وردي';
      case MarineOutfit.bossSuit:
        return '💼 بدلة شياكة';
      case MarineOutfit.sailorShirt:
        return '⚓ قميص بحار';
    }
  }
}

