import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:neek/core/theme/app_colors.dart';

class LineChartCard extends StatelessWidget {
  const LineChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Card blanco como en la imagen
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'Plan de ahorro',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textGray900,
                ),
              ),
              Spacer(),
              Text('UDI', style: TextStyle(color: AppColors.textGray400)),
              Switch(value: true, onChanged: null),
              Text('MXN', style: TextStyle(color: AppColors.textGray400)),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Progreso de tu plan de ahorro en 10 años',
            style: TextStyle(color: AppColors.textGray400, fontSize: 13),
          ),
          const SizedBox(height: 8),
          const Divider(height: 16),
          const Text(
            'Familia Monarrez',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220, // Antes: 200
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.textGray300.withOpacity(0.3),
                    strokeWidth: 1,
                  ),
                  drawVerticalLine: false,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28, // un poco más de espacio vertical
                      getTitlesWidget: (value, _) {
                        final year = 2023 + value.toInt();
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '$year',
                            style: const TextStyle(
                              color: AppColors.textGray500,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                      interval: 1,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 56, // antes era 48, ahora más ancho
                      getTitlesWidget: (value, _) {
                        if (value % 100000 == 0) {
                          return Text(
                            '\$${(value ~/ 1000).toStringAsFixed(0)},000',
                            style: const TextStyle(
                              color: AppColors.textGray500,
                              fontSize: 10,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 4,
                minY: 100000,
                maxY: 500000,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 100000),
                      FlSpot(1, 100000),
                      FlSpot(2, 200000),
                      FlSpot(3, 350000),
                      FlSpot(4, 500000),
                    ],
                    isCurved: true,
                    barWidth: 3,
                    color: AppColors.primary,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}