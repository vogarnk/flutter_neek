import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../plans/activate_plan_intro_screen.dart';
import '../../shared/cards/card_neek.dart';
import 'package:neek/shared/cards/beneficiaries_card.dart';

class BeneficiariesScreen extends StatelessWidget {
  final Map<String, dynamic> user;
  final List<dynamic> beneficiarios;
  final int? userPlanId;

  const BeneficiariesScreen({
    super.key,
    required this.user,
    required this.beneficiarios,
    this.userPlanId,
  });

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
                  if (beneficiarios.isEmpty) {
                    _mostrarAlerta(context, 'Debes añadir al menos un beneficiario.');
                    return;
                  }

                  final int sumaPorcentajes = beneficiarios.fold<int>(
                    0,
                    (total, b) => total + (int.tryParse(b['porcentaje'].toString()) ?? 0),
                  );

                  if (sumaPorcentajes != 100) {
                    _mostrarAlerta(context, 'La suma de los porcentajes debe ser exactamente 100%. Actualmente tienes $sumaPorcentajes%.');
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ActivatePlanIntroScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Activar mi plan'),
              ),
            ),
            const SizedBox(height: 24),

            // Tabla de beneficiarios
            BeneficiariesCard(
              beneficiarios: beneficiarios,
              mostrarBoton: true, // o false en ConfirmedBeneficiariesScreen
              userPlanId: userPlanId ?? user['user_plan_id'] ?? user['plan_id'],
            ),            
          ],
        ),
      ),
    );
  }

  Widget _beneficiarioRow({
    required String nombre,
    required String tipo,
    required String acceso,
    required int porcentaje,
  }) {
    final bool esBasico = acceso == 'Básico';
    final Color bgColor = esBasico ? const Color(0xFFE8F0FF) : const Color(0xFFE0FFF5);
    final Color textColor = esBasico ? const Color(0xFF6366F1) : const Color(0xFF06B6D4);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFFE5E7EB), // gris claro de fondo
            child: Icon(
              Icons.person,
              color: Color(0xFF9CA3AF), // gris medio para el ícono
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nombre, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(tipo, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  acceso,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$porcentaje%',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF111928),
            ),
          ),
        ],
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