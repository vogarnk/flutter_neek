import 'package:flutter/material.dart';

class PlanContributionsTable extends StatefulWidget {
  const PlanContributionsTable({super.key});

  @override
  State<PlanContributionsTable> createState() => _PlanContributionsTableState();
}

class _PlanContributionsTableState extends State<PlanContributionsTable> {
  bool isUdiSelected = true; // Estado del switch

  @override
  Widget build(BuildContext context) {
    final contributions = List.generate(10, (index) {
      final year = 2023 + index;
      return {
        'index': index + 1,
        'year': year,
        'amount': '2,238',
        'status': index == 0 ? 'Completado' : 'Pendiente',
      };
    });

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
          ...contributions.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item['index']}  ${item['year']}',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontSize: 14,
                          ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item['amount'] as String,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontSize: 14,
                          ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: item['status'] == 'Completado'
                            ? Colors.green.shade100
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item['status'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: item['status'] == 'Completado'
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
          }).toList(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Activar mi plan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B5FF3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}