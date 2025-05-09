import 'package:flutter/material.dart';
import '../../shared/cards/card_neek.dart';
import 'plan_summary_card.dart';

class PlanSettingsScreen extends StatelessWidget {
  const PlanSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111928),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Ajustes del Plan', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardNeek(nombrePlan: 'Mi plan', mostrarBoton: true),
            const SizedBox(height: 24),



            const SizedBox(height: 16),
            PlanSummaryCard(
              plazo: 5,
              ahorroAnual: 20000,
              primaAnual: 62093,
              sumaAsegurada: 280000,
              totalRetirarCorto: 32093,
              totalRetirarLargo: 32093,
              anioCorto: 2029,
              anioLargo: 2050,
              beneficiarios: 3,
            ),
          ],
        ),
      ),
    );
  }
}