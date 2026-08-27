import 'package:flutter/material.dart';
import '../../../core/avatar/marine_avatar_renderer.dart';
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
          margin: const EdgeInsets.symmetric(
            horizontal: BikiniRadius.screenMargin,
            vertical: BikiniSpacing.space8,
          ),
          padding: const EdgeInsets.all(BikiniSpacing.space16),
          decoration: BikiniDecorations.interactiveCard(
            backgroundColor: BikiniColors.card,
          ),
          child: Column(
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
                      backgroundColor: BikiniColors.support,
                      textColor: BikiniColors.ink,
                      fontSize: 11.5,
                    ),
                  ),
                  const SizedBox(width: BikiniSpacing.space8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: BikiniColors.paper,
                      borderRadius: BorderRadius.circular(BikiniRadius.button),
                      border: Border.all(
                        color: BikiniColors.ink,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🦅', style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          'ختم النسر المائي',
                          style: BikiniTypography.caption(
                            color: BikiniColors.alert,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: BikiniSpacing.space12),

              // Title & Body
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
                          style: BikiniTypography.h2(
                            color: BikiniColors.deep,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: BikiniSpacing.space4),
                        Text(
                          hasProfile
                              ? 'مهنتك: ${profile.job} • التهمة: ${profile.crime}'
                              : 'طلّع بطاقتك الرسمية بالصورة ورمز القبيلة، واعرف حصتك التموينية من سبونج بوب وسلطع برجر!',
                          style: BikiniTypography.caption(
                            color: BikiniColors.muted,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: BikiniSpacing.space12),
                  // Avatar Illustration
                  hasProfile
                      ? MarineAvatarRenderer(
                          config: profile.avatarConfig,
                          size: 56,
                          showBackground: true,
                        )
                      : Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: BikiniColors.paper,
                            borderRadius: BorderRadius.circular(BikiniRadius.button),
                            border: Border.all(
                              color: BikiniColors.ink,
                              width: BikiniRadius.borderWidth,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '🪪',
                              style: TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                ],
              ),

              const SizedBox(height: BikiniSpacing.space16),

              // Primary Yellow Action Button
              BikiniButton.primary(
                onPressed: onExtractIdTap,
                text: hasProfile
                    ? 'عرض بطاقتك وسجل العائلة 🪪'
                    : 'استخرج بطاقتك يا باشا دلوقتي 🌊',
                isFullWidth: true,
                height: 48,
              ),
            ],
          ),
        );
      },
    );
  }
}

