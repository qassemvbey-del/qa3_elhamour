import 'package:flutter/material.dart';
import '../../../core/services/citizen_service.dart';
import '../../../core/theme/bikini_theme.dart';
import '../../../core/widgets/bikini_badge.dart';
import '../../../core/widgets/bikini_button.dart';

/// Hero Bento Card for the Citizen Civil ID generator CTA / Citizen Profile Showcase
class HeroBentoCard extends StatelessWidget {
  final VoidCallback onExtractIdTap;

  const HeroBentoCard({
    super.key,
    required this.onExtractIdTap,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CitizenProfile?>(
      valueListenable: CitizenService.instance.currentProfile,
      builder: (context, profile, _) {
        final hasProfile = profile != null;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: hasProfile ? BikiniColors.marineCyan : BikiniColors.spongeYellow,
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
          child: Stack(
            children: [
              // Background decorative bubble
              Positioned(
                left: -10,
                bottom: -10,
                child: Opacity(
                  opacity: 0.15,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: BikiniColors.oceanBlue,
                    ),
                  ),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Badges Row with Flexible protection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: BikiniBadge(
                          text: hasProfile
                              ? '🪪 بطاقة المواطن (${profile.id})'
                              : '🪪 السجل المدني البحري',
                          backgroundColor: hasProfile
                              ? BikiniColors.spongeYellow
                              : BikiniColors.marineCyan,
                          textColor: BikiniColors.cartoonBlack,
                          fontSize: 10.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: BikiniColors.pureWhite,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: BikiniColors.cartoonBlack,
                            width: 1.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🦅', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text(
                              'ختم النسر المائي',
                              style: BikiniTypography.captionBold(
                                color: BikiniColors.krabsRed,
                              ).copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Title in Lalezar bold & Body in Cairo
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hasProfile
                                  ? 'يا هلا بالمواطن ${profile.name}!'
                                  : 'استخرج بطاقة مواطن جمهورية قاع الهامور!',
                              style: BikiniTypography.displayMedium(
                                color: BikiniColors.deepNavy,
                              ).copyWith(
                                fontSize: 19,
                                height: 1.25,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hasProfile
                                  ? 'مهنتك: ${profile.job} • التهمة: ${profile.crime}'
                                  : 'طلّع بطاقتك الرسمية بالصورة ورمز القبيلة، واعرف حصتك التموينية من سبونج بوب وسلطع برجر!',
                              style: BikiniTypography.bodyMedium(
                                color: const Color(0xFF2B2B2B),
                              ).copyWith(fontSize: 12.5),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Avatar Illustration
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: BikiniColors.pureWhite,
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
                        child: Center(
                          child: Text(
                            hasProfile ? profile.speciesEmoji : '🪪',
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Interactive CTA Button
                  BikiniButton(
                    onPressed: onExtractIdTap,
                    backgroundColor: BikiniColors.oceanBlue,
                    textColor: BikiniColors.spongeYellow,
                    isFullWidth: true,
                    height: 46,
                    customChild: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('✨', style: TextStyle(fontSize: 15)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            hasProfile
                                ? 'عرض بطاقتك وسجل العائلة 🪪'
                                : 'استخرج بطاقتك يا باشا دلوقتي',
                            style: BikiniTypography.titleBold(
                              color: BikiniColors.spongeYellow,
                            ).copyWith(fontSize: 13.5),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: BikiniColors.spongeYellow,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
