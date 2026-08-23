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
          backgroundColor: BikiniColors.warmSand,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: BikiniColors.cartoonBlack, width: 3.5),
          ),
          title: Row(
            children: [
              const Text('📸', style: TextStyle(fontSize: 26)),
              const SizedBox(width: 8),
              Text(
                'تم حفظ البطاقة بنجاح!',
                style: BikiniTypography.displaySmall().copyWith(fontSize: 16),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: BikiniColors.spongeYellow,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: BikiniColors.cartoonBlack, width: 2),
                ),
                child: Text(
                  img != null
                      ? 'تم تجهيز صورة بطاقة الرقم القومي البحرية بدقة HD (3x) للرفع والمشاركة على مواقع التواصل القاعي! 🌊🎉'
                      : 'تم التقاط صورة بطاقة الرقم القومي بنجاح! 🌊',
                  style: BikiniTypography.bodyMedium().copyWith(fontSize: 12.5),
                ),
              ),
            ],
          ),
          actions: [
            BikiniButton.primary(
              onPressed: () => Navigator.pop(ctx),
              text: 'مباشرة العيشة في القاع ⚓',
              height: 40,
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
          backgroundColor: BikiniColors.cartoonBlack,
          content: Text(
            'تم تحديث الهاندل البحري لـ $formatted بنجاح! 🏷️',
            style: BikiniTypography.bodyMedium(color: BikiniColors.spongeYellow),
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
      backgroundColor: BikiniColors.warmSand,
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
                  style: BikiniTypography.titleBold(),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          style: BikiniTypography.titleBold().copyWith(fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      BikiniBadge(
                        text: 'انقر لقلب البطاقة 🔄',
                        backgroundColor: BikiniColors.spongeYellow,
                        fontSize: 9.5,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 3D Flippable Sea ID Card
                  EgyptianSeaIdCard(
                    profile: profile,
                    boundaryKey: _cardBoundaryKey,
                  ),

                  const SizedBox(height: 14),

                  // Export PNG Button
                  BikiniButton.primary(
                    onPressed: _exportCardPng,
                    text: '📸 حفظ البطاقة كصورة (Export PNG)',
                    isFullWidth: true,
                    height: 44,
                  ),

                  const SizedBox(height: 18),

                  // Unique Handle Editor Section
                  _buildHandleEditorSection(profile),

                  const SizedBox(height: 18),

                  // Interactive Avatar Studio Section
                  _buildAvatarStudioSection(profile),

                  const SizedBox(height: 30),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BikiniColors.pureWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: BikiniColors.cartoonBlack, width: 2.8),
        boxShadow: const [
          BoxShadow(
            color: BikiniColors.cartoonBlack,
            offset: Offset(3.5, 3.5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🏷️', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'الهاندل البحري الفريد (Unique Handle):',
                  style: BikiniTypography.titleBold().copyWith(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: BikiniColors.warmSand,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: BikiniColors.cartoonBlack, width: 1.8),
                  ),
                  child: TextField(
                    controller: _handleController,
                    style: BikiniTypography.bodyMedium().copyWith(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: '@username',
                      hintStyle: BikiniTypography.inputHint(),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              BikiniButton.secondary(
                onPressed: _updateHandle,
                text: 'حفظ 🏷️',
                height: 42,
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BikiniColors.pureWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: BikiniColors.cartoonBlack, width: 2.8),
        boxShadow: const [
          BoxShadow(
            color: BikiniColors.cartoonBlack,
            offset: Offset(3.5, 3.5),
            blurRadius: 0,
          ),
        ],
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
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'استوديو تخصيص الآفاتار 🎨',
                      style: BikiniTypography.titleBold().copyWith(fontSize: 14),
                    ),
                    Text(
                      'غير الفصيلة، التعبيرات، الطاقية، والملابس بحرية!',
                      style: BikiniTypography.caption(color: const Color(0xFF555555))
                          .copyWith(fontSize: 10.5),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(color: BikiniColors.cartoonBlack, height: 1, thickness: 1.5),
          const SizedBox(height: 12),

          // 1. Body Type Picker
          Text('١. فصيلة الكائن:', style: BikiniTypography.titleBold().copyWith(fontSize: 12)),
          const SizedBox(height: 6),
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
                      style: BikiniTypography.captionBold(
                        color: isSelected ? BikiniColors.cartoonBlack : const Color(0xFF444444),
                      ).copyWith(fontSize: 11),
                    ),
                    selected: isSelected,
                    selectedColor: BikiniColors.spongeYellow,
                    backgroundColor: BikiniColors.warmSand,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: BikiniColors.cartoonBlack, width: 1.5),
                    ),
                    onSelected: (_) {
                      _updateAvatarConfig(avatar.copyWith(bodyType: type));
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // 2. Expression Picker
          Text('٢. ملامح الوجه والعيون:', style: BikiniTypography.titleBold().copyWith(fontSize: 12)),
          const SizedBox(height: 6),
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
                      style: BikiniTypography.captionBold(
                        color: isSelected ? BikiniColors.cartoonBlack : const Color(0xFF444444),
                      ).copyWith(fontSize: 11),
                    ),
                    selected: isSelected,
                    selectedColor: BikiniColors.marineCyan,
                    backgroundColor: BikiniColors.warmSand,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: BikiniColors.cartoonBlack, width: 1.5),
                    ),
                    onSelected: (_) {
                      _updateAvatarConfig(avatar.copyWith(expression: expr));
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // 3. Hat / Hair Picker
          Text('٣. الطاقية / الشعر:', style: BikiniTypography.titleBold().copyWith(fontSize: 12)),
          const SizedBox(height: 6),
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
                      style: BikiniTypography.captionBold(
                        color: isSelected ? BikiniColors.cartoonBlack : const Color(0xFF444444),
                      ).copyWith(fontSize: 11),
                    ),
                    selected: isSelected,
                    selectedColor: BikiniColors.neonPink.withValues(alpha: 0.4),
                    backgroundColor: BikiniColors.warmSand,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: BikiniColors.cartoonBlack, width: 1.5),
                    ),
                    onSelected: (_) {
                      _updateAvatarConfig(avatar.copyWith(hat: hat));
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // 4. Outfit Picker
          Text('٤. الملابس والبدلة:', style: BikiniTypography.titleBold().copyWith(fontSize: 12)),
          const SizedBox(height: 6),
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
                      style: BikiniTypography.captionBold(
                        color: isSelected ? BikiniColors.cartoonBlack : const Color(0xFF444444),
                      ).copyWith(fontSize: 11),
                    ),
                    selected: isSelected,
                    selectedColor: BikiniColors.spongeYellow,
                    backgroundColor: BikiniColors.warmSand,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: BikiniColors.cartoonBlack, width: 1.5),
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
