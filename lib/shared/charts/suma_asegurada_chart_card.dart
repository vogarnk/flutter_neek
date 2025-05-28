// lib/widgets/suma_asegurada_chart_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../painters/multi_arc_painter.dart';

/// Clipper que recorta todo el área por debajo de la línea media
class _TopHalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width, size.height / 2);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}

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
    final currencyFormat =
        NumberFormat.currency(locale: 'es_MX', symbol: 'MXN \$');
    final udisFormat = NumberFormat('#,###', 'es_MX');

    final percentages = beneficiarios
        .map((b) => (b['porcentaje'] as num).toDouble())
        .toList();
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
                        const Icon(Icons.lock,
                            size: 18, color: Color(0xFF111827)),
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
                      style:
                          TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                    ),
                    Text(
                      currencyFormat.format(sumaMxn),
                      style:
                          const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),

              // 🎯 Sólo mitad superior: Clippeamos TODO el Container
              SizedBox(
                width: 100,
                height: 100,
                child: ClipRect(
                  clipper: _TopHalfClipper(),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CustomPaint(
                      painter: MultiArcPainter(
                        percentages: percentages,
                        colors: colors,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(bottom: 20), // Ajusta este valor a tu gusto
                        child: Icon(
                          Icons.shield_outlined,
                          size: 18,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
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