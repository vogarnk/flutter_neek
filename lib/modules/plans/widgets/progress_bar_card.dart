import 'package:flutter/material.dart';

/// Widget de progreso tipo “Porcentaje de avance”
class ProgressBarCard extends StatelessWidget {
  final String title;
  /// Valor entre 0.0 y 1.0
  final double progress;
  /// Si quieres animar los cambios de progreso
  final Duration animationDuration;

  const ProgressBarCard({
    Key? key,
    required this.title,
    required this.progress,
    this.animationDuration = const Duration(milliseconds: 600),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    final percentText = '${(clamped * 100).toStringAsFixed(0)}%';

    // Colores similares a la captura
    const background = Color(0xFF0F172A); // gris-azul muy oscuro
    const track = Color(0xFFE5E7EB);      // gris claro
    const progressColor = Color(0xFF2B5FF3); // azul

    return Container(
      decoration: BoxDecoration(
        color: background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Encabezado: título a la izq, porcentaje a la der
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                percentText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Barra de progreso redondeada
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final fullWidth = constraints.maxWidth;
                return Stack(
                  children: [
                    // Track
                    Container(
                      height: 10,
                      width: fullWidth,
                      color: track,
                    ),
                    // Progreso animado
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: clamped),
                      duration: animationDuration,
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) {
                        return Container(
                          height: 10,
                          width: fullWidth * value,
                          color: progressColor,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}