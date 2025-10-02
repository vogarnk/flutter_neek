import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../plans/activate_plan_intro_screen.dart';
import '../../shared/cards/card_neek.dart';
import 'package:neek/shared/cards/beneficiaries_card.dart';
import '../plans/contributions/next_contribution_screen.dart';

class BeneficiariesScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final List<dynamic> beneficiarios;
  final int? userPlanId;
  final String status;
  final Map<String, dynamic>? currentPlan;
  final List<dynamic>? cotizaciones;

  const BeneficiariesScreen({
    super.key,
    required this.user,
    required this.beneficiarios,
    this.userPlanId,
    required this.status,
    this.currentPlan,
    this.cotizaciones,
  });

  @override
  State<BeneficiariesScreen> createState() => _BeneficiariesScreenState();
}

class _BeneficiariesScreenState extends State<BeneficiariesScreen> {
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
        backgroundColor: AppColors.background,
        title: const Text('Beneficiarios'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Alerta superior
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.person_add_alt, color: AppColors.primary),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Añade a tus beneficiarios\nPara poder activar tu plan debes añadir a tus beneficiarios, una vez que los agregues podrás continuar',
                      style: TextStyle(color: AppColors.textGray900, fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tarjeta del plan
            CardNeek(nombrePlan: 'Mi plan', mostrarBoton: false),

            const SizedBox(height: 16),

            // Botón Activar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_beneficiarios.isEmpty) {
                    _mostrarAlerta(context, 'Debes añadir al menos un beneficiario.');
                    return;
                  }

                  final int sumaPorcentajes = _beneficiarios.fold<int>(
                    0,
                    (total, b) => total + (int.tryParse(b['porcentaje'].toString()) ?? 0),
                  );

                  if (sumaPorcentajes != 100) {
                    _mostrarAlerta(context, 'La suma de los porcentajes debe ser exactamente 100%. Actualmente tienes $sumaPorcentajes%.');
                    return;
                  }

                  if (widget.status == 'autorizado_por_pagar_1') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NextContributionScreen(
                          user: widget.user,
                          userPlan: widget.currentPlan ?? {
                            'id': widget.userPlanId ?? widget.user['user_plan_id'] ?? widget.user['plan_id'],
                            'nombre_plan': 'Mi Plan',
                            'status': widget.status,
                            'duracion': 5,
                            'numero_poliza': 'N/A',
                            'periodicidad': 'anual',
                            'udis': 100000,
                            'beneficiarios': _beneficiarios,
                          },
                          cotizaciones: widget.cotizaciones ?? [], // Usar cotizaciones reales si están disponibles
                          userPlanId: widget.userPlanId ?? widget.user['user_plan_id'] ?? widget.user['plan_id'],
                        ),
                      ),
                    );
                  } else {
                    // Navegar a activate_plan_intro_screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ActivatePlanIntroScreen()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.status == 'autorizado_por_pagar_1' 
                          ? 'Comenzar y pagar primera aportación'
                          : 'Activar mi plan'
                    ),
                    if (widget.status == 'autorizado_por_pagar_1') ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 20),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tabla de beneficiarios
            BeneficiariesCard(
              beneficiarios: _beneficiarios,
              mostrarBoton: widget.status != 'autorizado_por_pagar_1', // No mostrar botón si está autorizado por pagar
              userPlanId: widget.userPlanId ?? widget.user['user_plan_id'] ?? widget.user['plan_id'],
              onBeneficiariosUpdated: _onBeneficiariosUpdated,
            ),            
          ],
        ),
      ),
    );
  }



  void _mostrarAlerta(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Atención'),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}