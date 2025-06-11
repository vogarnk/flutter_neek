import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:neek/core/theme/app_colors.dart';

class BarChartCard extends StatelessWidget {
  const BarChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final barValue = 3792.0;
    final barYears = List.generate(5, (i) => 2023 + i);
    final barColor = const Color(0xFF16BDCA); // Color exacto

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'Aportación en UDIS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textGray900,
                ),
              ),
              Spacer(),
              Text('2023–2027', style: TextStyle(color: AppColors.textGray400)),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Text('🇲🇽 México', style: TextStyle(color: AppColors.textGray400)),
            ],
          ),
          const SizedBox(height: 16), // <-- más espacio para separar
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                barGroups: List.generate(barYears.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: barValue,
                        width: 32,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        color: barColor,
                      ),
                    ],
                  );
                }),
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, _) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            barValue.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textGray900,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, _) {
                        return Text(
                          '${2023 + value.toInt()}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textGray500,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                alignment: BarChartAlignment.spaceAround,
                maxY: 4000,
              ),
            ),
          ),
        ],
      ),
    );
  }
}