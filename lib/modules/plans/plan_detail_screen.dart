// PASO 1: Crea una pantalla de detalles del plan (PlanDetailScreen)
import 'package:flutter/material.dart';
import 'package:neek/shared/app_bars/custom_home_app_bar.dart'; // 👈 Importa el widget
import 'package:neek/shared/cards/detail_card.dart';
import 'package:neek/shared/buttons/plan_action_button.dart';
import 'package:intl/intl.dart';
import 'package:neek/shared/cards/udi_card.dart';
import 'package:neek/shared/tables/plan_contributions_screen.dart' show PlanContributionsTable;
import '../verification/verificacion_completada_screen.dart';
import 'package:neek/modules/verification/verificacion_screen.dart';
import '../beneficiaries/beneficiaries_screen.dart';
import 'plan_settings_screen.dart';
import '../beneficiaries/beneficiaries_screen.dart';

class PlanDetailScreen extends StatelessWidget {
  final String nombrePlan;
  final int duracion;
  final double recuperacionFinalUdis;
  final double recuperacionFinalMxn;
  final double sumaAsegurada;
  final double sumaAseguradaMxn;
  final double totalRetirar;
  final double totalRetirarMxn;
  final double totalRetirar2065;
  final double totalRetirar2065Mxn;
  final Map<String, dynamic> user;
  final List<dynamic> beneficiarios;

  const PlanDetailScreen({
    super.key,
    required this.user,
    required this.beneficiarios, // 👈 nuevo
    required this.nombrePlan,
    required this.duracion,
    required this.recuperacionFinalUdis,
    required this.recuperacionFinalMxn,
    required this.sumaAsegurada,
    required this.sumaAseguradaMxn,
    required this.totalRetirar,
    required this.totalRetirarMxn,
    required this.totalRetirar2065,
    required this.totalRetirar2065Mxn,
  });


  @override
  Widget build(BuildContext context) {
  final currencyFormat = NumberFormat.currency(locale: 'es_MX', symbol: 'MXN \$');
  final numberFormat = NumberFormat('#,###', 'es_MX'); // Para UDIS
  final currentYear = DateTime.now().year;
  final retiroEnAnio = currentYear + duracion;


    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: CustomHomeAppBar(user: user), // ✅ pero antes tienes que agregarlo al constructor

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nombrePlan,
              style: const TextStyle(
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
              udis: '${numberFormat.format(sumaAsegurada)} UDIS',
              mxn: currencyFormat.format(sumaAseguradaMxn),
              icon: Icons.lock,
            ),
            const SizedBox(height: 16),
            DetailCard(
              title: 'Total a Retirar en $retiroEnAnio',
              udis: '${numberFormat.format(totalRetirar)} UDIS',
              mxn: currencyFormat.format(totalRetirarMxn),
              icon: Icons.lock,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final verificacion = user['verificacion'];
                  final perfilCompleto = user['perfil_completo'] == 1;

                  if (perfilCompleto) {
                    print("Perfil completo: $beneficiarios");
                    // TODO: Activar plan aquí
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BeneficiariesScreen(
                          user: user,
                          beneficiarios: beneficiarios,
                        ),
                      ),
                    );

                    // Aquí podrías hacer un POST al backend o navegar a una pantalla de confirmación
                  } else if (verificacion['completed'] == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VerificacionCompletadaScreen()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => VerificacionScreen(user: user)),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E5AFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // para que se ajuste al contenido
                  children: [
                    const Text(
                      'Activar mi plan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8), // espacio entre el texto y el ícono
                    const Icon(
                      Icons.arrow_forward,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PlanActionButton(icon: Icons.calculate, label: 'Cotización'),
                PlanActionButton(
                  icon: Icons.settings,
                  label: 'Ajustes',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PlanSettingsScreen()),
                    );
                  },
                ),                
                PlanActionButton(
                  icon: Icons.people,
                  label: 'Beneficiarios',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BeneficiariesScreen(
                          user: user,
                          beneficiarios: beneficiarios,                        
                      )),
                    );
                  },
                ),                 
                PlanActionButton(icon: Icons.description, label: 'Legal'),
              ],
            ),
            const SizedBox(height: 24),
            DetailCard(
              title: 'Retira en año 2065',
              udis: '${numberFormat.format(totalRetirar2065)} UDIS',
              mxn: currencyFormat.format(totalRetirar2065Mxn),
              icon: Icons.lock,
            ),
            const SizedBox(height: 24),
            const UdiCard(),
            const SizedBox(height: 24),
            const PlanContributionsTable(),           
          ],
        ),
      ),
    );
  }
}
