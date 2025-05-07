import 'package:flutter/material.dart';
import '../../shared/cards/card_neek.dart';
import '../../shared/cards/plan_summary_card.dart';

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
            const CardNeek(nombrePlan: 'Familia Monarrez'),
            const SizedBox(height: 24),

            GestureDetector(
              onTap: () {
                // Aquí podrías navegar a una pantalla de edición
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Cambiar nombre del plan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.edit, size: 18),
                  ],
                ),
              ),
            ),

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