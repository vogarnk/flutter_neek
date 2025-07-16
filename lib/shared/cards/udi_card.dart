import 'package:flutter/material.dart';
import 'package:neek/shared/charts/udi_line_chart.dart';
import 'package:intl/intl.dart';

class UdiCard extends StatelessWidget {
  final double? udisActual;

  const UdiCard({
    super.key,
    this.udisActual,
  });

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
            children: [
              Text(
                udisActual != null 
                    ? '${NumberFormat('#,##0.00', 'es_MX').format(udisActual!)} MXN 🇲🇽'
                    : '-- MXN 🇲🇽',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
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