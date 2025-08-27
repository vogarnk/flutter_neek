import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/movimientos_service.dart';

class ContributionsScreen extends StatefulWidget {
  final int userPlanId;
  
  const ContributionsScreen({super.key, required this.userPlanId});

  @override
  State<ContributionsScreen> createState() => _ContributionsScreenState();
}

class _ContributionsScreenState extends State<ContributionsScreen> {
  List<dynamic>? movimientos;
  bool isLoading = true;
  bool isUdiSelected = true;

  @override
  void initState() {
    super.initState();
    _loadMovimientos();
  }

  Future<void> _loadMovimientos() async {
    try {
      final result = await MovimientosService.obtenerMovimientos(widget.userPlanId);
      setState(() {
        movimientos = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<dynamic> get _paidMovements {
    if (movimientos == null) return [];
    
    // Filtrar solo movimientos pagados (con factura) y ordenar cronológicamente
    final paidMovements = movimientos!
        .where((movement) => movement['factura'] != null)
        .toList();
    
    paidMovements.sort((a, b) {
      final fechaA = DateTime.tryParse(a['periodo'] ?? '') ?? DateTime(1900);
      final fechaB = DateTime.tryParse(b['periodo'] ?? '') ?? DateTime(1900);
      return fechaA.compareTo(fechaB);
    });
    
    return paidMovements;
  }

    @override
  Widget build(BuildContext context) {
    final contributions = _paidMovements;
    
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                          children: [
                            const Text('Periodicidad Anual', style: TextStyle(color: AppColors.textGray400)),
                            Row(
                              children: [
                                const Text('UDI', style: TextStyle(color: AppColors.textGray400)),
                                Switch(
                                  value: !isUdiSelected,
                                  onChanged: (val) {
                                    setState(() {
                                      isUdiSelected = !val;
                                    });
                                  },
                                  activeColor: AppColors.primary,
                                ),
                                const Text('MXN', style: TextStyle(color: AppColors.textGray400)),
                              ],
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        const _TableHeader(),
                        const SizedBox(height: 8),
                        if (contributions.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Text(
                                'No hay aportaciones pagadas aún',
                                style: TextStyle(
                                  color: AppColors.textGray400,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        else
                          ...contributions.map((movement) => ContributionTile(
                            movement: movement,
                            isUdiSelected: isUdiSelected,
                          )).toList(),        
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
  final Map<String, dynamic> movement;
  final bool isUdiSelected;

  const ContributionTile({super.key, required this.movement, required this.isUdiSelected});

  @override
  Widget build(BuildContext context) {
    final fecha = movement['periodo'] ?? '';
    final valorUdi = double.tryParse(movement['valor_udis']?.toString() ?? '0') ?? 0;
    final valorPesos = double.tryParse(movement['valor_pesos']?.toString() ?? '0') ?? 0;
    final concepto = movement['concepto'] ?? '';
    final referencia = movement['referencia'] ?? '';
    final clave = movement['clave'] ?? '';
    final procesadoAt = movement['procesado_at'] ?? '';
    final autorizadoAt = movement['autorizado_at'] ?? '';
    final factura = movement['factura'];

    final monto = isUdiSelected
        ? NumberFormat('#,###.00', 'es_MX').format(valorUdi)
        : NumberFormat('#,###.00', 'es_MX').format(valorPesos);

    final year = DateTime.tryParse(fecha)?.year ?? 0;

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$year', style: const TextStyle(color: AppColors.textGray900)),
          Text(isUdiSelected ? '$monto' : '\$$monto', style: const TextStyle(color: AppColors.textGray900)),
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
                concepto,
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
              Text('REF: $referencia', style: const TextStyle(color: AppColors.textGray900)),
              const SizedBox(height: 16),
              _DetailRow(label: 'CLAVE', value: clave),
              _DetailRow(
                label: 'APORTACIÓN EN PESOS', 
                value: NumberFormat.currency(locale: 'es_MX', symbol: 'MXN \$').format(valorPesos)
              ),
              _DetailRow(
                label: 'CARGO PROCESADO EL', 
                value: _formatDate(procesadoAt)
              ),
              _DetailRow(
                label: 'APORTACIÓN EN UDIS', 
                value: NumberFormat('#,###.00', 'es_MX').format(valorUdi)
              ),
              _DetailRow(
                label: 'CARGO AUTORIZADO EL', 
                value: _formatDate(autorizadoAt)
              ),
              _DetailRow(
                label: 'NÚMERO DE REFERENCIA', 
                value: referencia
              ),
              const SizedBox(height: 20),
              if (factura != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implementar descarga de factura
                    },
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

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day} ${_getMonthName(date.month)} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN',
      'JUL', 'AGO', 'SEP', 'OCT', 'NOV', 'DIC'
    ];
    return months[month - 1];
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
        ],
      ),
    );
  }
}