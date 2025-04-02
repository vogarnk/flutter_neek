import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neek/widgets/common/gradient_circle_ring.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjeta interior oscura con contenido
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                // Información del plan
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/logo.svg',
                        height: 16,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 4),
                      Text('Mis Hijos',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 4),
                      Text('Lucia Monarrez', style: TextStyle(color: Colors.white)),
                      SizedBox(height: 12),
                      Text('MOTIVO DE AHORRO:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('Retiro', style: TextStyle(color: Colors.white, fontSize: 14)),
                      SizedBox(height: 4),
                      Text('PLAN DE AHORRO + PROTECCIÓN',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                // Círculo decorativo tipo gráfico
                const GradientCircleRing(size: 120, strokeWidth: 4),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Estado y botón
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3C7),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.access_time, size: 16, color: Color(0xFFB45309)),
                    SizedBox(width: 6),
                    Text(
                      'Por Activar',
                      style: TextStyle(
                        color: Color(0xFFB45309),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B5BFE),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Ver Plan'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Monto
          const Text(
            '160,860.49 UDIS',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}