import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neek/screens/help_center_screen.dart';
import 'package:neek/widgets/cards/ahorro_card.dart';
import 'package:neek/widgets/cards/plan_card.dart';
import 'package:neek/widgets/cards/udi_card.dart';
import 'package:neek/screens/account_screen.dart'; // 👈 importa tu pantalla
import 'package:neek/screens/notifications_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    'assets/logo.svg',
                    height: 25,
                    fit: BoxFit.contain,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HelpCenterScreen(),
                            ),
                          );
                        },
                        child: const Icon(Icons.headphones, color: Colors.white70),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificationsScreen(),
                            ),
                          );
                        },
                        child: const Icon(Icons.notifications_none, color: Colors.white70),
                      ),                      
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AccountScreen(),
                            ),
                          );
                        },
                        child: const Icon(Icons.person_outline, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
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
                    final nombre = plan['nombre_plan'] ?? 'Plan sin nombre';
                    final udis = double.tryParse(plan['recuperacion_final_udis'].toString()) ?? 0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: PlanCard(
                        nombrePlan: nombre,
                        recuperacionFinalUdis: udis,
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