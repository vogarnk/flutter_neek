import 'package:flutter/material.dart';

class GradientCircleRing extends StatelessWidget {
  final double size;
  final double strokeWidth;

  const GradientCircleRing({
    super.key,
    this.size = 80,
    this.strokeWidth = 4,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _GradientRingPainter(strokeWidth: strokeWidth),
    );
  }
}

class _GradientRingPainter extends CustomPainter {
  final double strokeWidth;

  _GradientRingPainter({required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: 2 * 3.1416,
      colors: const [
        Color(0xFFEFEFEF),
        Color(0xFF762FC8),
        Color(0xFF2F39F7),
        Color(0xFF3483FB),
        Color(0xFF94FCCC),
        Color(0xFF5CD2F8),
        Color(0xFF71F7F7),
      ],
      stops: const [
        0.0,
        0.17,
        0.38,
        0.54,
        0.65,
        0.84,
        0.93,
      ],
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = gradient.createShader(rect);

    canvas.drawCircle(center, radius - strokeWidth / 2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}