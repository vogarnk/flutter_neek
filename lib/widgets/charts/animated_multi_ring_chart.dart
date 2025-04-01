import 'package:flutter/material.dart';
import 'dart:math';

/// Widget animado que muestra hasta 3 anillos concéntricos.
/// Cada anillo representa un valor proporcional (0.0 a 1.0)
/// y se dibuja con animación progresiva.
class AnimatedMultiRingChart extends StatelessWidget {
  final List<double> values; // Máximo 3 valores entre 0.0 y 1.0
  final List<Color> colors;
  final double size;
  final Duration duration;

  const AnimatedMultiRingChart({
    super.key,
    required this.values,
    required this.colors,
    this.size = 100,
    this.duration = const Duration(seconds: 1),
  });

  @override
  Widget build(BuildContext context) {
    final limitedValues = values.take(3).toList();
    final limitedColors = colors.take(3).toList();

    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: duration,
        builder: (context, animationValue, child) {
          return CustomPaint(
            painter: RingChartPainter(
              values: limitedValues,
              colors: limitedColors,
              progress: animationValue,
            ),
          );
        },
      ),
    );
  }
}

/// Painter personalizado para dibujar los anillos del gráfico.
class RingChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  final double progress;

  RingChartPainter({
    required this.values,
    required this.colors,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    const thickness = 8.0;
    const spacing = 6.0;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double currentRadius = size.width / 2 - thickness / 2;

    for (int i = 0; i < values.length; i++) {
      final sweep = 2 * pi * values[i] * progress;

      paint
        ..strokeWidth = thickness
        ..color = colors[i].withOpacity(0.9);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: currentRadius),
        -pi / 2,
        sweep,
        false,
        paint,
      );

      currentRadius -= thickness + spacing;
    }
  }

  @override
  bool shouldRepaint(covariant RingChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.values != values ||
        oldDelegate.colors != colors;
  }
}