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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFF9D2),
            Color(0xFFF4E3B2),
            Color(0xFFE2F9F0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BikiniColors.cartoonBlack, width: 3.5),
        boxShadow: const [
          BoxShadow(
            color: BikiniColors.cartoonBlack,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Header Bar
          Row(
            children: [
              const Text('🦅', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'جمهورية قاع الهامور - بطاقة الرقم القومي البحرية 🌊',
                      style: BikiniTypography.titleBold().copyWith(fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'وزارة الداخلية والمقرمشات المائية',
                      style: BikiniTypography.caption(color: const Color(0xFF555555))
                          .copyWith(fontSize: 9),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: BikiniColors.spongeYellow,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: BikiniColors.cartoonBlack, width: 1.5),
                ),
                child: Text(
                  'اصلي 💯',
                  style: BikiniTypography.captionBold().copyWith(fontSize: 8.5),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          const Divider(color: BikiniColors.cartoonBlack, height: 1, thickness: 1.5),
          const SizedBox(height: 8),

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
                      color: BikiniColors.pureWhite,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: BikiniColors.cartoonBlack, width: 2.2),
                    ),
                    child: MarineAvatarRenderer(
                      config: widget.profile.avatarConfig,
                      size: 76,
                      showBackground: true,
                    ),
                  ),
                  const SizedBox(height: 4),
                  BikiniBadge(
                    text: 'معتمد رسمياً 🔱',
                    backgroundColor: BikiniColors.marineCyan,
                    fontSize: 8,
                  ),
                ],
              ),

              const SizedBox(width: 10),

              // Right: Citizen Data Fields
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldRow('الاسم:', widget.profile.name, isBold: true, fontSize: 10.5),
                    const SizedBox(height: 3),
                    _buildFieldRow('الهاندل:', widget.profile.handle, color: const Color(0xFF0077B6), fontSize: 9.5),
                    const SizedBox(height: 3),
                    _buildFieldRow('الإقامة:', 'حارة الأناناسة - شارع الصدف', fontSize: 9.5),
                    const SizedBox(height: 3),
                    _buildFieldRow('الرقم القومي:', widget.profile.nationalNumber, fontSize: 9.5),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Flip Hint Line
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'كود القاع: ${widget.profile.id}',
                  style: BikiniTypography.captionBold(color: BikiniColors.krabsRed)
                      .copyWith(fontSize: 9.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'اضغط لقلب البطاقة 🔄',
                style: BikiniTypography.caption(color: const Color(0xFF666666))
                    .copyWith(fontSize: 9),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE2F9F0),
            Color(0xFFF4E3B2),
            Color(0xFFFFF9D2),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BikiniColors.cartoonBlack, width: 3.5),
        boxShadow: const [
          BoxShadow(
            color: BikiniColors.cartoonBlack,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
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
                style: BikiniTypography.titleBold().copyWith(fontSize: 11),
              ),
              const Text('🔱', style: TextStyle(fontSize: 18)),
            ],
          ),

          const SizedBox(height: 6),
          const Divider(color: BikiniColors.cartoonBlack, height: 1, thickness: 1.5),
          const SizedBox(height: 6),

          // Back Details
          _buildFieldRow('المهنة:', widget.profile.job, fontSize: 9.5),
          const SizedBox(height: 3),
          _buildFieldRow('الفصيلة والعشيرة:', '${widget.profile.speciesEmoji} ${widget.profile.species} - ${widget.profile.clan}', fontSize: 9.5),
          const SizedBox(height: 3),
          _buildFieldRow('التهمة المسجلة:', widget.profile.crime, color: BikiniColors.krabsRed, fontSize: 9.5),
          const SizedBox(height: 3),
          _buildFieldRow('فصيلة الدم:', widget.profile.bloodType, fontSize: 9.5),
          const SizedBox(height: 3),
          _buildFieldRow('تاريخ الاصدار:', widget.profile.registeredAt.toString().split(' ').first, fontSize: 9.5),

          const SizedBox(height: 8),

          // High Density Barcode Stripe
          Container(
            height: 34,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: BikiniColors.pureWhite,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: BikiniColors.cartoonBlack, width: 1.5),
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
    double fontSize = 9.5,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 0,
          child: Text(
            label,
            style: BikiniTypography.captionBold(color: const Color(0xFF444444))
                .copyWith(fontSize: fontSize),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: (isBold
                    ? BikiniTypography.titleBold(color: color ?? BikiniColors.cartoonBlack)
                    : BikiniTypography.bodyMedium(color: color ?? BikiniColors.cartoonBlack))
                .copyWith(fontSize: fontSize),
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
      ..color = BikiniColors.cartoonBlack
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
