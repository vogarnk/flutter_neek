import 'package:flutter/material.dart';
import 'package:neek/shared/charts/animated_multi_ring_chart.dart';
import 'package:neek/shared/common/status_chip.dart';
import 'package:intl/intl.dart';

class AhorroCard extends StatelessWidget {
  final List<Map<String, dynamic>> plans;

  const AhorroCard({super.key, required this.plans});

  @override
  Widget build(BuildContext context) {
    final List<String> planNames = plans.map((p) => p['nombre_plan'].toString()).toList();
    final double ahorroTotal = plans.fold(0.0, (sum, plan) {
      final value = double.tryParse(plan['recuperacion_final_udis'].toString()) ?? 0.0;
      return sum + value;
    });

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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${NumberFormat("#,###", "en_US").format(ahorroTotal)} UDIS',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),                  
                ),
                const SizedBox(height: 12),
                for (var name in planNames)
                  Text('● $name', style: const TextStyle(color: Colors.indigo)),
              ],
            ),
          ),
          const SizedBox(width: 12),
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
