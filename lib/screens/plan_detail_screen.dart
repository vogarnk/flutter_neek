// PASO 1: Crea una pantalla de detalles del plan (PlanDetailScreen)
import 'package:flutter/material.dart';
import 'package:neek/widgets/app_bars/custom_home_app_bar.dart'; // 👈 Importa el widget
import 'package:neek/widgets/cards/detail_card.dart';
import 'package:neek/widgets/buttons/plan_action_button.dart';
import 'package:intl/intl.dart';

class PlanDetailScreen extends StatelessWidget {
  final String nombrePlan;
  final double udis;
  final double sumaAsegurada;
  final double totalRetirar;
  final double totalRetirar2065;
  final int duracion;

  const PlanDetailScreen({
    super.key,
    required this.nombrePlan,
    required this.udis,
    required this.sumaAsegurada,
    required this.totalRetirar,
    required this.totalRetirar2065,
    required this.duracion,
  });


  @override
  Widget build(BuildContext context) {
  final currencyFormat = NumberFormat.currency(locale: 'es_MX', symbol: 'MXN \$');
  final numberFormat = NumberFormat('#,###', 'es_MX'); // Para UDIS
  final currentYear = DateTime.now().year;
  final retiroEnAnio = currentYear + duracion;


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
              udis: '${numberFormat.format(udis)} UDIS',
              mxn: 'MXN \$1,308,409.47',
              icon: Icons.shield_outlined,
            ),
            const SizedBox(height: 16),
            DetailCard(
              title: 'Total a Retirar en $retiroEnAnio',
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
