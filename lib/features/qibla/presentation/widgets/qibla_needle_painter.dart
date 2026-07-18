import 'package:flutter/material.dart';

class QiblaNeedlePainter extends CustomPainter {
  final Color needleColor;
  final Color tailColor;

  QiblaNeedlePainter({required this.needleColor, required this.tailColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final needleLength = size.height / 2 - 30;

    final headPaint = Paint()..color = needleColor;
    final tailPaint = Paint()..color = tailColor;

    final headPath = Path()
      ..moveTo(center.dx, center.dy - needleLength)
      ..lineTo(center.dx - 9, center.dy - needleLength + 26)
      ..lineTo(center.dx + 9, center.dy - needleLength + 26)
      ..close();
    canvas.drawPath(headPath, headPaint);

    final tailPath = Path()
      ..moveTo(center.dx, center.dy + needleLength * 0.55)
      ..lineTo(center.dx - 6, center.dy + 8)
      ..lineTo(center.dx + 6, center.dy + 8)
      ..close();
    canvas.drawPath(tailPath, tailPaint);
  }

  @override
  bool shouldRepaint(covariant QiblaNeedlePainter oldDelegate) => false;
}
