import 'package:flutter/material.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/shared/cards/card_neek.dart'; // Ajusta si tu path es diferente
import 'package:fl_chart/fl_chart.dart'; // Asegúrate de tener este paquete en pubspec.yaml

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Stats',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 16),
            const CardNeek(nombrePlan: 'Mi plan', mostrarBoton: false),
            const SizedBox(height: 16),
            _buildLineChartCard(),
            const SizedBox(height: 16),
            _buildBarChartCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(Icons.show_chart, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Stats',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.textGray900,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Análisis del crecimiento de tu proyecto',
            style: TextStyle(color: AppColors.textGray400),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChartCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background50,
        borderRadius: BorderRadius.circular(20),
      ),
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
          const Text(
            'Progreso de tu plan de ahorro en 10 años',
            style: TextStyle(color: AppColors.textGray400),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final year = 2023 + value.toInt();
                        return Text('$year', style: const TextStyle(fontSize: 10));
                      },
                      interval: 1,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
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
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChartCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background50,
        borderRadius: BorderRadius.circular(20),
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
              Text(
                '2023–2027',
                style: TextStyle(color: AppColors.textGray400),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Text('🇲🇽 México', style: TextStyle(color: AppColors.textGray400)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                barGroups: List.generate(5, (index) {
                  return BarChartGroupData(x: index, barRods: [
                    BarChartRodData(
                      toY: 3792,
                      width: 20,
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.teal,
                    ),
                  ]);
                }),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        return Text('${2023 + value.toInt()}', style: const TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}