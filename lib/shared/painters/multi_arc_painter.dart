// lib/painters/multi_arc_painter.dart
import 'dart:math';
import 'package:flutter/material.dart';

class MultiArcPainter extends CustomPainter {
  final List<double> percentages;
  final List<Color> colors;

  MultiArcPainter({
    required this.percentages,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final thickness = 12.0;
    final radius = (size.width - thickness) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final arcRect = Rect.fromCircle(center: center, radius: radius);

    // 1) recortamos a la mitad superior
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height / 2));

    // 2) dibujamos los arcos normalmente
    var startAngle = pi; // 180°
    for (int i = 0; i < percentages.length; i++) {
      final sweepAngle = pi * (percentages[i] / 100);
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(arcRect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}