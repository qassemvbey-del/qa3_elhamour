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
    this.backgroundColor = BikiniColors.card,
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
    final currentShadow = _isPressed ? const Offset(1, 1) : const Offset(3.0, 3.0);
    final currentTranslation = _isPressed ? const Offset(2.0, 2.0) : Offset.zero;

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
        padding: const EdgeInsets.all(BikiniSpacing.space12),
        decoration: BoxDecoration(
          color: item.backgroundColor,
          borderRadius: BorderRadius.circular(BikiniRadius.card),
          border: Border.all(
            color: BikiniColors.ink,
            width: BikiniRadius.borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: BikiniColors.ink,
              offset: currentShadow,
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
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
                    color: BikiniColors.paper,
                    borderRadius: BorderRadius.circular(BikiniRadius.button),
                    border: Border.all(
                      color: BikiniColors.ink,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      item.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: BikiniSpacing.space4),
                Flexible(
                  child: item.isLocked
                      ? BikiniBadge.locked()
                      : BikiniBadge.active(),
                ),
              ],
            ),

            const SizedBox(height: BikiniSpacing.space8),

            // Title & Description in Cairo
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  style: BikiniTypography.h3(color: BikiniColors.deep),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: BikiniSpacing.space4),
                Text(
                  item.subtitle,
                  style: BikiniTypography.caption(color: BikiniColors.muted),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

