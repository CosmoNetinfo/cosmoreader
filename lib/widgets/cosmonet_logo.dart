import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CosmoNetLogo extends StatelessWidget {
  final double size;
  const CosmoNetLogo({super.key, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _LogoPainter(),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // Outer ring
    final ringPaint = Paint()
      ..color = AppTheme.accent.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(Offset(cx, cy), r * 0.95, ringPaint);

    // Orbit ellipse
    final orbitPaint = Paint()
      ..color = AppTheme.accent.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: size.width * 0.9, height: size.height * 0.4),
      orbitPaint,
    );

    // Orbital dot
    final dotPaint = Paint()
      ..color = AppTheme.accent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx + r * 0.6, cy - r * 0.1), r * 0.1, dotPaint);

    // Center circle
    final centerPaint = Paint()
      ..color = AppTheme.accent.withOpacity(0.15)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), r * 0.45, centerPaint);

    final centerBorder = Paint()
      ..color = AppTheme.accent.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset(cx, cy), r * 0.45, centerBorder);

    // "C" letter
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'C',
        style: TextStyle(
          color: AppTheme.accent,
          fontSize: size.width * 0.35,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(cx - textPainter.width / 2, cy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
