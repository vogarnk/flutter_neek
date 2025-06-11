import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ContributionsScreen extends StatelessWidget {
  const ContributionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contributions = [
      {
        'year': 2024,
        'aportacion': '2,238',
        'ahorro': '3,792',
        'status': 'Completado',
        'details': {
          'Referencia': 'DACCA1205MSHCL01',
          'Clave': '0500 MEXICO',
          'Aportación en pesos': '\$29,764',
          'Cargo procesado el': '1 DIC 2024',
          'Aportación en UDIS': '3,782',
          'Cargo autorizado el': '1 DIC 2024',
          'Número de referencia': 'NKPLZ120124',
        },
      },
      {
        'year': 2025,
        'aportacion': '2,238',
        'ahorro': '3,792',
        'status': 'Completado',
        'details': {
          'Referencia': 'DACCA1205MSHCL02',
          'Clave': '0500 MEXICO',
          'Aportación en pesos': '\$31,111',
          'Cargo procesado el': '1 DIC 2025',
          'Aportación en UDIS': '3,792',
          'Cargo autorizado el': '1 DIC 2025',
          'Número de referencia': 'NKPLZ120125',
        },
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textWhite),
        title: const Text(
          'Aportaciones',
          style: TextStyle(color: AppColors.textWhite),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderCard(),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: AppColors.background50,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tabla de aportaciones',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textGray900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Periodicidad Anual', style: TextStyle(color: AppColors.textGray400)),
                      Row(
                        children: [
                          Text('UDI', style: TextStyle(color: AppColors.textGray400)),
                          Switch(value: true, onChanged: null),
                          Text('MXN', style: TextStyle(color: AppColors.textGray400)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  const _TableHeader(),
                  const SizedBox(height: 8),
                  ...contributions.map((data) => ContributionTile(data: data)).toList(),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Realizar siguiente aportación'),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                    ),
                  ),                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContributionTile extends StatelessWidget {
  final Map<String, dynamic> data;

  const ContributionTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${data['year']}', style: const TextStyle(color: AppColors.textGray900)),
          Text('${data['aportacion']}', style: const TextStyle(color: AppColors.textGray900)),
          Text('${data['ahorro']}', style: const TextStyle(color: AppColors.textGray900)),
          const Chip(
            label: Text('Completado'),
            backgroundColor: Color(0xFFD1FAE5),
            labelStyle: TextStyle(color: Color(0xFF047857)),
          ),
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
              Text(
                'NEEK PAGO POLIZA ${data['year']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textGray900,
                ),
              ),
              const SizedBox(height: 8),
              const Chip(
                label: Text('Completado'),
                backgroundColor: Color(0xFFD1FAE5),
                labelStyle: TextStyle(color: Color(0xFF047857)),
              ),
              const SizedBox(height: 12),
              const Text('Detalles de tu aportación', style: TextStyle(color: AppColors.textGray500)),
              Text('REF: ${data['details']['Referencia']}', style: const TextStyle(color: AppColors.textGray900)),
              const SizedBox(height: 16),
              ...data['details'].entries
                  .skip(1) // saltamos 'Referencia' ya mostrada arriba
                  .map((entry) => _DetailRow(label: entry.key.toUpperCase(), value: entry.value))
                  .toList(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {}, // Acción de descarga
                  icon: const Icon(Icons.file_download_outlined, color: AppColors.primary),
                  label: const Text('Descargar factura'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    alignment: Alignment.center,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text('AÑO', style: TextStyle(color: AppColors.textGray500)),
        Text('APORTACIÓN', style: TextStyle(color: AppColors.textGray500)),
        Text('AHORRO', style: TextStyle(color: AppColors.textGray500)),
        Text('STATUS', style: TextStyle(color: AppColors.textGray500)),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textGray500)),
          Text(value, style: const TextStyle(color: AppColors.textGray900)),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background50,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.check_box, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Aportaciones',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.textGray900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Encuentra aquí el estado de tus aportaciones dentro de la tabla de valores garantizados',
            style: TextStyle(color: AppColors.textGray400),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Realizar siguiente aportación'),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}