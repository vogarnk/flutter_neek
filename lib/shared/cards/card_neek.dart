import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neek/shared/common/gradient_circle_ring.dart';

class CardNeek extends StatelessWidget {
  final String nombrePlan;

  const CardNeek({
    super.key,
    required this.nombrePlan,
  });


  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width, // 🔧 Ocupa todo el ancho disponible
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                      const SizedBox(height: 4),
                      Text(
                        nombrePlan,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('MOTIVO DE AHORRO:', style: TextStyle(color: Colors.white, fontSize: 12)),
                      const Text('Retiro', style: TextStyle(color: Colors.white, fontSize: 14)),
                      const SizedBox(height: 4),
                      const Text('PLAN DE AHORRO + PROTECCIÓN', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Centrado vertical
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    GradientCircleRing(size: 90, strokeWidth: 4),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}