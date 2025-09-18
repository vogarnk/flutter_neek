import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/core/quote_service.dart';

class SimulationPlanCard extends StatelessWidget {
  final PlanOption plan;
  final bool isSelected;
  final VoidCallback onTap;

  const SimulationPlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'es_MX', symbol: 'MXN');
    final numberFormat = NumberFormat('#,###', 'es_MX');
    
    // Calcular años de retiro
    final currentYear = DateTime.now().year;
    final anioCorto = currentYear + plan.planDuration;
    final anioLargo = 2050;
    
    // Calcular prima anual en UDIS
    final primaAnualUdis = double.tryParse(plan.primaAnualUdis) ?? 0.0;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                ? AppColors.primary.withOpacity(0.1)
                : Colors.black.withOpacity(0.03),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            // Encabezado con tipo de cobertura
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected 
                  ? AppColors.primary.withOpacity(0.1)
                  : const Color(0xFFEFF5FF),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ahorro + Protección ⭐️',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.primary : const Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCoverageColor(plan.coverageType),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getCoverageLabel(plan.coverageType),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Prima Anual
            _udiRow(
              title: 'Prima Anual (Ahorro anual)',
              amountUdis: '${numberFormat.format(primaAnualUdis.toInt())} UDIS',
              amountMxn: currencyFormat.format(plan.primaMensualMxn * 12),
              note: 'Proyección de UDI al día del hoy',
              isDarkBackground: true,
            ),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            
            // Suma Asegurada
            _udiRow(
              title: 'Suma Asegurada',
              subtitle: 'En caso de fallecimiento',
              amountUdis: '${numberFormat.format(double.tryParse(plan.sumaAseguradaUdis)?.toInt() ?? 0)} UDIS',
              amountMxn: currencyFormat.format(plan.sumaAseguradaMxn),
              note: 'Proyección de UDI al día del hoy',
              icon: Icons.shield_outlined,
              highlightSubtitle: true,
            ),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            
            // Total a retirar en año corto
            _udiRow(
              title: 'Total a retirar en $anioCorto',
              amountUdis: '${numberFormat.format(double.tryParse(plan.totalRetirarPlanUdis)?.toInt() ?? 0)} UDIS',
              amountMxn: currencyFormat.format(plan.totalRetirarPlanMxn),
              note: 'Proyección de UDI al día del hoy',
              isDarkBackground: true,
            ),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            
            // Total a retirar en 2050
            _udiRow(
              title: 'Total a retirar en $anioLargo',
              amountUdis: '${numberFormat.format(double.tryParse(plan.totalRetirar2050Udis)?.toInt() ?? 0)} UDIS',
              amountMxn: currencyFormat.format(plan.totalRetirar2050Mxn),
              note: 'Proyección de UDI al día del hoy',
            ),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            
            // Beneficiarios
            _infoBadgeRow(
              title: 'Beneficiarios',
              icon: Icons.people_outline,
              badgeText: '1',
              note: 'Persona designada para recibir el beneficio',
              isDarkBackground: true,
            ),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            
            // Coberturas
            _infoBadgeRow(
              title: 'Coberturas',
              icon: Icons.shield_outlined,
              badgeText: _getCoverageLabel(plan.coverageType),
              note: 'Tipo de protección incluida',
            ),
            
            // Debug: Archivo CSV
            if (plan.csvFile != null && plan.csvFile!.isNotEmpty)
              _buildCsvDebugInfo(plan.csvFile!),
          ],
        ),
      ),
    );
  }

  Widget _buildCsvDebugInfo(String csvFile) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.file_download_outlined,
                size: 16,
                color: Color(0xFF6B7280),
              ),
              const SizedBox(width: 6),
              const Text(
                'Archivo CSV:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            csvFile,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF374151),
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  String _getCoverageLabel(String coverageType) {
    switch (coverageType.toLowerCase()) {
      case 'sin cobertura':
      case 'none':
        return 'Básica';
      case 'cobertura extra':
      case 'extra':
        return 'Extra';
      case 'cobertura d3':
      case 'd3':
        return 'DI3';
      default:
        return coverageType;
    }
  }

  Color _getCoverageColor(String coverageType) {
    switch (coverageType.toLowerCase()) {
      case 'sin cobertura':
      case 'none':
        return const Color(0xFFE1EFFE);
      case 'cobertura extra':
      case 'extra':
        return const Color(0xFF1E429F);
      case 'cobertura d3':
      case 'd3':
        return const Color(0xFF111928);
      default:
        return const Color(0xFF2563EB);
    }
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
    bool isDarkBackground = false,
  }) {
    return Container(
      width: double.infinity,
      color: isDarkBackground ? AppColors.background50 : Colors.white,
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
                amountMxn,
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
