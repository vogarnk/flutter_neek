import 'package:flutter/material.dart';
import 'package:neek/widgets/charts/animated_multi_ring_chart.dart';
import 'package:neek/widgets/common/status_chip.dart';

class AhorroCard extends StatelessWidget {
  final List<String> planNames;

  const AhorroCard({super.key, required this.planNames});

  @override
  Widget build(BuildContext context) {
    final List<double> ringValues = _getRingValues(planNames.length);
    final List<Color> ringColors = _getRingColors(planNames.length);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Columna con texto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const EstadoActivoChip(),
                const SizedBox(height: 8),
                const Text(
                  'Ahorro total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  '200,800 UDIS',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                // Lista de nombres de planes
                for (var name in planNames)
                  Text('● $name', style: const TextStyle(color: Colors.indigo)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Gráfico con anillos
          AnimatedMultiRingChart(
            values: ringValues,
            colors: ringColors,
            size: 120,
          ),
        ],
      ),
    );
  }

  List<double> _getRingValues(int count) {
    switch (count) {
      case 1:
        return [0.9];
      case 2:
        return [0.9, 0.8];
      case 3:
        return [0.9, 0.8, 0.75];
      default:
        return List.generate(count, (i) => 0.7 - (i * 0.05));
    }
  }

  List<Color> _getRingColors(int count) {
    const defaultColors = [
      Color(0xFF1E3A8A),
      Color(0xFF2563EB),
      Color(0xFF60A5FA),
      Color(0xFF93C5FD),
      Color(0xFFC7D2FE),
    ];

    return List.generate(count, (i) => defaultColors[i % defaultColors.length]);
  }
}