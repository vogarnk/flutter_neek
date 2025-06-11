import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:neek/core/theme/app_colors.dart';

class UdiVsDollarCard extends StatelessWidget {
  const UdiVsDollarCard({super.key});

  @override
  Widget build(BuildContext context) {
    final months = ['Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    final dollarValues = [17.00, 17.29, 18.08, 17.49, 17.72];
    final udiValues = [7.82, 7.87, 7.89, 7.90, 7.97];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'UDI vs Dolar 🇺🇸',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textGray900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Variación del UDI contra Dólar Americano\nen el último año',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textGray400,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.textGray200),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.calendar_today_outlined,
                    size: 16, color: AppColors.textGray400),
                SizedBox(width: 6),
                Text(
                  'Agosto-Diciembre 2023',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textGray900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 240,
            child: Stack(
              children: [
                BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 20,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            int i = value.toInt();
                            return Text(
                              i < months.length ? months[i] : '',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textGray400,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(months.length, (i) {
                      return BarChartGroupData(
                        x: i,
                        barsSpace: 0, // barras pegadas
                        barRods: [
                          BarChartRodData(
                            toY: dollarValues[i],
                            width: 20,
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          BarChartRodData(
                            toY: udiValues[i],
                            width: 20,
                            color: Colors.cyan,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(months.length, (i) {
                        return Column(
                          children: [
                            Text(
                              '\$${dollarValues[i].toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textGray900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${udiValues[i].toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textGray400,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Legend(color: Colors.blue, text: 'Dólar'),
              SizedBox(width: 16),
              Legend(color: Colors.cyan, text: 'UDI'),
            ],
          ),
        ],
      ),
    );
  }
}

class Legend extends StatelessWidget {
  final Color color;
  final String text;

  const Legend({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: AppColors.textGray900),
        ),
      ],
    );
  }
}