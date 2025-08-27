import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neek/modules/plans/contributions/next_contribution_screen.dart';

class PlanMovementsTable extends StatefulWidget {
  final List<dynamic> movimientos;
  final String status;
  final Map<String, dynamic>? user;
  final Map<String, dynamic>? currentPlan;
  final List<dynamic>? cotizaciones;

  const PlanMovementsTable({
    super.key,
    required this.movimientos,
    required this.status,
    this.user,
    this.currentPlan,
    this.cotizaciones,
  });

  @override
  State<PlanMovementsTable> createState() => _PlanMovementsTableState();
}

class _PlanMovementsTableState extends State<PlanMovementsTable> {
  bool isUdiSelected = true; // Estado del switch

  @override
  Widget build(BuildContext context) {
    final movements = widget.movimientos;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👈 Textos contenidos con Expanded
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Movimientos Reales',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.displaySmall?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Historial de tus aportaciones realizadas',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // 👈 Switch funcional
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'UDI',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Switch(
                    value: isUdiSelected,
                    onChanged: (val) {
                      setState(() {
                        isUdiSelected = val;
                      });
                    },
                    activeColor: Colors.white,     // Thumb cuando está ON
                    activeTrackColor: Theme.of(context).primaryColor, // Línea cuando está ON
                  ),
                  Text(
                    'MXN',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'FECHA',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'APORTACIÓN',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'STATUS',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (movements.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'No hay movimientos registrados aún',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            )
          else
            ...movements.map((movement) {
              final fecha = movement['fecha'] ?? '';
              final montoUdi = double.tryParse(movement['monto_udi']?.toString() ?? '0') ?? 0;
              final montoMxn = double.tryParse(movement['monto_mxn']?.toString() ?? '0') ?? 0;
              final status = movement['status'] ?? 'Pendiente';

              final monto = isUdiSelected
                  ? NumberFormat('#,###.00', 'es_MX').format(montoUdi)
                  : NumberFormat('#,###.00', 'es_MX').format(montoMxn);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        fecha,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontSize: 14,
                            ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        isUdiSelected ? '$monto UDIS' : '\$$monto',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontSize: 14,
                            ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: status == 'Completado'
                              ? Colors.green.shade100
                              : status == 'Procesando'
                                  ? Colors.orange.shade100
                                  : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: status == 'Completado'
                                ? Colors.green
                                : status == 'Procesando'
                                    ? Colors.orange
                                    : Colors.black45,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          const SizedBox(height: 24),
          _buildPlanActionButton(),
        ],
      ),
    );
  }

  Widget _buildPlanActionButton() {
    late String label;

    switch (widget.status) {
      case 'autorizado_por_pagar_1':
        label = 'Pagar primera aportación';
        break;
      case 'autorizado':
        label = 'Realizar siguiente aportación';
        break;
      default:
        label = 'Acción no disponible';
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NextContributionScreen(
                user: widget.user ?? {},
                userPlan: widget.currentPlan ?? {},
                cotizaciones: widget.cotizaciones ?? [],
                userPlanId: widget.currentPlan?['id'] ?? 1,
              ),
            ),
          );
        },
        icon: const Icon(Icons.arrow_forward),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2B5FF3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
} 