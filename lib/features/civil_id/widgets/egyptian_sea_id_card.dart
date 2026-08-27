import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../core/avatar/marine_avatar_renderer.dart';
import '../../../core/services/citizen_service.dart';
import '../../../core/theme/bikini_theme.dart';
import '../../../core/widgets/bikini_badge.dart';

/// 3D Flippable Egyptian National Marine ID Card Replica with Custom Barcode & PNG Export
class EgyptianSeaIdCard extends StatefulWidget {
  final CitizenProfile profile;
  final GlobalKey boundaryKey;
  final VoidCallback? onCardTapped;

  const EgyptianSeaIdCard({
    super.key,
    required this.profile,
    required this.boundaryKey,
    this.onCardTapped,
  });

  @override
  State<EgyptianSeaIdCard> createState() => _EgyptianSeaIdCardState();
}

class _EgyptianSeaIdCardState extends State<EgyptianSeaIdCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _animation;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0, end: math.pi).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_flipController.isAnimating) return;
    if (_showFront) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
    setState(() {
      _showFront = !_showFront;
    });
    widget.onCardTapped?.call();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.boundaryKey,
      child: GestureDetector(
        onTap: _flipCard,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final angle = _animation.value;
            final isFrontSide = angle < (math.pi / 2);

            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              alignment: Alignment.center,
              child: isFrontSide
                  ? _buildFrontCard()
                  : Transform(
                      transform: Matrix4.identity()..rotateY(math.pi),
                      alignment: Alignment.center,
                      child: _buildBackCard(),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(BikiniSpacing.space16),
      decoration: BikiniDecorations.interactiveCard(
        backgroundColor: BikiniColors.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Header Bar
          Row(
            children: [
              const Text('🦅', style: TextStyle(fontSize: 20)),
              const SizedBox(width: BikiniSpacing.space8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'جمهورية قاع الهامور - بطاقة الرقم القومي البحرية 🌊',
                      style: BikiniTypography.label(color: BikiniColors.deep),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'وزارة الداخلية والمقرمشات المائية',
                      style: BikiniTypography.caption(color: BikiniColors.muted),
                    ),
                  ],
                ),
              ),
              const BikiniBadge(
                text: 'أصلي 💯',
                backgroundColor: BikiniColors.support,
                textColor: BikiniColors.ink,
              ),
            ],
          ),

          const SizedBox(height: BikiniSpacing.space8),
          const Divider(color: BikiniColors.line, thickness: 1.5),
          const SizedBox(height: BikiniSpacing.space8),

          // Card Content Body (Avatar + Info)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Avatar Frame
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: BikiniColors.paper,
                      borderRadius: BorderRadius.circular(BikiniRadius.button),
                      border: Border.all(color: BikiniColors.ink, width: BikiniRadius.borderWidth),
                    ),
                    child: MarineAvatarRenderer(
                      config: widget.profile.avatarConfig,
                      size: 76,
                      showBackground: true,
                    )
                  ),
                  const SizedBox(height: BikiniSpacing.space4),
                  const BikiniBadge(
                    text: 'معتمد رسمياً 🔱',
                    backgroundColor: BikiniColors.support,
                    textColor: BikiniColors.ink,
                  ),
                ],
              ),

              const SizedBox(width: BikiniSpacing.space12),

              // Right: Citizen Data Fields
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldRow('الاسم:', widget.profile.name, isBold: true),
                    const SizedBox(height: BikiniSpacing.space4),
                    _buildFieldRow('الهاندل:', widget.profile.handle, color: BikiniColors.deep2),
                    const SizedBox(height: BikiniSpacing.space4),
                    _buildFieldRow('الإقامة:', 'حارة الأناناسة - شارع الصدف'),
                    const SizedBox(height: BikiniSpacing.space4),
                    _buildFieldRow('الرقم القومي:', widget.profile.nationalNumber),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: BikiniSpacing.space8),

          // Flip Hint Line
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'كود القاع: ${widget.profile.id}',
                  style: BikiniTypography.caption(color: BikiniColors.alert),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'اضغط لقلب البطاقة 🔄',
                style: BikiniTypography.caption(color: BikiniColors.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(BikiniSpacing.space16),
      decoration: BikiniDecorations.interactiveCard(
        backgroundColor: BikiniColors.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Back Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'البيانات الرسمية والعرقية 📜',
                style: BikiniTypography.label(color: BikiniColors.deep),
              ),
              const Text('🔱', style: TextStyle(fontSize: 18)),
            ],
          ),

          const SizedBox(height: BikiniSpacing.space8),
          const Divider(color: BikiniColors.line, thickness: 1.5),
          const SizedBox(height: BikiniSpacing.space8),

          // Back Details
          _buildFieldRow('المهنة:', widget.profile.job),
          const SizedBox(height: BikiniSpacing.space4),
          _buildFieldRow('الفصيلة والعشيرة:', '${widget.profile.speciesEmoji} ${widget.profile.species} - ${widget.profile.clan}'),
          const SizedBox(height: BikiniSpacing.space4),
          _buildFieldRow('التهمة المسجلة:', widget.profile.crime, color: BikiniColors.danger),
          const SizedBox(height: BikiniSpacing.space4),
          _buildFieldRow('فصيلة الدم:', widget.profile.bloodType),
          const SizedBox(height: BikiniSpacing.space4),
          _buildFieldRow('تاريخ الإصدار:', widget.profile.registeredAt.toString().split(' ').first),

          const SizedBox(height: BikiniSpacing.space8),

          // High Density Barcode Stripe
          Container(
            height: 34,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: BikiniColors.paper,
              borderRadius: BorderRadius.circular(BikiniRadius.button),
              border: Border.all(color: BikiniColors.ink, width: 1.5),
            ),
            child: CustomPaint(
              size: const Size(double.infinity, 28),
              painter: _BarcodePainter(code: widget.profile.nationalNumber),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 0,
          child: Text(
            label,
            style: BikiniTypography.caption(color: BikiniColors.muted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: (isBold
                    ? BikiniTypography.label(color: color ?? BikiniColors.ink)
                    : BikiniTypography.caption(color: color ?? BikiniColors.ink)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Custom Painter for Rendering High-Density Barcode Lines on Sea ID Back
class _BarcodePainter extends CustomPainter {
  final String code;

  _BarcodePainter({required this.code});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = BikiniColors.ink
      ..style = PaintingStyle.fill;

    final random = math.Random(code.hashCode);
    double currentX = 8.0;
    final availableWidth = size.width - 16.0;

    while (currentX < availableWidth) {
      final barWidth = 1.5 + random.nextDouble() * 3.0;
      final gap = 1.5 + random.nextDouble() * 2.5;

      canvas.drawRect(
        Rect.fromLTWH(currentX, 2, barWidth, size.height - 4),
        linePaint,
      );
      currentX += barWidth + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _BarcodePainter oldDelegate) => oldDelegate.code != code;
}

/// Helper extension to capture RepaintBoundary as PNG Bytes
extension SeaIdCardExporter on GlobalKey {
  Future<ui.Image?> captureAsImage() async {
    try {
      final boundary = currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      return await boundary.toImage(pixelRatio: 3.0);
    } catch (e) {
      if (kDebugMode) print('Capture image error: $e');
      return null;
    }
  }
}

