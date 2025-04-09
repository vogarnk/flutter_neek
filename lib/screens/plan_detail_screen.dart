// PASO 1: Crea una pantalla de detalles del plan (PlanDetailScreen)
import 'package:flutter/material.dart';
import 'package:neek/widgets/app_bars/custom_home_app_bar.dart'; // 👈 Importa el widget
import 'package:neek/widgets/cards/detail_card.dart';
import 'package:neek/widgets/buttons/plan_action_button.dart';

class PlanDetailScreen extends StatelessWidget {
  final String nombrePlan;
  final double udis;

  const PlanDetailScreen({
    super.key,
    required this.nombrePlan,
    required this.udis,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface, // Fondo oscuro
      appBar: AppBar(
        automaticallyImplyLeading: true, // Muestra flecha si hay navegación previa
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: const CustomHomeAppBar(), // ✅ Aquí se pone correctamente
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nombrePlan,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFDC847),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Por Activar',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            DetailCard(
              title: 'Suma Asegurada',
              udis: '50,198 UDIS',
              mxn: 'MXN \$1,308,409.47',
              icon: Icons.shield_outlined,
            ),
            const SizedBox(height: 16),
            DetailCard(
              title: 'Total a Retirar en 2028',
              udis: '200,800 UDIS',
              mxn: 'MXN \$1,308,409.47',
              icon: Icons.savings_outlined,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E5AFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Activar mi plan',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                PlanActionButton(icon: Icons.calculate, label: 'Cotización'),
                PlanActionButton(icon: Icons.settings, label: 'Ajustes'),
                PlanActionButton(icon: Icons.people, label: 'Beneficiarios'),
                PlanActionButton(icon: Icons.description, label: 'Legal'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
