import 'package:flutter/material.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/shared/cards/card_neek.dart';
import 'header_stats_card.dart';
import 'line_chart_card.dart';
import 'bar_chart_card.dart';
import 'bar_chart_pesos_card.dart';
import 'comparativos_card.dart';
import 'udi_vs_dollar_card.dart';

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
          children: const [
            HeaderStatsCard(),
            SizedBox(height: 16),
            CardNeek(nombrePlan: 'Mi plan', mostrarBoton: false),
            SizedBox(height: 16),
            LineChartCard(),
            SizedBox(height: 16),
            BarChartCard(),
            SizedBox(height: 16),
            BarChartPesosCard(),

            SizedBox(height: 16),
            ComparativosCard(),      
            SizedBox(height: 16),
            UdiVsDollarCard(),
          ],
        ),
      ),
    );
  }
}