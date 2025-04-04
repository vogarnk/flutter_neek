import 'package:flutter/material.dart';
import 'package:neek/widgets/charts/udi_line_chart.dart';

class UdiCard extends StatelessWidget {
  const UdiCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Texto
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '8.42 MXN 🇲🇽',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Valor del UDI al día de hoy',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          // Gráfico
          const SizedBox(
            width: 100,
            height: 60,
            child: UdiLineChart(),
          ),
        ],
      ),
    );
  }
}