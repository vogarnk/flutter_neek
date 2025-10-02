import 'package:flutter/material.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/shared/cards/card_neek.dart';
import 'package:neek/shared/cards/beneficiaries_card.dart';

class ConfirmedBeneficiariesScreen extends StatefulWidget {
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
  State<ConfirmedBeneficiariesScreen> createState() => _ConfirmedBeneficiariesScreenState();
}

class _ConfirmedBeneficiariesScreenState extends State<ConfirmedBeneficiariesScreen> {
  late List<dynamic> _beneficiarios;

  @override
  void initState() {
    super.initState();
    _beneficiarios = widget.beneficiarios;
  }

  void _onBeneficiariosUpdated() {
    setState(() {
      // La lista se actualizará automáticamente desde el BeneficiariesCard
    });
  }

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
            if (_beneficiarios.isEmpty)
              const Center(
                child: Text(
                  'No hay beneficiarios confirmados.',
                  style: TextStyle(color: AppColors.textGray400),
                ),
              )
            else
              BeneficiariesCard(
                beneficiarios: _beneficiarios,
                mostrarBoton: false, // o false en ConfirmedBeneficiariesScreen
                userPlanId: widget.user['user_plan_id'] ?? widget.user['plan_id'],
                onBeneficiariosUpdated: _onBeneficiariosUpdated,
              ),              
          ],
        ),
      ),
    );
  }
}