import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/bikini_theme.dart';

/// Undersea Ambient Background with animated floating bubbles and 440px max-width mobile frame
class UnderseaBackground extends StatefulWidget {
  final Widget child;
  final double maxWidth;

  const UnderseaBackground({
    super.key,
    required this.child,
    this.maxWidth = 440.0,
  });

  @override
  State<UnderseaBackground> createState() => _UnderseaBackgroundState();
}

class _UnderseaBackgroundState extends State<UnderseaBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _bubbleController;

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: BikiniColors.deep,
      ),
      child: Stack(
        children: [
          // Background floating bubbles animation
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bubbleController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _BubblePainter(progress: _bubbleController.value),
                );
              },
            ),
          ),

          // Centered Mobile Screen Container (maxWidth: 440)
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: widget.maxWidth),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isFramed = MediaQuery.of(context).size.width > widget.maxWidth;
                  return Container(
                    decoration: isFramed
                        ? BoxDecoration(
                            color: BikiniColors.paper,
                            border: Border.symmetric(
                              vertical: BorderSide(
                                color: BikiniColors.ink,
                                width: BikiniRadius.borderWidth,
                              ),
                            ),
                          )
                        : const BoxDecoration(
                            color: BikiniColors.paper,
                          ),
                    child: ClipRect(
                      child: widget.child,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  final double progress;

  _BubblePainter({required this.progress});

  static final List<_BubbleSpec> _specs = [
    _BubbleSpec(xRel: 0.10, speed: 1.0, size: 24, wobbleOffset: 0.0),
    _BubbleSpec(xRel: 0.25, speed: 1.3, size: 14, wobbleOffset: 1.5),
    _BubbleSpec(xRel: 0.45, speed: 0.8, size: 32, wobbleOffset: 3.0),
    _BubbleSpec(xRel: 0.65, speed: 1.1, size: 18, wobbleOffset: 4.5),
    _BubbleSpec(xRel: 0.80, speed: 1.4, size: 28, wobbleOffset: 2.0),
    _BubbleSpec(xRel: 0.92, speed: 0.9, size: 16, wobbleOffset: 5.5),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final bubblePaint = Paint()
      ..color = BikiniColors.support.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;

    final bubbleStroke = Paint()
      ..color = BikiniColors.card.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (final spec in _specs) {
      final yProgress = (progress * spec.speed + spec.wobbleOffset) % 1.0;
      final y = size.height - (yProgress * (size.height + 60));
      final xOffset = math.sin(progress * 2 * math.pi + spec.wobbleOffset) * 12;
      final x = (spec.xRel * size.width) + xOffset;

      canvas.drawCircle(Offset(x, y), spec.size / 2, bubblePaint);
      canvas.drawCircle(Offset(x, y), spec.size / 2, bubbleStroke);

      // Light reflection highlight
      final highlightPaint = Paint()
        ..color = BikiniColors.card.withValues(alpha: 0.6)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(x - spec.size * 0.18, y - spec.size * 0.18),
        spec.size * 0.12,
        highlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _BubbleSpec {
  final double xRel;
  final double speed;
  final double size;
  final double wobbleOffset;

  _BubbleSpec({
    required this.xRel,
    required this.speed,
    required this.size,
    required this.wobbleOffset,
  });
}
