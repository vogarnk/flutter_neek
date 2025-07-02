import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neek/core/theme/app_colors.dart';

class UdiPlanSummaryCard extends StatelessWidget {
  final Map<String, dynamic> planData;

  const UdiPlanSummaryCard({Key? key, required this.planData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'es_MX', symbol: '\$');
    // Datos básicos del plan
    final int duracion = planData['duracion_plan'] as int;
    final double primaAnualPesos = double.tryParse(planData['prima_anual_pesos']) ?? 0;
    final double primaAnualUdis = double.tryParse(planData['prima_anual_udis']) ?? 0;
    final double udiRate = primaAnualUdis > 0 ? primaAnualPesos / primaAnualUdis : 0;

    // Protección de vida
    final double proteccionPesos = double.tryParse(planData['seguro_vida_proteccion']) ?? 0;
    final double proteccionUdis = udiRate > 0 ? proteccionPesos / udiRate : 0;

    // Cálculo de años de retiro
    final int currentYear = DateTime.now().year;
    final int targetYear = currentYear + duracion;
    final String? retiroTargetStr = planData['retira_$targetYear'];
    final String? retiro2050Str = planData['retira_2050'];

    double? retiroTarget = retiroTargetStr != null ? double.tryParse(retiroTargetStr) : null;
    double? retiro2050 = retiro2050Str != null ? double.tryParse(retiro2050Str) : null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          // Encabezado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF5FF),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Center(
              child: Text(
                'Ahorro + Protección ⭐️',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ),

          // Prima anual
          _udiRow(
            title: 'Prima Anual (Ahorro anual)',
            amountUdis: '${primaAnualUdis.toStringAsFixed(2)} UDIS',
            amountMxn: currencyFormat.format(primaAnualPesos),
            note: 'Proyección de UDI al día de hoy',
            isDarkBackground: true,
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // Suma Asegurada
          _udiRow(
            title: 'Suma Asegurada',
            subtitle: 'En caso de fallecimiento',
            amountUdis: currencyFormat.format(proteccionPesos),
            icon: Icons.shield_outlined,
            highlightSubtitle: true,
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // Retiro en año objetivo
          if (retiroTarget != null)
            _udiRow(
              title: 'Total a retirar en $targetYear',

              amountUdis: currencyFormat.format(retiroTarget), 
              isDarkBackground: true,
            ),
          if (retiroTarget != null)
            const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // Retiro en 2050 (siempre existe)
          if (retiro2050 != null)
            _udiRow(
              title: 'Total a retirar en 2050',
              amountUdis: currencyFormat.format(retiro2050),
            ),
          if (retiro2050 != null)
            const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // Beneficiarios y Coberturas (estáticos)
          _infoBadgeRow(
            title: 'Beneficiarios',
            icon: Icons.groups_3_outlined,
            badgeText: '+3 Beneficiarios',
            note: 'Recomendado',
            isDarkBackground: true,
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _infoBadgeRow(
            title: 'Coberturas',
            icon: Icons.shield_outlined,
            badgeText: 'Básica +',
            note: 'Coberturas incluidas en tu plan',
          ),
        ],
      ),
    );
  }

  Widget _udiRow({
    required String title,
    String? subtitle,
    String? amountUdis,
    String? amountMxn,
    String? note,
    IconData? icon,
    bool highlightSubtitle = false,
    bool isDarkBackground = false,
  }) {
    return Container(
      width: double.infinity,
      color: isDarkBackground ? AppColors.background50 : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111827),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 4),
              const Icon(Icons.info_outline, size: 14, color: Color(0xFF9CA3AF)),
            ],
          ),

          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: highlightSubtitle ? const Color(0xFF2563EB) : const Color(0xFF6B7280),
                  fontWeight: highlightSubtitle ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          if (amountUdis != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                amountUdis!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
                textAlign: TextAlign.center,
              ),
            ),

          if (amountMxn != null)
            const SizedBox(height: 4),

          if (amountMxn != null)
            Text(
              amountMxn!,
              style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
            ),

          if (note != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                note!,
                style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoBadgeRow({
    required String title,
    required IconData icon,
    required String badgeText,
    required String note,
    bool isDarkBackground = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: isDarkBackground ? AppColors.background50 : Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF6B7280))),
              const SizedBox(width: 4),
              const Icon(Icons.info_outline, size: 14, color: Color(0xFF9CA3AF)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: const Color(0xFF2563EB)),
                const SizedBox(width: 6),
                Text(badgeText, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(note, style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
        ],
      ),
    );
  }
}