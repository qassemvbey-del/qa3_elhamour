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
    this.backgroundColor = BikiniColors.support,
    this.textColor = BikiniColors.ink,
    this.borderColor = BikiniColors.ink,
    this.fontSize = 11.5,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    this.shadowOffset = const Offset(1.5, 1.5),
  });

  /// Factory for locked/coming soon status
  factory BikiniBadge.locked({
    String text = '🔒 قريباً',
    double fontSize = 11.5,
  }) {
    return BikiniBadge(
      text: text,
      backgroundColor: BikiniColors.line,
      textColor: BikiniColors.ink,
      fontSize: fontSize,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      shadowOffset: const Offset(1.5, 1.5),
    );
  }

  /// Factory for breaking news / live / count badge (Alert red)
  factory BikiniBadge.breaking({
    String text = '⚡ عاجل',
  }) {
    return BikiniBadge(
      text: text,
      backgroundColor: BikiniColors.alert,
      textColor: BikiniColors.card,
      fontSize: 11.5,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      shadowOffset: const Offset(1.5, 1.5),
    );
  }

  /// Factory for trending / hot badge (Alert red)
  factory BikiniBadge.trending({
    String text = '🔥 تريند القاع',
  }) {
    return BikiniBadge(
      text: text,
      backgroundColor: BikiniColors.alert,
      textColor: BikiniColors.card,
      fontSize: 11.5,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      shadowOffset: const Offset(1.5, 1.5),
    );
  }

  /// Factory for active official badge (Support cyan)
  factory BikiniBadge.active({
    String text = '✨ متاح الآن',
  }) {
    return BikiniBadge(
      text: text,
      backgroundColor: BikiniColors.support,
      textColor: BikiniColors.ink,
      fontSize: 11.5,
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
        borderRadius: BorderRadius.circular(BikiniRadius.pill),
        border: Border.all(
          color: borderColor,
          width: BikiniRadius.borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: BikiniColors.ink,
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
              style: BikiniTypography.caption(color: textColor).copyWith(
                fontSize: fontSize < 11.5 ? 11.5 : fontSize,
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

