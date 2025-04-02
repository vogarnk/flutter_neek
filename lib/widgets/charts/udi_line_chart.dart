import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class UdiLineChart extends StatelessWidget {
  const UdiLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _UdiChartPainter(),
    );
  }
}

class _UdiChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final points = [
      Offset(0, size.height * 0.85),
      Offset(size.width * 0.2, size.height * 0.75),
      Offset(size.width * 0.4, size.height * 0.6),
      Offset(size.width * 0.6, size.height * 0.45),
      Offset(size.width * 0.8, size.height * 0.35),
      Offset(size.width, size.height * 0.25),
    ];

    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      final controlPoint = Offset(
        (points[i - 1].dx + points[i].dx) / 2,
        (points[i - 1].dy + points[i].dy) / 2,
      );
      path.quadraticBezierTo(
        points[i - 1].dx,
        points[i - 1].dy,
        controlPoint.dx,
        controlPoint.dy,
      );
    }

    // Cierre del path para el área del relleno
    final filledPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    // Gradiente más preciso (basado en tu imagen)
    final gradient = ui.Gradient.linear(
      Offset(0, 0),
      Offset(0, size.height),
      [
        const Color(0xFF2B5FF3).withOpacity(1.0),
        const Color(0xFF2D60F3).withOpacity(0.99),
        const Color(0xFFFFFFFF).withOpacity(0.0),
      ],
      [0.0, 0.0, 1.0],
    );

    final fillPaint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = const Color(0xFF2B5FF3)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(filledPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}