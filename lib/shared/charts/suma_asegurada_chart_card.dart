import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../painters/multi_arc_painter.dart';

class SumaAseguradaChartCard extends StatelessWidget {
  final double sumaUdis;
  final double sumaMxn;
  final List<Map<String, dynamic>> beneficiarios;

  const SumaAseguradaChartCard({
    super.key,
    required this.sumaUdis,
    required this.sumaMxn,
    required this.beneficiarios,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'es_MX', symbol: 'MXN \$');
    final udisFormat = NumberFormat('#,###', 'es_MX');

    final percentages = beneficiarios.map((b) => (b['porcentaje'] as num).toDouble()).toList();
    final colors = beneficiarios.map((b) => b['color'] as Color).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔒 Texto izquierdo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lock, size: 18, color: Color(0xFF111827)),
                        const SizedBox(width: 6),
                        Text(
                          '${udisFormat.format(sumaUdis)} UDIS',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Suma Asegurada',
                      style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                    ),
                    Text(
                      currencyFormat.format(sumaMxn),
                      style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),

              // 🎯 Arco de beneficiarios
SizedBox(
  width: 72,
  height: 72,
  child: Container(
    decoration: const BoxDecoration(
      color: Color(0xFFE0F2F1), // Fondo verde claro
      shape: BoxShape.circle,
    ),
    child: CustomPaint(
      painter: MultiArcPainter(percentages: percentages, colors: colors),
      child: const Center(
        child: Icon(Icons.shield_outlined, size: 18, color: Color(0xFF111827)),
      ),
    ),
  ),
)

            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: beneficiarios.map((b) {
              return Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: b['color'],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    b['nombre'],
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
