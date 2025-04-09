import 'package:flutter/material.dart';
import '../painters/arc_painter.dart';

class DetailCard extends StatelessWidget {
  final String title;
  final String udis;
  final String mxn;
  final IconData icon;
  final double progress; // 👈 Agregado

  const DetailCard({
    super.key,
    required this.title,
    required this.udis,
    required this.mxn,
    required this.icon,
    this.progress = 0.75, // 👈 Por defecto 75%
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Parte izquierda
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Colors.black),
                    const SizedBox(width: 6),
                    Text(
                      udis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  mxn,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),

          // Parte derecha: Circular progress
          Padding(
            padding: const EdgeInsets.only(top: 20), // 👈 Padding aplicado al gráfico completo
            child: SizedBox(
              width: 80,
              height: 80,
              child: CustomPaint(
                painter: ArcPainter(progress),
                child: const Center(
                  child: Icon(Icons.shield, size: 24, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}