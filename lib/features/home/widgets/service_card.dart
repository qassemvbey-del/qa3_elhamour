import 'package:flutter/material.dart';
import '../../../core/theme/bikini_theme.dart';
import '../../../core/widgets/bikini_badge.dart';

/// Data model for each city service
class BikiniServiceItem {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final Color backgroundColor;
  final bool isLocked;
  final String? lockReason;
  final int? targetTabIndex;

  const BikiniServiceItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.backgroundColor,
    this.isLocked = false,
    this.lockReason,
    this.targetTabIndex,
  });
}

/// Cartoon Neo-Brutalist Service Card Widget for Bento Grid
class ServiceCard extends StatefulWidget {
  final BikiniServiceItem item;
  final Function(BikiniServiceItem) onTap;

  const ServiceCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final currentShadow = _isPressed ? const Offset(1, 1) : const Offset(3.5, 3.5);
    final currentTranslation = _isPressed ? const Offset(2.5, 2.5) : Offset.zero;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () => widget.onTap(item),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOutQuad,
        transform: Matrix4.translationValues(
          currentTranslation.dx,
          currentTranslation.dy,
          0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: item.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: BikiniColors.cartoonBlack,
            width: 2.8,
          ),
          boxShadow: [
            BoxShadow(
              color: BikiniColors.cartoonBlack,
              offset: currentShadow,
              blurRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Watermark emoji in the corner
            Positioned(
              left: -6,
              bottom: -6,
              child: Opacity(
                opacity: 0.12,
                child: Text(
                  item.emoji,
                  style: const TextStyle(fontSize: 42),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top row: Emoji Icon & Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: BikiniColors.pureWhite,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: BikiniColors.cartoonBlack,
                          width: 2.0,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: BikiniColors.cartoonBlack,
                            offset: Offset(1.5, 1.5),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          item.emoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: item.isLocked
                          ? BikiniBadge.locked()
                          : BikiniBadge.active(),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Title & Description in Cairo
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: BikiniTypography.titleBold(
                        color: BikiniColors.cartoonBlack,
                      ).copyWith(
                        fontSize: 13.5,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: BikiniTypography.bodyRegular(
                        color: const Color(0xFF333333),
                      ).copyWith(
                        fontSize: 10.5,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
