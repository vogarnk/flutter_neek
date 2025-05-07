import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class UdiLineChart extends StatelessWidget {
  const UdiLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Dale un tamaño cualquiera para ver mejor la gráfica
      width: 300,
      height: 200,
      child: CustomPaint(
        painter: _UdiChartPainter(),
      ),
    );
  }
}

class _UdiChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Definimos los puntos para la línea
    final points = [
      Offset(0, size.height * 0.85),
      Offset(size.width * 0.2, size.height * 0.75),
      Offset(size.width * 0.4, size.height * 0.6),
      Offset(size.width * 0.6, size.height * 0.45),
      Offset(size.width * 0.8, size.height * 0.35),
      Offset(size.width, size.height * 0.25),
    ];

    // Creamos la ruta
    final path = Path()..moveTo(points.first.dx, points.first.dy);

    // Usamos Bezier cuadráticas para suavizar la curva
    for (int i = 1; i < points.length; i++) {
      final midpoint = Offset(
        (points[i - 1].dx + points[i].dx) / 2,
        (points[i - 1].dy + points[i].dy) / 2,
      );

      path.quadraticBezierTo(
        points[i - 1].dx,
        points[i - 1].dy,
        midpoint.dx,
        midpoint.dy,
      );
    }

    // Terminamos la curva en el último punto (opcional, si lo deseas exacto)
    path.lineTo(points.last.dx, points.last.dy);

    // Creamos otra ruta para rellenar, partiendo de la original
    final filledPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    // Definimos un gradiente vertical (de arriba a abajo)
    final gradient = ui.Gradient.linear(
      Offset(0, 0),
      Offset(0, size.height),
      [
        // Empieza con tu color principal
        const Color(0xFF2B5FF3).withOpacity(0.3),
        // Termina completamente transparente
        const Color(0xFF2B5FF3).withOpacity(0.02)
      ],
      // Stops bien definidos: 0.0 hasta 1.0
      [0.0, 0.8],
    );

    // Pintura para el relleno con gradiente
    final fillPaint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.fill;

    // Pintura para la línea
    final linePaint = Paint()
      ..color = const Color(0xFF2B5FF3)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Dibujamos primero el relleno, luego la línea
    canvas.drawPath(filledPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}