import 'package:flutter/material.dart';
import '../../../pdfx_viewer_screen.dart';
import '../../../core/theme/app_colors.dart';

class PlanAuthorizedCard2 extends StatelessWidget {
  final String? polizaUrl;
  final Map<String, dynamic> user;
  
  const PlanAuthorizedCard2({
    super.key,
    this.polizaUrl,
    required this.user,
  });

  String _getFirstName() {
    final nombre = user['name'] ?? '';
    if (nombre.isEmpty) return 'Usuario';
    return nombre.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.primary600, size: 20),
              const SizedBox(width: 8),
              Text(
                '¡Felicidades, ${_getFirstName()}!',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Tu plan está activo, tus beneficiarios ahora están protegidos y tu ahorro va en camino al futuro.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.primary600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
