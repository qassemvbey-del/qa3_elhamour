import 'package:flutter/material.dart';
import '../theme/bikini_theme.dart';

/// A Neo-Brutalist cartoon card with solid black borders, rounded corners,
/// and sharp drop-shadows with optional micro-interaction tactile animations.
class BikiniCard extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;
  final Color borderColor;
  final Color shadowColor;
  final double borderWidth;
  final double borderRadius;
  final Offset shadowOffset;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool animateOnTap;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;

  const BikiniCard({
    super.key,
    required this.child,
    this.backgroundColor = BikiniColors.pureWhite,
    this.borderColor = BikiniColors.cartoonBlack,
    this.shadowColor = BikiniColors.cartoonBlack,
    this.borderWidth = BikiniDecorations.borderWidth,
    this.borderRadius = BikiniDecorations.borderRadius,
    this.shadowOffset = BikiniDecorations.shadowOffset,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.onTap,
    this.animateOnTap = true,
    this.width,
    this.height,
    this.alignment,
  });

  @override
  State<BikiniCard> createState() => _BikiniCardState();
}

class _BikiniCardState extends State<BikiniCard> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails _) {
    if (widget.onTap != null && widget.animateOnTap) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.onTap != null && widget.animateOnTap) {
      setState(() => _isPressed = false);
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null && widget.animateOnTap) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentShadow = _isPressed
        ? const Offset(1, 1)
        : widget.shadowOffset;
    final currentTranslation = _isPressed
        ? Offset(
            widget.shadowOffset.dx - 1,
            widget.shadowOffset.dy - 1,
          )
        : Offset.zero;

    Widget cardContent = AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      transform: Matrix4.translationValues(
        currentTranslation.dx,
        currentTranslation.dy,
        0,
      ),
      width: widget.width,
      height: widget.height,
      alignment: widget.alignment,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: widget.borderColor,
          width: widget.borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.shadowColor,
            offset: currentShadow,
            blurRadius: 0,
          ),
        ],
      ),
      child: widget.child,
    );

    if (widget.onTap != null) {
      cardContent = GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: cardContent,
      );
    }

    if (widget.margin != null) {
      return Padding(
        padding: widget.margin!,
        child: cardContent,
      );
    }

    return cardContent;
  }
}
