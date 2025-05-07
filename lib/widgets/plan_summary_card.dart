import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlanSummaryScreen extends StatelessWidget {
  final int plazo;
  final double ahorroAnual;
  final double primaAnual;
  final double sumaAsegurada;
  final double totalRetirarCorto;
  final double totalRetirarLargo;
  final int anioCorto;
  final int anioLargo;
  final int beneficiarios;

  const PlanSummaryScreen({
    super.key,
    required this.plazo,
    required this.ahorroAnual,
    required this.primaAnual,
    required this.sumaAsegurada,
    required this.totalRetirarCorto,
    required this.totalRetirarLargo,
    required this.anioCorto,
    required this.anioLargo,
    required this.beneficiarios,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: PlanSummaryCard(
            plazo: plazo,
            ahorroAnual: ahorroAnual,
            primaAnual: primaAnual,
            sumaAsegurada: sumaAsegurada,
            totalRetirarCorto: totalRetirarCorto,
            totalRetirarLargo: totalRetirarLargo,
            anioCorto: anioCorto,
            anioLargo: anioLargo,
            beneficiarios: beneficiarios,
          ),
        ),
      ),
    );
  }
}

class PlanSummaryCard extends StatelessWidget {
  final int plazo;
  final double ahorroAnual;
  final double primaAnual;
  final double sumaAsegurada;
  final double totalRetirarCorto;
  final double totalRetirarLargo;
  final int anioCorto;
  final int anioLargo;
  final int beneficiarios;

  const PlanSummaryCard({
    super.key,
    required this.plazo,
    required this.ahorroAnual,
    required this.primaAnual,
    required this.sumaAsegurada,
    required this.totalRetirarCorto,
    required this.totalRetirarLargo,
    required this.anioCorto,
    required this.anioLargo,
    required this.beneficiarios,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'es_MX', symbol: 'MXN');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Detalles de tu plan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

          const SizedBox(height: 20),
          _formField('Plazo del ahorro', '$plazo años'),
          const SizedBox(height: 12),
          _formField('Ahorro anual', currencyFormat.format(ahorroAnual)),

          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Ahorro + Protección',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B5BFF))),
                SizedBox(width: 6),
                Icon(Icons.star, size: 18, color: Color(0xFF3B5BFF))
              ],
            ),
          ),

          const SizedBox(height: 24),
          _summaryTile('Prima Anual (Ahorro anual)', primaAnual, 662093.16),
          const SizedBox(height: 16),
          _summaryTile('Suma Asegurada', sumaAsegurada, 2318400.00,
              subtitle: 'En caso de fallecimiento'),
          const SizedBox(height: 16),
          _summaryTile('Total a retirar en $anioCorto', totalRetirarCorto, 462093.16),
          const SizedBox(height: 16),
          _summaryTile('Total a retirar en $anioLargo', totalRetirarLargo, 462093.16),

          const SizedBox(height: 24),
          _infoTile(Icons.people, '+$beneficiarios Beneficiarios', 'Recomendado'),
          const SizedBox(height: 16),
          _infoTile(Icons.verified_user, 'Básica +', 'Coberturas incluidas en tu plan'),

          const SizedBox(height: 24),
          const Text(
            'Revisa tu cotización más información a detalle. Toma en cuenta que el total a retirar o el valor de recuperación puede verse afectado por movimientos como préstamos o abonos que realices.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),

          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {}, // TODO: Acción Ajustar
                  icon: const Icon(Icons.tune),
                  label: const Text('Ajustar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {}, // TODO: Acción Activar
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Activar mi plan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E5AFF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _formField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(value),
        ),
      ],
    );
  }

  Widget _summaryTile(String title, double udis, double mxn, {String? subtitle}) {
    final currencyFormat = NumberFormat.currency(locale: 'es_MX', symbol: 'MXN');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        if (subtitle != null)
          Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 6),
        Text('${udis.toStringAsFixed(0)} UDIS',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(currencyFormat.format(mxn), style: const TextStyle(fontSize: 14)),
        const Text('Proyección de UDI al día del hoy',
            style: TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }

  Widget _infoTile(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFFE0ECFF),
          child: Icon(icon, color: const Color(0xFF3A5BFF)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        )
      ],
    );
  }
}