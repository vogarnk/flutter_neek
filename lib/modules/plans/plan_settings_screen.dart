import 'package:flutter/material.dart';
import '../../shared/cards/card_neek.dart';
import 'plan_summary_card.dart';

class PlanSettingsScreen extends StatelessWidget {
  final Map<String, dynamic>? userPlan;
  const PlanSettingsScreen({
    super.key,
    this.userPlan,
  });

  @override
  Widget build(BuildContext context) {
    final nombrePlan = userPlan?['nombre_plan'] ?? 'Mi plan';
    final duracion = userPlan?['duracion'] ?? 0;
    final periodicidad = userPlan?['periodicidad'] ?? '';
    final numeroPoliza = userPlan?['numero_poliza'] ?? '';
    final udis = userPlan?['udis'] ?? 0.0;
    final status = userPlan?['status'] ?? '';

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
            CardNeek(nombrePlan: nombrePlan, mostrarBoton: true),
            const SizedBox(height: 24),
            const SizedBox(height: 16),
            PlanSummaryCard(
              plazo: duracion,
              ahorroAnual: (udis * 0.1).toDouble(), // 10% de las UDIS como ahorro anual
              primaAnual: (udis * 0.15).toDouble(), // 15% de las UDIS como prima anual
              sumaAsegurada: (udis * 2.0).toDouble(), // 200% de las UDIS como suma asegurada
              totalRetirarCorto: (udis * 0.8).toDouble(), // 80% de las UDIS para retiro corto
              totalRetirarLargo: (udis * 1.5).toDouble(), // 150% de las UDIS para retiro largo
              anioCorto: DateTime.now().year + 4, // 4 años desde ahora
              anioLargo: DateTime.now().year + 25, // 25 años desde ahora
              beneficiarios: userPlan?['beneficiarios']?.length ?? 0, // Número real de beneficiarios
            ),
          ],
        ),
      ),
    );
  }

}