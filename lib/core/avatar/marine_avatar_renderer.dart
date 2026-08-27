import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/bikini_theme.dart';
import 'marine_avatar_config.dart';

/// Layered Vector Marine Avatar Renderer Component for Civil ID & Sprites
class MarineAvatarRenderer extends StatelessWidget {
  final MarineAvatarConfig config;
  final double size;
  final bool showBackground;

  const MarineAvatarRenderer({
    super.key,
    required this.config,
    this.size = 100.0,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: showBackground
          ? BoxDecoration(
              color: BikiniColors.support.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: BikiniColors.ink,
                width: size > 60 ? 2.5 : 1.8,
              ),
              boxShadow: size > 40
                  ? [
                      BoxShadow(
                        color: BikiniColors.ink.withValues(alpha: 0.3),
                        offset: const Offset(2, 2),
                        blurRadius: 0,
                      ),
                    ]
                  : null,
            )
          : null,
      child: ClipOval(
        child: CustomPaint(
          size: Size(size, size),
          painter: _LayeredMarineAvatarPainter(config: config),
        ),
      ),
    );
  }
}

class _LayeredMarineAvatarPainter extends CustomPainter {
  final MarineAvatarConfig config;

  _LayeredMarineAvatarPainter({required this.config});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = BikiniColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.5, size.width * 0.035);

    // Render Layers in sequence:
    _drawBodyBase(canvas, size, strokePaint);
    _drawOutfit(canvas, size, strokePaint);
    _drawFace(canvas, size, strokePaint);
    _drawHat(canvas, size, strokePaint);
  }

  // ----------------------------------------------------
  // LAYER 1: Body Base
  // ----------------------------------------------------
  void _drawBodyBase(Canvas canvas, Size size, Paint strokePaint) {
    final center = Offset(size.width / 2, size.height / 2);
    final width = size.width;
    final height = size.height;

    switch (config.bodyType) {
      case MarineBodyType.sponge:
        final fillPaint = Paint()
          ..color = config.customColor ?? BikiniColors.sponge
          ..style = PaintingStyle.fill;

        final bodyRect = RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(center.dx, center.dy + height * 0.05),
            width: width * 0.65,
            height: height * 0.7,
          ),
          const Radius.circular(10),
        );
        canvas.drawRRect(bodyRect, fillPaint);
        canvas.drawRRect(bodyRect, strokePaint);

        // Sponge Pores
        final porePaint = Paint()
          ..color = BikiniColors.coin.withValues(alpha: 0.5)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(center.dx - width * 0.2, center.dy - height * 0.15), width * 0.05, porePaint);
        canvas.drawCircle(Offset(center.dx + width * 0.2, center.dy - height * 0.1), width * 0.04, porePaint);
        canvas.drawCircle(Offset(center.dx - width * 0.15, center.dy + height * 0.15), width * 0.06, porePaint);
        canvas.drawCircle(Offset(center.dx + width * 0.18, center.dy + height * 0.18), width * 0.045, porePaint);
        break;

      case MarineBodyType.starfish:
        final fillPaint = Paint()
          ..color = config.customColor ?? BikiniColors.starfish
          ..style = PaintingStyle.fill;

        final path = Path();
        final numPoints = 5;
        final outerRadius = width * 0.42;
        final innerRadius = width * 0.2;
        final angle = math.pi / numPoints;

        for (int i = 0; i < 2 * numPoints; i++) {
          final r = (i % 2 == 0) ? outerRadius : innerRadius;
          final currAngle = i * angle - math.pi / 2;
          final x = center.dx + r * math.cos(currAngle);
          final y = center.dy + height * 0.05 + r * math.sin(currAngle);
          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        canvas.drawPath(path, fillPaint);
        canvas.drawPath(path, strokePaint);
        break;

      case MarineBodyType.squid:
        final fillPaint = Paint()
          ..color = config.customColor ?? BikiniColors.squid
          ..style = PaintingStyle.fill;

        // Big oval head
        final headRect = Rect.fromCenter(
          center: Offset(center.dx, center.dy - height * 0.05),
          width: width * 0.62,
          height: height * 0.72,
        );
        canvas.drawOval(headRect, fillPaint);
        canvas.drawOval(headRect, strokePaint);
        break;

      case MarineBodyType.crab:
        final fillPaint = Paint()
          ..color = config.customColor ?? BikiniColors.crab
          ..style = PaintingStyle.fill;

        final shellRect = Rect.fromCenter(
          center: Offset(center.dx, center.dy + height * 0.05),
          width: width * 0.75,
          height: height * 0.55,
        );
        canvas.drawOval(shellRect, fillPaint);
        canvas.drawOval(shellRect, strokePaint);

        // Claws
        canvas.drawCircle(Offset(center.dx - width * 0.32, center.dy - height * 0.08), width * 0.12, fillPaint);
        canvas.drawCircle(Offset(center.dx - width * 0.32, center.dy - height * 0.08), width * 0.12, strokePaint);
        canvas.drawCircle(Offset(center.dx + width * 0.32, center.dy - height * 0.08), width * 0.12, fillPaint);
        canvas.drawCircle(Offset(center.dx + width * 0.32, center.dy - height * 0.08), width * 0.12, strokePaint);
        break;

      case MarineBodyType.squirrel:
        final glassPaint = Paint()
          ..color = BikiniColors.support.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;

        final fillPaint = Paint()
          ..color = config.customColor ?? BikiniColors.squirrel
          ..style = PaintingStyle.fill;

        canvas.drawCircle(center, width * 0.35, fillPaint);
        canvas.drawCircle(center, width * 0.35, strokePaint);

        // Diver Glass Helmet
        canvas.drawCircle(center, width * 0.42, glassPaint);
        canvas.drawCircle(center, width * 0.42, strokePaint);
        break;

      case MarineBodyType.fish:
        final fillPaint = Paint()
          ..color = config.customColor ?? BikiniColors.fish
          ..style = PaintingStyle.fill;

        final fishPath = Path()
          ..addOval(Rect.fromCenter(center: center, width: width * 0.68, height: height * 0.62));
        canvas.drawPath(fishPath, fillPaint);
        canvas.drawPath(fishPath, strokePaint);
        break;
    }
  }

  // ----------------------------------------------------
  // LAYER 2: Clothes / Outfit
  // ----------------------------------------------------
  void _drawOutfit(Canvas canvas, Size size, Paint strokePaint) {
    if (config.outfit == MarineOutfit.none) return;

    final center = Offset(size.width / 2, size.height / 2);
    final width = size.width;
    final height = size.height;

    switch (config.outfit) {
      case MarineOutfit.tieShirt:
        final shirtPaint = Paint()
          ..color = BikiniColors.card
          ..style = PaintingStyle.fill;
        final pantsPaint = Paint()
          ..color = BikiniColors.squirrel
          ..style = PaintingStyle.fill;
        final tiePaint = Paint()
          ..color = BikiniColors.alert
          ..style = PaintingStyle.fill;

        final shirtRect = Rect.fromLTWH(center.dx - width * 0.3, center.dy + height * 0.15, width * 0.6, height * 0.12);
        canvas.drawRect(shirtRect, shirtPaint);
        canvas.drawRect(shirtRect, strokePaint);

        final pantsRect = Rect.fromLTWH(center.dx - width * 0.3, center.dy + height * 0.27, width * 0.6, height * 0.14);
        canvas.drawRect(pantsRect, pantsPaint);
        canvas.drawRect(pantsRect, strokePaint);

        // Red Tie
        final tiePath = Path()
          ..moveTo(center.dx - width * 0.04, center.dy + height * 0.15)
          ..lineTo(center.dx + width * 0.04, center.dy + height * 0.15)
          ..lineTo(center.dx + width * 0.06, center.dy + height * 0.26)
          ..lineTo(center.dx, center.dy + height * 0.31)
          ..lineTo(center.dx - width * 0.06, center.dy + height * 0.26)
          ..close();
        canvas.drawPath(tiePath, tiePaint);
        canvas.drawPath(tiePath, strokePaint);
        break;

      case MarineOutfit.flowerTrunks:
        final trunkPaint = Paint()
          ..color = BikiniColors.support
          ..style = PaintingStyle.fill;
        final flowerPaint = Paint()
          ..color = BikiniColors.squid
          ..style = PaintingStyle.fill;

        final trunkRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(center.dx - width * 0.32, center.dy + height * 0.16, width * 0.64, height * 0.25),
          const Radius.circular(6),
        );
        canvas.drawRRect(trunkRect, trunkPaint);
        canvas.drawRRect(trunkRect, strokePaint);

        // Flowers on trunks
        canvas.drawCircle(Offset(center.dx - width * 0.15, center.dy + height * 0.22), width * 0.04, flowerPaint);
        canvas.drawCircle(Offset(center.dx + width * 0.15, center.dy + height * 0.28), width * 0.04, flowerPaint);
        break;

      case MarineOutfit.bossSuit:
        final suitPaint = Paint()
          ..color = BikiniColors.ink
          ..style = PaintingStyle.fill;
        final shirtPaint = Paint()
          ..color = BikiniColors.card
          ..style = PaintingStyle.fill;

        final suitRect = Rect.fromLTWH(center.dx - width * 0.35, center.dy + height * 0.14, width * 0.7, height * 0.3);
        canvas.drawRect(suitRect, suitPaint);

        final shirtV = Path()
          ..moveTo(center.dx - width * 0.1, center.dy + height * 0.14)
          ..lineTo(center.dx + width * 0.1, center.dy + height * 0.14)
          ..lineTo(center.dx, center.dy + height * 0.3)
          ..close();
        canvas.drawPath(shirtV, shirtPaint);
        canvas.drawRect(suitRect, strokePaint);
        break;

      case MarineOutfit.sailorShirt:
        final shirtPaint = Paint()
          ..color = BikiniColors.support
          ..style = PaintingStyle.fill;

        final shirtRect = Rect.fromLTWH(center.dx - width * 0.32, center.dy + height * 0.15, width * 0.64, height * 0.25);
        canvas.drawRect(shirtRect, shirtPaint);
        canvas.drawRect(shirtRect, strokePaint);
        break;

      case MarineOutfit.none:
        break;
    }
  }

  // ----------------------------------------------------
  // LAYER 3: Face (Eyes & Expression)
  // ----------------------------------------------------
  void _drawFace(Canvas canvas, Size size, Paint strokePaint) {
    final center = Offset(size.width / 2, size.height / 2);
    final width = size.width;
    final height = size.height;

    final eyeWhite = Paint()
      ..color = BikiniColors.card
      ..style = PaintingStyle.fill;
    final pupilBlue = Paint()
      ..color = BikiniColors.fish
      ..style = PaintingStyle.fill;
    final pupilBlack = Paint()
      ..color = BikiniColors.ink
      ..style = PaintingStyle.fill;

    final leftEye = Offset(center.dx - width * 0.13, center.dy - height * 0.1);
    final rightEye = Offset(center.dx + width * 0.13, center.dy - height * 0.1);
    final eyeRadius = width * 0.12;

    switch (config.expression) {
      case MarineExpression.happy:
        canvas.drawCircle(leftEye, eyeRadius, eyeWhite);
        canvas.drawCircle(leftEye, eyeRadius, strokePaint);
        canvas.drawCircle(rightEye, eyeRadius, eyeWhite);
        canvas.drawCircle(rightEye, eyeRadius, strokePaint);

        canvas.drawCircle(leftEye, eyeRadius * 0.45, pupilBlue);
        canvas.drawCircle(rightEye, eyeRadius * 0.45, pupilBlue);
        canvas.drawCircle(leftEye, eyeRadius * 0.2, pupilBlack);
        canvas.drawCircle(rightEye, eyeRadius * 0.2, pupilBlack);

        // Big Smile
        final mouthPath = Path()
          ..arcTo(
            Rect.fromCircle(center: Offset(center.dx, center.dy + height * 0.04), radius: width * 0.16),
            0,
            math.pi,
            false,
          );
        canvas.drawPath(mouthPath, strokePaint);
        break;

      case MarineExpression.bored:
        canvas.drawCircle(leftEye, eyeRadius * 0.9, eyeWhite);
        canvas.drawCircle(leftEye, eyeRadius * 0.9, strokePaint);
        canvas.drawCircle(rightEye, eyeRadius * 0.9, eyeWhite);
        canvas.drawCircle(rightEye, eyeRadius * 0.9, strokePaint);

        canvas.drawCircle(leftEye, eyeRadius * 0.3, pupilBlack);
        canvas.drawCircle(rightEye, eyeRadius * 0.3, pupilBlack);

        // Half eyelid
        final lidPaint = Paint()
          ..color = BikiniColors.squid
          ..style = PaintingStyle.fill;
        canvas.drawRect(Rect.fromLTWH(leftEye.dx - eyeRadius, leftEye.dy - eyeRadius, eyeRadius * 2, eyeRadius), lidPaint);
        canvas.drawRect(Rect.fromLTWH(rightEye.dx - eyeRadius, rightEye.dy - eyeRadius, eyeRadius * 2, eyeRadius), lidPaint);

        // Bored flat mouth
        canvas.drawLine(
          Offset(center.dx - width * 0.12, center.dy + height * 0.08),
          Offset(center.dx + width * 0.12, center.dy + height * 0.08),
          strokePaint,
        );
        break;

      case MarineExpression.angry:
        canvas.drawCircle(leftEye, eyeRadius, eyeWhite);
        canvas.drawCircle(leftEye, eyeRadius, strokePaint);
        canvas.drawCircle(rightEye, eyeRadius, eyeWhite);
        canvas.drawCircle(rightEye, eyeRadius, strokePaint);

        canvas.drawCircle(leftEye, eyeRadius * 0.3, pupilBlack);
        canvas.drawCircle(rightEye, eyeRadius * 0.3, pupilBlack);

        // Angry Eyebrows
        canvas.drawLine(Offset(leftEye.dx - eyeRadius, leftEye.dy - eyeRadius * 1.1), Offset(leftEye.dx + eyeRadius, leftEye.dy - eyeRadius * 0.3), strokePaint);
        canvas.drawLine(Offset(rightEye.dx + eyeRadius, rightEye.dy - eyeRadius * 1.1), Offset(rightEye.dx - eyeRadius, rightEye.dy - eyeRadius * 0.3), strokePaint);

        // Frown
        final mouthPath = Path()
          ..arcTo(
            Rect.fromCircle(center: Offset(center.dx, center.dy + height * 0.12), radius: width * 0.14),
            math.pi,
            math.pi,
            false,
          );
        canvas.drawPath(mouthPath, strokePaint);
        break;

      case MarineExpression.dumb:
        // Uneven funny Patrick eyes
        canvas.drawCircle(Offset(leftEye.dx, leftEye.dy - 4), eyeRadius * 1.1, eyeWhite);
        canvas.drawCircle(Offset(leftEye.dx, leftEye.dy - 4), eyeRadius * 1.1, strokePaint);
        canvas.drawCircle(Offset(rightEye.dx, rightEye.dy + 4), eyeRadius * 0.85, eyeWhite);
        canvas.drawCircle(Offset(rightEye.dx, rightEye.dy + 4), eyeRadius * 0.85, strokePaint);

        canvas.drawCircle(Offset(leftEye.dx - 2, leftEye.dy - 4), eyeRadius * 0.25, pupilBlack);
        canvas.drawCircle(Offset(rightEye.dx + 2, rightEye.dy + 4), eyeRadius * 0.25, pupilBlack);

        // Open Dumb Mouth
        final mouthRect = Rect.fromCenter(center: Offset(center.dx, center.dy + height * 0.08), width: width * 0.16, height: height * 0.12);
        canvas.drawOval(mouthRect, pupilBlack);
        break;
    }
  }

  // ----------------------------------------------------
  // LAYER 4: Hat / Accessories
  // ----------------------------------------------------
  void _drawHat(Canvas canvas, Size size, Paint strokePaint) {
    if (config.hat == MarineHat.none) return;

    final center = Offset(size.width / 2, size.height / 2);
    final width = size.width;
    final height = size.height;

    switch (config.hat) {
      case MarineHat.krustyVisor:
        final visorPaint = Paint()
          ..color = BikiniColors.card
          ..style = PaintingStyle.fill;
        final anchorPaint = Paint()
          ..color = BikiniColors.deep
          ..style = PaintingStyle.fill;

        final capPath = Path()
          ..moveTo(center.dx - width * 0.22, center.dy - height * 0.28)
          ..lineTo(center.dx + width * 0.22, center.dy - height * 0.28)
          ..lineTo(center.dx + width * 0.18, center.dy - height * 0.44)
          ..lineTo(center.dx - width * 0.18, center.dy - height * 0.44)
          ..close();
        canvas.drawPath(capPath, visorPaint);
        canvas.drawPath(capPath, strokePaint);

        // Anchor ⚓ symbol
        canvas.drawCircle(Offset(center.dx, center.dy - height * 0.36), width * 0.05, anchorPaint);
        break;

      case MarineHat.pirateHat:
        final hatPaint = Paint()
          ..color = BikiniColors.ink
          ..style = PaintingStyle.fill;

        final hatPath = Path()
          ..moveTo(center.dx - width * 0.38, center.dy - height * 0.24)
          ..quadraticBezierTo(center.dx, center.dy - height * 0.48, center.dx + width * 0.38, center.dy - height * 0.24)
          ..quadraticBezierTo(center.dx, center.dy - height * 0.28, center.dx - width * 0.38, center.dy - height * 0.24)
          ..close();
        canvas.drawPath(hatPath, hatPaint);
        break;

      case MarineHat.squidWig:
        final wigPaint = Paint()
          ..color = BikiniColors.squirrel
          ..style = PaintingStyle.fill;

        final wigPath = Path()
          ..addOval(Rect.fromCenter(center: Offset(center.dx, center.dy - height * 0.32), width: width * 0.5, height: height * 0.22));
        canvas.drawPath(wigPath, wigPaint);
        canvas.drawPath(wigPath, strokePaint);
        break;

      case MarineHat.kingCrown:
        final crownPaint = Paint()
          ..color = BikiniColors.coin
          ..style = PaintingStyle.fill;

        final crownPath = Path()
          ..moveTo(center.dx - width * 0.25, center.dy - height * 0.26)
          ..lineTo(center.dx - width * 0.25, center.dy - height * 0.42)
          ..lineTo(center.dx - width * 0.12, center.dy - height * 0.32)
          ..lineTo(center.dx, center.dy - height * 0.46)
          ..lineTo(center.dx + width * 0.12, center.dy - height * 0.32)
          ..lineTo(center.dx + width * 0.25, center.dy - height * 0.42)
          ..lineTo(center.dx + width * 0.25, center.dy - height * 0.26)
          ..close();
        canvas.drawPath(crownPath, crownPaint);
        canvas.drawPath(crownPath, strokePaint);
        break;

      case MarineHat.seaCap:
        final capPaint = Paint()
          ..color = BikiniColors.support
          ..style = PaintingStyle.fill;

        final capRect = RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(center.dx, center.dy - height * 0.32), width: width * 0.42, height: height * 0.16),
          const Radius.circular(8),
        );
        canvas.drawRRect(capRect, capPaint);
        canvas.drawRRect(capRect, strokePaint);
        break;

      case MarineHat.none:
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _LayeredMarineAvatarPainter oldDelegate) {
    return oldDelegate.config != config;
  }
}

