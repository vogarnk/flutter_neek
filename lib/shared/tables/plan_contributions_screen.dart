import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neek/modules/plans/contributions/next_contribution_screen.dart';
class PlanContributionsTable extends StatefulWidget {
  final List<dynamic> cotizaciones;
  final String status;

  const PlanContributionsTable({
    super.key,
    required this.cotizaciones,
    required this.status,
  });

  @override
  State<PlanContributionsTable> createState() => _PlanContributionsTableState();
}

class _PlanContributionsTableState extends State<PlanContributionsTable> {
  bool isUdiSelected = true; // Estado del switch
  final Set<int> indicesPagados = {1,2,3};

  @override
  Widget build(BuildContext context) {
    final contributions = widget.cotizaciones;
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
                      'Plan de Ahorro',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.displaySmall?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Revisa y planea tus aportaciones',
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
                    activeTrackColor: Theme.of(context).primaryColor, // Línea cuando está ON          // Línea cuando está OFF
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
                    'AÑO',
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
          ...contributions
              .takeWhile((item) =>
                  double.tryParse(item['aportacion_anual_udis'] ?? '0') != 0)
              .toList()
              .asMap()
              .entries
              .map((entry) {
            final index = entry.key + 1;
            final item = entry.value;

            final year = item['year'];
            final udis = double.tryParse(item['udis'] ?? '0') ?? 0;
            final aportacionUdis = double.tryParse(item['aportacion_anual_udis'] ?? '0') ?? 0;

            final aportacion = isUdiSelected
                ? '\$${NumberFormat('#,###.00', 'es_MX').format(aportacionUdis * udis)}'
                : NumberFormat('#,###', 'es_MX').format(aportacionUdis);

            final status = indicesPagados.contains(index) ? 'Completado' : 'Pendiente';

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '$index  $year',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontSize: 14,
                          ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      aportacion,
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
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: status == 'Completado'
                              ? Colors.green
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
          }),
          const SizedBox(height: 24),
          _buildPlanActionButton(),
        ],
      ),
    );
  }

  Widget _buildPlanActionButton() {
    late String label;

    switch (widget.status) {
      case 'cotizado':
        label = 'Activar mi plan';
        break;
      case 'autorizado_por_pagar_1':
        label = 'Pagar primera aportación';
        break;
      case 'autorizado':
        label = 'Pagar primera aportación';
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
                            builder: (context) => const NextContributionScreen(),
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