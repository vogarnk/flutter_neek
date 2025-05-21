import 'package:flutter/material.dart';

class MultiArcPainter extends CustomPainter {
  final List<double> percentages;
  final List<Color> colors;

  MultiArcPainter({required this.percentages, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final thickness = 12.0;
    final radius = (size.width - thickness) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    var startAngle = 3.14; // 180°

    for (int i = 0; i < percentages.length; i++) {
      final sweepAngle = 3.14 * (percentages[i] / 100);

      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
