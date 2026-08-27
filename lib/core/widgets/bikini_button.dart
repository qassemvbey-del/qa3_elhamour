import 'package:flutter/material.dart';
import '../theme/bikini_theme.dart';

/// Cartoon Neo-Brutalist Action Button with satisfying physical bounce & depth
class BikiniButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String? text;
  final Widget? icon;
  final Widget? customChild;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final Color shadowColor;
  final double height;
  final double? width;
  final double borderRadius;
  final double borderWidth;
  final Offset shadowOffset;
  final EdgeInsetsGeometry padding;
  final bool isFullWidth;
  final TextStyle? textStyle;

  const BikiniButton({
    super.key,
    required this.onPressed,
    this.text,
    this.icon,
    this.customChild,
    this.backgroundColor = BikiniColors.card,
    this.textColor = BikiniColors.ink,
    this.borderColor = BikiniColors.ink,
    this.shadowColor = BikiniColors.ink,
    this.height = BikiniRadius.minTapHeight,
    this.width,
    this.borderRadius = BikiniRadius.button,
    this.borderWidth = BikiniRadius.borderWidth,
    this.shadowOffset = const Offset(3.0, 3.0),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.isFullWidth = false,
    this.textStyle,
  });

  /// Factory for primary action (Yellow action - exactly ONE per screen)
  factory BikiniButton.primary({
    Key? key,
    required VoidCallback? onPressed,
    required String text,
    Widget? icon,
    bool isFullWidth = false,
    double height = 48.0,
  }) {
    return BikiniButton(
      key: key,
      onPressed: onPressed,
      text: text,
      icon: icon,
      backgroundColor: BikiniColors.action,
      textColor: BikiniColors.ink,
      isFullWidth: isFullWidth,
      height: height,
    );
  }

  /// Factory for secondary action (White card + shadow)
  factory BikiniButton.secondary({
    Key? key,
    required VoidCallback? onPressed,
    required String text,
    Widget? icon,
    bool isFullWidth = false,
    double height = 48.0,
  }) {
    return BikiniButton(
      key: key,
      onPressed: onPressed,
      text: text,
      icon: icon,
      backgroundColor: BikiniColors.card,
      textColor: BikiniColors.ink,
      isFullWidth: isFullWidth,
      height: height,
    );
  }

  /// Factory for ghost button (no shadow, transparent/card background)
  factory BikiniButton.ghost({
    Key? key,
    required VoidCallback? onPressed,
    required String text,
    Widget? icon,
    bool isFullWidth = false,
    double height = 48.0,
  }) {
    return BikiniButton(
      key: key,
      onPressed: onPressed,
      text: text,
      icon: icon,
      backgroundColor: BikiniColors.card,
      textColor: BikiniColors.ink,
      shadowOffset: Offset.zero,
      isFullWidth: isFullWidth,
      height: height,
    );
  }

  /// Factory for danger action (Red danger)
  factory BikiniButton.danger({
    Key? key,
    required VoidCallback? onPressed,
    required String text,
    Widget? icon,
    bool isFullWidth = false,
    double height = 48.0,
  }) {
    return BikiniButton(
      key: key,
      onPressed: onPressed,
      text: text,
      icon: icon,
      backgroundColor: BikiniColors.danger,
      textColor: BikiniColors.card,
      isFullWidth: isFullWidth,
      height: height,
    );
  }

  /// Backward compatibility for secondary support button
  factory BikiniButton.support({
    Key? key,
    required VoidCallback? onPressed,
    required String text,
    Widget? icon,
    bool isFullWidth = false,
    double height = 48.0,
  }) {
    return BikiniButton(
      key: key,
      onPressed: onPressed,
      text: text,
      icon: icon,
      backgroundColor: BikiniColors.support,
      textColor: BikiniColors.ink,
      isFullWidth: isFullWidth,
      height: height,
    );
  }

  /// Backward compatibility alias for pink
  factory BikiniButton.pink({
    Key? key,
    required VoidCallback? onPressed,
    required String text,
    Widget? icon,
    bool isFullWidth = false,
    double height = 48.0,
  }) => BikiniButton.secondary(
    key: key,
    onPressed: onPressed,
    text: text,
    icon: icon,
    isFullWidth: isFullWidth,
    height: height,
  );

  @override
  State<BikiniButton> createState() => _BikiniButtonState();
}

class _BikiniButtonState extends State<BikiniButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails _) {
    if (widget.onPressed != null) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.onPressed != null) {
      setState(() => _isPressed = false);
    }
  }

  void _handleTapCancel() {
    if (widget.onPressed != null) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null;
    final currentShadow = (_isPressed || !isEnabled)
        ? const Offset(1, 1)
        : widget.shadowOffset;
    final currentTranslation = (_isPressed || !isEnabled)
        ? Offset(
            widget.shadowOffset.dx - 1,
            widget.shadowOffset.dy - 1,
          )
        : Offset.zero;

    Widget content;
    if (widget.customChild != null) {
      content = widget.customChild!;
    } else {
      final textWidget = widget.text != null
          ? Text(
              widget.text!,
              style: widget.textStyle ??
                  BikiniTypography.label(
                    color: isEnabled
                        ? widget.textColor
                        : BikiniColors.muted,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : const SizedBox.shrink();

      if (widget.icon != null) {
        content = Row(
          mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.icon!,
            const SizedBox(width: 6),
            Flexible(child: textWidget),
          ],
        );
      } else {
        content = textWidget;
      }
    }

    Widget buttonWidget = AnimatedContainer(
      duration: const Duration(milliseconds: 90),
      curve: Curves.easeOutQuad,
      transform: Matrix4.translationValues(
        currentTranslation.dx,
        currentTranslation.dy,
        0,
      ),
      height: widget.height,
      width: widget.isFullWidth ? double.infinity : widget.width,
      padding: widget.padding,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isEnabled
            ? widget.backgroundColor
            : BikiniColors.line,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: widget.borderColor,
          width: widget.borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: isEnabled
                ? widget.shadowColor
                : BikiniColors.ink.withValues(alpha: 0.3),
            offset: currentShadow,
            blurRadius: 0,
          ),
        ],
      ),
      child: content,
    );

    return GestureDetector(
      onTapDown: isEnabled ? _handleTapDown : null,
      onTapUp: isEnabled ? _handleTapUp : null,
      onTapCancel: isEnabled ? _handleTapCancel : null,
      onTap: widget.onPressed,
      behavior: HitTestBehavior.opaque,
      child: buttonWidget,
    );
  }
}
