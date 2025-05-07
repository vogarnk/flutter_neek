import 'package:flutter/material.dart';
import 'package:neek/shared/cards/ahorro_card.dart';
import 'package:neek/shared/cards/plan_card.dart';
import 'package:neek/shared/cards/udi_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:neek/shared/app_bars/custom_home_app_bar.dart'; // 👈 Importa el widget

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic> user;
  final List<String> planNames;

  const HomeScreen({
    Key? key,
    required this.user,
    required this.planNames,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController(viewportFraction: 1);
    final plans = List<Map<String, dynamic>>.from(user['user_plans'] ?? []);    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LOGO + ICONOS
              CustomHomeAppBar(user: user),

              const SizedBox(height: 20),

              Text(
                '${user['name']}!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Este es un resumen de tu cuenta',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 24),

              // TARJETA DE AHORRO
              AhorroCard(plans: List<Map<String, dynamic>>.from(user['user_plans'] ?? [])),

              const SizedBox(height: 20),

              // TARJETA DE PLAN
              SizedBox(
                height: 320,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];

                    final beneficiarios = List<Map<String, dynamic>>.from(plan['beneficiarios'] ?? []);
                    final nombre = plan['nombre_plan'] ?? 'Plan sin nombre';
                    final udis = double.tryParse(plan['recuperacion_final_udis'].toString()) ?? 0;
                    final udisMxn = double.tryParse(plan['recuperacion_final_udis_mxn'].toString()) ?? 0;
                    final sumaAsegurada = (plan['suma_asegurada'] ?? 0).toDouble();
                    final sumaAseguradaMxn = (plan['suma_asegurada_mxn'] ?? 0).toDouble();
                    final totalRetirar = (plan['total_a_retirar'] ?? 0).toDouble();
                    final totalRetirarMxn = (plan['total_a_retirar_mxn'] ?? 0).toDouble();
                    final totalRetirar2065 = (plan['total_a_retirar_2065'] ?? 0).toDouble();
                    final totalRetirar2065Mxn = (plan['total_a_retirar_2065_mxn'] ?? 0).toDouble();
                    final duracion = (plan['duracion'] ?? 0).toInt();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: PlanCard(
                        user: user,
                        nombrePlan: nombre,
                        duracion: duracion,
                        recuperacionFinalUdis: udis,
                        recuperacionFinalMxn: udisMxn,
                        sumaAsegurada: sumaAsegurada,
                        sumaAseguradaMxn: sumaAseguradaMxn,
                        totalRetirar: totalRetirar,
                        totalRetirarMxn: totalRetirarMxn,
                        totalRetirar2065: totalRetirar2065,
                        totalRetirar2065Mxn: totalRetirar2065Mxn,
                        beneficiarios: beneficiarios, // ✅ agregado
                      ),
                    );
                  },
                ),
              ),



              const SizedBox(height: 12),

              // Indicador de página
              Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: plans.length,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 6,
                    activeDotColor: Color(0xFF3B5BFE),
                    dotColor: Color(0xFFCBD5E1), // Tailwind slate-300 aprox
                  ),
                ),
              ),


              const SizedBox(height: 20),

              // TARJETA UDI
              const UdiCard(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}