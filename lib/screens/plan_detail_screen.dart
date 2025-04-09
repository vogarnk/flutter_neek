// PASO 1: Crea una pantalla de detalles del plan (PlanDetailScreen)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final montoFinal = NumberFormat('#,###', 'en_US').format(udis);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Detalles del Plan'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nombrePlan,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 26)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Monto final en UDIS:',
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Text('$montoFinal UDIS',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22)),
                  const SizedBox(height: 20),
                  const Text('Información adicional del plan...'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
