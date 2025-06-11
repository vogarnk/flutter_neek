import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:neek/core/theme/app_colors.dart';

class ComparativosCard extends StatefulWidget {
  const ComparativosCard({super.key});

  @override
  State<ComparativosCard> createState() => _ComparativosCardState();
}

class _ComparativosCardState extends State<ComparativosCard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<int> aportacionesPeso = [0, 15000, 35000, 60000, 95000, 135000];
  final List<int> recuperacionPeso = [0, 12000, 28000, 46000, 72000, 100000];

  final List<int> aportacionesUdis = [0, 14000, 32000, 57000, 88000, 125000];
  final List<int> recuperacionUdis = [0, 10000, 24000, 42000, 67000, 92000];

  final List<String> years = ['2023', '2024', '2025', '2026', '2027', '2028'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPeso = _tabController.index == 0;
    final aportaciones = isPeso ? aportacionesPeso : aportacionesUdis;
    final recuperacion = isPeso ? recuperacionPeso : recuperacionUdis;

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
            "Comparativos",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textGray900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Aportaciones y Recuperación en 10 años de tu plan de ahorro",
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textGray400,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Legend(color: Colors.blue, text: 'Aportaciones'),
              SizedBox(width: 16),
              Legend(color: Colors.cyan, text: 'Recuperación'),
            ],
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: AppColors.textGray400,
            onTap: (_) => setState(() {}),
            tabs: const [
              Tab(child: Text("Peso")),
              Tab(child: Text("UDIs")),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 240,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 160000,
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final index = value.toInt();
                        return Text(
                          index < years.length ? years[index] : '',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textGray400,
                          ),
                        );
                      },
                      interval: 1,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      interval: 50000,
                      getTitlesWidget: (value, _) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          '\$${(value ~/ 1000).toString()},000',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textGray400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    spots: List.generate(aportaciones.length,
                        (i) => FlSpot(i.toDouble(), aportaciones[i].toDouble())),
                    barWidth: 3,
                    color: Colors.blue,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.2),
                    ),
                    dotData: FlDotData(show: false),                    
                  ),
                  LineChartBarData(
                    isCurved: true,
                    spots: List.generate(recuperacion.length,
                        (i) => FlSpot(i.toDouble(), recuperacion[i].toDouble())),
                    barWidth: 3,
                    color: Colors.cyan,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
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