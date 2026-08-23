import 'package:flutter/material.dart';
import '../../core/services/citizen_service.dart';
import '../../core/theme/bikini_theme.dart';
import '../../core/widgets/bikini_badge.dart';
import '../../core/widgets/bikini_button.dart';
import '../../core/widgets/bikini_card.dart';
import '../../core/widgets/wooden_top_bar.dart';
import '../onboarding/citizen_onboarding_screen.dart';

/// Civil ID & Undersea Clan Registry Tab
class CivilIdScreen extends StatelessWidget {
  const CivilIdScreen({super.key});

  void _openEditProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: BikiniColors.warmSand,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: BikiniColors.cartoonBlack, width: 3.5),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: CitizenOnboardingScreen(
              onComplete: () => Navigator.of(ctx).pop(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BikiniColors.warmSand,
      appBar: const WoodenTopBar(
        title: 'السجل المدني البحري 🪪',
        unreadCount: 0,
      ),
      body: SafeArea(
        bottom: false,
        child: ValueListenableBuilder<CitizenProfile?>(
          valueListenable: CitizenService.instance.currentProfile,
          builder: (context, profile, _) {
            final hasProfile = profile != null;
            final citizenName = hasProfile ? profile.name : 'سبونج بوب سكوير بانتس';
            final citizenId = hasProfile ? profile.id : '#0001';
            final speciesEmoji = hasProfile ? profile.speciesEmoji : '🧽';
            final speciesName = hasProfile ? profile.species : 'إسفنجة بحرية';
            final citizenJob = hasProfile ? profile.job : 'شيف مقرمشات وملك البرجر 🍔';
            final citizenCrime = hasProfile ? profile.crime : 'سرقة سر الخلطة من خزنة سلطع 🍔';
            final citizenClan = hasProfile ? profile.clan : 'عشيرة الإسفنجيات والأناناس';
            final nationalNumber = hasProfile ? profile.nationalNumber : '29807140105432';
            final bloodType = hasProfile ? profile.bloodType : 'كتشب ومايونيز سلطع';

            return ListView(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 120),
              children: [
                // Header Intro Card
                BikiniCard(
                  backgroundColor: BikiniColors.marineCyan,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: BikiniColors.pureWhite,
                          shape: BoxShape.circle,
                          border: Border.all(color: BikiniColors.cartoonBlack, width: 2.0),
                        ),
                        child: const Text('🏛️', style: TextStyle(fontSize: 22)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'مكتب إصدار بطاقات الهوية المائية',
                              style: BikiniTypography.displaySmall().copyWith(fontSize: 17),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'موثقة ومعتمدة من ديوان قاع الهامور بختم النسر المائي!',
                              style: BikiniTypography.bodyMedium(color: const Color(0xFF333333))
                                  .copyWith(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Interactive Official Civil ID Card
                Container(
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
                      // Card Top Header
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
                                    'جمهورية قاع الهامور العظمى',
                                    style: BikiniTypography.titleBold(color: BikiniColors.deepNavy)
                                        .copyWith(fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          BikiniBadge.active(text: 'قيد: $citizenId'),
                        ],
                      ),

                      const SizedBox(height: 8),
                      const Divider(color: BikiniColors.cartoonBlack, thickness: 1.8),
                      const SizedBox(height: 6),

                      // Card Details Body
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar Photo Box
                          Container(
                            width: 72,
                            height: 90,
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
                                Text(speciesEmoji, style: const TextStyle(fontSize: 34)),
                                const SizedBox(height: 2),
                                Text(
                                  speciesName,
                                  style: BikiniTypography.captionBold().copyWith(fontSize: 8.5),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          // Text Info with Cairo readability
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الاسم: $citizenName',
                                  style: BikiniTypography.bodyLarge().copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'الرقم القومي: $nationalNumber',
                                  style: BikiniTypography.bodyMedium().copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'المهنة: $citizenJob',
                                  style: BikiniTypography.bodyMedium().copyWith(fontSize: 11.5),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'التهمة: $citizenCrime',
                                  style: BikiniTypography.bodyRegular(
                                    color: BikiniColors.krabsRed,
                                  ).copyWith(fontSize: 11.5),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'القبيلة: $citizenClan',
                                  style: BikiniTypography.caption().copyWith(fontSize: 11),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      // Card Stamp & Barcode
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: BikiniColors.krabsRed.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: BikiniColors.krabsRed, width: 1.2),
                              ),
                              child: Text(
                                'ختم النسر المائي 🦅',
                                style: BikiniTypography.captionBold(color: BikiniColors.krabsRed)
                                    .copyWith(fontSize: 9.5),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'فصيلة: $bloodType',
                              style: BikiniTypography.caption(color: const Color(0xFF555555))
                                  .copyWith(fontSize: 10),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Clan Options Header
                Text(
                  'قبائل وعشائر قاع الهامور 🔱',
                  style: BikiniTypography.displaySmall().copyWith(fontSize: 18),
                ),
                const SizedBox(height: 8),

                // Clan Selection Cards
                _buildClanItem(
                  title: 'عشيرة النجوم الكسلانة ⭐',
                  desc: 'بسيط نجم وأقاربه - تخصص نوم تحت الصخور وأكل رمال مجاناً',
                  color: const Color(0xFFFFCCD5),
                  icon: '⭐',
                ),
                const SizedBox(height: 8),
                _buildClanItem(
                  title: 'قبيلة القشريات أصحاب الفلوس 🦀',
                  desc: 'مستر سلطع وعائلته - لا يدفعون قرشاً واحداً ويحبون ريحة الدولار المائي',
                  color: const Color(0xFFFFE6A7),
                  icon: '🦀',
                ),
                const SizedBox(height: 8),
                _buildClanItem(
                  title: 'حلف الرخويات والمثقفين 🎺',
                  desc: 'شفيق وحبايبه - عزف كلارينيت مزعج وحب الفن التشكيلي المعقد',
                  color: const Color(0xFFD0E1FD),
                  icon: '🎺',
                ),

                const SizedBox(height: 16),

                BikiniButton.primary(
                  onPressed: () => _openEditProfile(context),
                  text: hasProfile
                      ? 'تعديل البيانات أو استخراج بدل فاقد 🔄'
                      : 'تسجيل وإصدار بطاقة هوية جديدة 🪪',
                  isFullWidth: true,
                  height: 48,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildClanItem({
    required String title,
    required String desc,
    required Color color,
    required String icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: BikiniColors.cartoonBlack,
          width: 2.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: BikiniColors.cartoonBlack,
            offset: Offset(2.5, 2.5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: BikiniTypography.titleBold().copyWith(fontSize: 13.5),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: BikiniTypography.bodyMedium().copyWith(fontSize: 11.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
