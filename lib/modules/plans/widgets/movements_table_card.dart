import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MovementsTableCard extends StatelessWidget {
  const MovementsTableCard({super.key});

  @override
  Widget build(BuildContext context) {
    final movements = [
      {
        'concepto': 'Ahorro',
        'fecha': '25-01',
        'monto': '3,792',
        'status': 'Procesando',
        'details': {
          'Referencia': 'DACCA1205MSHCL01',
          'Clave': '0500 MEXICO',
          'Aportación en pesos': '\$29,764',
          'Cargo procesado el': '1 DIC 2023',
          'Aportación en UDIS': '3,782',
          'Cargo autorizado el': '1 DIC 2023',
          'Número de referencia': 'NKPLZ120123',
        },
      },
      {
        'concepto': 'Aportación',
        'fecha': '25-01',
        'monto': '3,792',
        'status': 'Completado',
        'details': {
          'Referencia': 'DACCA1205MSHCL01',
          'Clave': '0500 MEXICO',
          'Aportación en pesos': '\$29,764',
          'Cargo procesado el': '1 DIC 2023',
          'Aportación en UDIS': '3,782',
          'Cargo autorizado el': '1 DIC 2023',
          'Número de referencia': 'NKPLZ120123',
        },
      }
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Todos mis movimientos',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textGray900)),
          const SizedBox(height: 4),
          const Text('Tus movimientos del último periodo se encuentran aquí',
              style: TextStyle(color: AppColors.textGray400)),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar movimientos',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: AppColors.background50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Icon(Icons.keyboard_arrow_down),
              Text('2025', style: TextStyle(color: AppColors.textGray900)),
              Spacer(),
              Text('UDI', style: TextStyle(color: AppColors.textGray400)),
              Switch(value: true, onChanged: null),
              Text('MXN', style: TextStyle(color: AppColors.textGray400)),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('CONCEPTO', style: TextStyle(color: AppColors.textGray500)),
              Text('FECHA', style: TextStyle(color: AppColors.textGray500)),
              Text('IMPORTE', style: TextStyle(color: AppColors.textGray500)),
              Text('STATUS', style: TextStyle(color: AppColors.textGray500)),
            ],
          ),
          const SizedBox(height: 12),
          ...movements.map((m) => _MovementTile(data: m)).toList(),
        ],
      ),
    );
  }
}

class _MovementTile extends StatelessWidget {
  final Map<String, dynamic> data;

  const _MovementTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(data['concepto'], style: const TextStyle(color: AppColors.textGray900)),
          Text(data['fecha'], style: const TextStyle(color: AppColors.textGray900)),
          Text(data['monto'], style: const TextStyle(color: AppColors.textGray900)),
          _buildStatusChip(data['status']),
        ],
      ),
      children: [
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'APORTACIÓN NEEK POLIZA ENERO',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textGray900),
              ),
              const SizedBox(height: 8),
              _buildStatusChip(data['status']),
              const SizedBox(height: 12),
              const Text('Detalles de tu aportación', style: TextStyle(color: AppColors.textGray500)),
              Text('REF: ${data['details']['Referencia']}', style: const TextStyle(color: AppColors.textGray900)),
              const SizedBox(height: 16),
              ...data['details'].entries.skip(1).map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.key.toUpperCase(), style: const TextStyle(color: AppColors.textGray500)),
                      Text(e.value, style: const TextStyle(color: AppColors.textGray900)),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.file_download_outlined, color: AppColors.primary),
                  label: const Text('Descargar factura'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  '¿Tienes una duda acerca de este cargo?',
                  style: TextStyle(color: AppColors.textGray400, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    final isComplete = status == 'Completado';
    final color = isComplete ? const Color(0xFFD1FAE5) : const Color(0xFFDBEAFE);
    final textColor = isComplete ? const Color(0xFF047857) : const Color(0xFF1D4ED8);
    return Chip(
      label: Text(status, style: TextStyle(color: textColor)),
      backgroundColor: color,
    );
  }
}