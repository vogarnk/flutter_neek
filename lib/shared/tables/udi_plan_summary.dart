import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neek/core/theme/app_colors.dart';

class UdiPlanSummaryCard extends StatelessWidget {
  const UdiPlanSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
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
          // Encabezado azul
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
          _udiRow(
            title: 'Prima Anual (Ahorro anual)',
            amountUdis: '62,093 UDIS',
            amountMxn: '\$662,093.16',
            note: 'Proyección de UDI al día del hoy',
            isDarkBackground: true,
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _udiRow(
            title: 'Suma Asegurada',
            subtitle: 'En caso de fallecimiento',
            amountUdis: '280,000 UDIS',
            amountMxn: '\$2,318,400',
            note: 'Proyección de UDI al día del hoy',
            icon: Icons.shield_outlined,
            highlightSubtitle: true,
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _udiRow(
            title: 'Total a retirar en 2029',
            amountUdis: '32,093 UDIS',
            amountMxn: '\$462,093.16',
            note: 'Proyección de UDI al día del hoy',
            isDarkBackground: true,
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _udiRow(
            title: 'Total a retirar en 2050',
            amountUdis: '32,093 UDIS',
            amountMxn: '\$462,093.16',
            note: 'Proyección de UDI al día del hoy',
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
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
            badgeText: 'Basica +',
            note: 'Coberturas incluidas en tu plan',
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
    bool isDarkBackground = false, // 👈 nuevo
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: isDarkBackground ? AppColors.background50 : Colors.white, // 👈 fondo
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
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
                Text(
                  badgeText,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            note,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }



  Widget _udiRow({
    required String title,
    String? subtitle,
    required String amountUdis,
    required String amountMxn,
    required String note,
    IconData? icon,
    bool highlightSubtitle = false,
    bool isDarkBackground = false, // 👈 nuevo
  }) {
    return Container(
      width: double.infinity,
      color: isDarkBackground ? AppColors.background50 : Colors.white, // 👈 fondo intercalado
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
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
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              amountUdis,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("🇲🇽 ", style: TextStyle(fontSize: 16)),
              Text(
                'MXN $amountMxn',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              note,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF9CA3AF),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
