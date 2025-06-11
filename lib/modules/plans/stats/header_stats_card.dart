import 'package:flutter/material.dart';
import 'package:neek/core/theme/app_colors.dart';

class HeaderStatsCard extends StatelessWidget {
  const HeaderStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
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
}