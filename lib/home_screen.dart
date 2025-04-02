import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neek/widgets/charts/animated_multi_ring_chart.dart';
import 'package:neek/widgets/cards/ahorro_card.dart';
import 'package:neek/widgets/cards/plan_card.dart';
import 'package:neek/widgets/cards/udi_card.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
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
                    children: const [
                      Icon(Icons.headphones, color: Colors.white70),
                      SizedBox(width: 16),
                      Icon(Icons.notifications_none, color: Colors.white70),
                      SizedBox(width: 16),
                      Icon(Icons.person_outline, color: Colors.white70),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text(
                'neek ${user['name']}!',
                style: const TextStyle(
                  fontSize: 28,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                  ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Este es un resumen de tu cuenta',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 24),

              // TARJETA DE AHORRO
              AhorroCard(planNames: planNames),

              const SizedBox(height: 20),

              // TARJETA DE PLAN
              const PlanCard(),
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