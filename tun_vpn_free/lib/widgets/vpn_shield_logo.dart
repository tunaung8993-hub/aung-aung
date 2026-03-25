import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class VpnShieldLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const VpnShieldLogo({super.key, this.size = 80, this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 1.15),
      painter: _ShieldPainter(color: color ?? AppColors.primary),
    );
  }
}

class _ShieldPainter extends CustomPainter {
  final Color color;

  _ShieldPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Shield gradient fill
    final shieldPath = Path();
    shieldPath.moveTo(w * 0.5, 0);
    shieldPath.lineTo(w * 0.95, h * 0.18);
    shieldPath.lineTo(w * 0.95, h * 0.52);
    shieldPath.cubicTo(
      w * 0.95, h * 0.78,
      w * 0.72, h * 0.95,
      w * 0.5, h,
    );
    shieldPath.cubicTo(
      w * 0.28, h * 0.95,
      w * 0.05, h * 0.78,
      w * 0.05, h * 0.52,
    );
    shieldPath.lineTo(w * 0.05, h * 0.18);
    shieldPath.close();

    // Outer glow
    final glowPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawPath(shieldPath, glowPaint);

    // Shield fill with gradient
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color.withOpacity(0.9),
        color.withOpacity(0.6),
        const Color(0xFF004D20),
      ],
    );
    final fillPaint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;
    canvas.drawPath(shieldPath, fillPaint);

    // Shield border
    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.03;
    canvas.drawPath(shieldPath, borderPaint);

    // Inner shield (lighter)
    final innerPath = Path();
    innerPath.moveTo(w * 0.5, h * 0.08);
    innerPath.lineTo(w * 0.88, h * 0.24);
    innerPath.lineTo(w * 0.88, h * 0.52);
    innerPath.cubicTo(
      w * 0.88, h * 0.74,
      w * 0.68, h * 0.88,
      w * 0.5, h * 0.92,
    );
    innerPath.cubicTo(
      w * 0.32, h * 0.88,
      w * 0.12, h * 0.74,
      w * 0.12, h * 0.52,
    );
    innerPath.lineTo(w * 0.12, h * 0.24);
    innerPath.close();

    final innerPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.fill;
    canvas.drawPath(innerPath, innerPaint);

    // Checkmark
    final checkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.07
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final checkPath = Path();
    checkPath.moveTo(w * 0.28, h * 0.52);
    checkPath.lineTo(w * 0.44, h * 0.66);
    checkPath.lineTo(w * 0.72, h * 0.38);

    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(_ShieldPainter oldDelegate) => oldDelegate.color != color;
}
