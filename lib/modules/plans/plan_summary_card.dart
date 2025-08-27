import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/shared/tables/udi_plan_summary.dart';

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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold , color: AppColors.background)),

          const SizedBox(height: 20),
          _formField('Plazo del ahorro', '$plazo años'),
          const SizedBox(height: 12),
          _formField('Ahorro anual', currencyFormat.format(ahorroAnual)),

          const SizedBox(height: 20),

          UdiPlanSummaryCard(
            primaAnual: primaAnual,
            sumaAsegurada: sumaAsegurada,
            totalRetirarCorto: totalRetirarCorto,
            totalRetirarLargo: totalRetirarLargo,
            anioCorto: anioCorto,
            anioLargo: anioLargo,
            beneficiarios: beneficiarios,
            udisActual: 8.54, // Valor por defecto, idealmente debería venir como parámetro
          ),

          const SizedBox(height: 24),
          const Text(
            'Revisa tu cotización más información a detalle. Toma en cuenta que el total a retirar o el valor de recuperación puede verse afectado por movimientos como préstamos o abonos que realices.',
            style: TextStyle(fontSize: 10, color: AppColors.textGray400),
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
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: const BorderSide(
                      color: AppColors.textGray200, // 👈 gray50 (muy claro)
                      width: 1.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {}, // TODO: Acción Activar
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text(
                    'Activar',
                    overflow: TextOverflow.ellipsis, // 👈 evita desbordamiento
                    softWrap: false,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // 👈 suficiente espacio
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textGray900, // Título en gris oscuro
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.background50, // 👈 Fondo claro
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.textGray300, // 👈 Borde gris
              width: 1.0,
            ),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textGray500, // Texto oscuro
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}