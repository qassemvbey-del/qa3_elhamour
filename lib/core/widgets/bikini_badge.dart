import 'package:flutter/material.dart';
import '../theme/bikini_theme.dart';

/// Cartoon Pill Badge for statuses, categories, and satirical labels
class BikiniBadge extends StatelessWidget {
  final String text;
  final Widget? icon;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final Offset shadowOffset;

  const BikiniBadge({
    super.key,
    required this.text,
    this.icon,
    this.backgroundColor = BikiniColors.spongeYellow,
    this.textColor = BikiniColors.cartoonBlack,
    this.borderColor = BikiniColors.cartoonBlack,
    this.fontSize = 11.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    this.shadowOffset = const Offset(2, 2),
  });

  /// Factory for locked/coming soon status
  factory BikiniBadge.locked({
    String text = '🔒 قريباً',
    double fontSize = 10.0,
  }) {
    return BikiniBadge(
      text: text,
      backgroundColor: const Color(0xFFFFD166),
      textColor: BikiniColors.cartoonBlack,
      fontSize: fontSize,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      shadowOffset: const Offset(1.5, 1.5),
    );
  }

  /// Factory for breaking news badge
  factory BikiniBadge.breaking({
    String text = '⚡ عاجل',
  }) {
    return BikiniBadge(
      text: text,
      backgroundColor: BikiniColors.krabsRed,
      textColor: BikiniColors.pureWhite,
      fontSize: 11.0,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      shadowOffset: const Offset(2, 2),
    );
  }

  /// Factory for trending / hot badge
  factory BikiniBadge.trending({
    String text = '🔥 تريند القاع',
  }) {
    return BikiniBadge(
      text: text,
      backgroundColor: BikiniColors.neonPink,
      textColor: BikiniColors.pureWhite,
      fontSize: 11.0,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      shadowOffset: const Offset(2, 2),
    );
  }

  /// Factory for active official badge
  factory BikiniBadge.active({
    String text = '✨ متاح الآن',
  }) {
    return BikiniBadge(
      text: text,
      backgroundColor: BikiniColors.marineCyan,
      textColor: BikiniColors.cartoonBlack,
      fontSize: 10.0,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      shadowOffset: const Offset(1.5, 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: borderColor,
          width: 1.8,
        ),
        boxShadow: [
          BoxShadow(
            color: BikiniColors.cartoonBlack,
            offset: shadowOffset,
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 3),
          ],
          Flexible(
            child: Text(
              text,
              style: BikiniTypography.captionBold(color: textColor).copyWith(
                fontSize: fontSize,
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
