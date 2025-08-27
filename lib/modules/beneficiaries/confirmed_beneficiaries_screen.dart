import 'package:flutter/material.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/shared/cards/card_neek.dart';
import 'package:neek/shared/cards/beneficiaries_card.dart';

class ConfirmedBeneficiariesScreen extends StatelessWidget {
  final Map<String, dynamic> user;
  final List<dynamic> beneficiarios;
  final int? userPlanId;
  final Map<String, dynamic>? currentPlan;
  final List<dynamic>? cotizaciones;

  const ConfirmedBeneficiariesScreen({
    super.key,
    required this.user,
    required this.beneficiarios,
    this.userPlanId,
    this.currentPlan,
    this.cotizaciones,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Beneficiarios'),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CardNeek(
              nombrePlan: 'Mi plan',
              mostrarBoton: false,
            ),
            const SizedBox(height: 24),
            if (beneficiarios.isEmpty)
              const Center(
                child: Text(
                  'No hay beneficiarios confirmados.',
                  style: TextStyle(color: AppColors.textGray400),
                ),
              )
            else
              BeneficiariesCard(
                beneficiarios: beneficiarios,
                mostrarBoton: false, // o false en ConfirmedBeneficiariesScreen
                userPlanId: user['user_plan_id'] ?? user['plan_id'],
              ),              
          ],
        ),
      ),
    );
  }

  Widget _buildBeneficiaryCard(dynamic b) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            b['nombre'] ?? 'Sin nombre',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textGray900,
            ),
          ),
          const SizedBox(height: 4),
          if (b['parentesco'] != null)
            Text(
              'Parentesco: ${b['parentesco']}',
              style: const TextStyle(color: AppColors.textGray900),
            ),
          if (b['fecha_nacimiento'] != null)
            Text(
              'Fecha de nacimiento: ${b['fecha_nacimiento']}',
              style: TextStyle(color: AppColors.textGray900),
            ),
        ],
      ),
    );
  }
}