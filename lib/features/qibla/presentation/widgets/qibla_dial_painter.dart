import 'dart:math';
import 'package:flutter/material.dart';

class QiblaDialPainter extends CustomPainter {
  final Color tickColor;
  final Color majorTickColor;
  final Color northColor;

  QiblaDialPainter({
    required this.tickColor,
    required this.majorTickColor,
    required this.northColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    final minorPaint = Paint()
      ..color = tickColor
      ..strokeWidth = 1.2;
    final majorPaint = Paint()
      ..color = majorTickColor
      ..strokeWidth = 2.4;

    for (int deg = 0; deg < 360; deg += 6) {
      final isMajor = deg % 30 == 0;
      final rad = deg * pi / 180;
      final outer = radius - 6;
      final inner = outer - (isMajor ? 16 : 8);
      final p1 = Offset(center.dx + inner * sin(rad), center.dy - inner * cos(rad));
      final p2 = Offset(center.dx + outer * sin(rad), center.dy - outer * cos(rad));
      canvas.drawLine(p1, p2, isMajor ? majorPaint : minorPaint);
    }

    _drawLabel(canvas, center, radius, 0, "K", northColor, bold: true);
    _drawLabel(canvas, center, radius, 90, "D", tickColor);
    _drawLabel(canvas, center, radius, 180, "G", tickColor);
    _drawLabel(canvas, center, radius, 270, "B", tickColor);
  }

  void _drawLabel(
    Canvas canvas,
    Offset center,
    double radius,
    double angleDeg,
    String text,
    Color color, {
    bool bold = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: bold ? 16 : 13,
          fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final rad = angleDeg * pi / 180;
    final labelRadius = radius - 34;
    final offset = Offset(
      center.dx + labelRadius * sin(rad) - tp.width / 2,
      center.dy - labelRadius * cos(rad) - tp.height / 2,
    );
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant QiblaDialPainter oldDelegate) => false;
}
