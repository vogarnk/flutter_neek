import 'package:flutter/material.dart';
import 'package:neek/widgets/charts/animated_multi_ring_chart.dart';
import 'package:neek/widgets/common/status_chip.dart';

class AhorroCard extends StatelessWidget {
  const AhorroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                EstadoActivoChip(),
                SizedBox(height: 8),
                Text('Ahorro total', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('200,800 UDIS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Text('● Familia Monasteri', style: TextStyle(color: Colors.indigo)),
                Text('● Mi Futuro', style: TextStyle(color: Colors.indigo)),
                Text('● Mis Hijos', style: TextStyle(color: Colors.indigo)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const AnimatedMultiRingChart(
            values: [0.9, 0.8, 0.75],
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF2563EB),
              Color(0xFF60A5FA),
            ],
            size: 120,
          ),
        ],
      ),
    );
  }
}