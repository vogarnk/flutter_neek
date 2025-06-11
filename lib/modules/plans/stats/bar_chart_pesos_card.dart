import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:intl/intl.dart';

class BarChartPesosCard extends StatelessWidget {
  const BarChartPesosCard({super.key});

  @override
  Widget build(BuildContext context) {
    final valores = [29764, 30664, 31555, 32465, 33365];
    final formatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

    final double maxValor = valores.reduce((a, b) => a > b ? a : b).toDouble();
    final double maxY = (maxValor * 1.1).ceilToDouble(); // 10% extra para evitar empalme

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
                'Aportación en Pesos',
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
          const SizedBox(height: 16),
          SizedBox(
            height: 230,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(enabled: false),
                barGroups: List.generate(valores.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: valores[i].toDouble(),
                        width: 32,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        color: AppColors.primary,
                      )
                    ],
                  );
                }),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (value, _) {
                        final int index = value.toInt();
                        if (index >= 0 && index < valores.length) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              formatter.format(valores[index]),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textGray900,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
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
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}