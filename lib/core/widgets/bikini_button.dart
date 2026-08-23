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
    this.backgroundColor = BikiniColors.spongeYellow,
    this.textColor = BikiniColors.cartoonBlack,
    this.borderColor = BikiniColors.cartoonBlack,
    this.shadowColor = BikiniColors.cartoonBlack,
    this.height = 48.0,
    this.width,
    this.borderRadius = 16.0,
    this.borderWidth = BikiniDecorations.borderWidth,
    this.shadowOffset = const Offset(3.5, 3.5),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.isFullWidth = false,
    this.textStyle,
  });

  /// Factory for primary action (Yellow Sponge)
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
      backgroundColor: BikiniColors.spongeYellow,
      textColor: BikiniColors.cartoonBlack,
      isFullWidth: isFullWidth,
      height: height,
    );
  }

  /// Factory for secondary action (Marine Cyan)
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
      backgroundColor: BikiniColors.marineCyan,
      textColor: BikiniColors.cartoonBlack,
      isFullWidth: isFullWidth,
      height: height,
    );
  }

  /// Factory for danger/emergency action (Krabs Red)
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
      backgroundColor: BikiniColors.krabsRed,
      textColor: BikiniColors.pureWhite,
      isFullWidth: isFullWidth,
      height: height,
    );
  }

  /// Factory for vibrant pink action (Neon Pink)
  factory BikiniButton.pink({
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
      backgroundColor: BikiniColors.neonPink,
      textColor: BikiniColors.pureWhite,
      isFullWidth: isFullWidth,
      height: height,
    );
  }

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
                  BikiniTypography.titleBold(
                    color: isEnabled
                        ? widget.textColor
                        : BikiniColors.cartoonBlack.withValues(alpha: 0.5),
                  ).copyWith(fontSize: 14),
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
            : const Color(0xFFD3D3D3),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: widget.borderColor,
          width: widget.borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: isEnabled
                ? widget.shadowColor
                : BikiniColors.cartoonBlack.withValues(alpha: 0.4),
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
