import 'package:flutter/material.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/shared/cards/card_neek.dart';

class NextContributionScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final Map<String, dynamic> userPlan;
  final List<dynamic> cotizaciones;

  const NextContributionScreen({
    super.key,
    required this.user,
    required this.userPlan,
    required this.cotizaciones,
  });

  @override
  State<NextContributionScreen> createState() => _NextContributionScreenState();
}

class _NextContributionScreenState extends State<NextContributionScreen> {
  bool isChecked = true;
  
  // Valores calculados
  String _numeroPoliza = '';
  String _nombreCompleto = '';
  String _recibo = '';
  String _moneda = 'UDI';
  String _importe = '';
  String _tc = '';
  String _importeTotal = '';

  @override
  void initState() {
    super.initState();
    // Calcular valores inmediatamente
    _calculateValues();
  }

  void _calculateValues() {
    // Establecer valores por defecto inmediatamente
    setState(() {
      _numeroPoliza = 'Cargando...';
      _nombreCompleto = 'Cargando...';
      _recibo = 'Cargando...';
      _moneda = 'UDI';
      _importe = 'Cargando...';
      _tc = 'Cargando...';
      _importeTotal = 'Cargando...';
    });
    
    // Validar que los datos requeridos estén disponibles
    if (widget.userPlan.isEmpty || widget.cotizaciones.isEmpty) {
      return;
    }
    
    // Número de póliza
    _numeroPoliza = widget.userPlan['numero_poliza']?.toString() ?? 'N/A';
    
    // Nombre completo del usuario
    final name = widget.user['name'] ?? '';
    final sName = widget.user['sName'] ?? '';
    final lName = widget.user['lName'] ?? '';
    final lName2 = widget.user['lName2'] ?? '';
    
    _nombreCompleto = [name, sName, lName, lName2]
        .where((part) => part != null && part.toString().isNotEmpty)
        .join(' ');
    
    // Recibo: duración * periodicidad
    final duracion = widget.userPlan['duracion'] ?? 0;
    final periodicidad = widget.userPlan['periodicidad'] ?? '';
    _recibo = '1 / ${duracion * _getPeriodicidadMultiplier(periodicidad)}';
    
    // Moneda (siempre UDI)
    _moneda = 'UDI';
    
    // Importe: primer valor de aportacion_anual_udis
    if (widget.cotizaciones.isNotEmpty) {
      final primeraCotizacion = widget.cotizaciones.first;
      final aportacionAnualUdis = primeraCotizacion['aportacion_anual_udis'];
      
      if (aportacionAnualUdis != null) {
        // Convertir a double si es String, o usar directamente si es num
        double importeNum;
        if (aportacionAnualUdis is String) {
          importeNum = double.tryParse(aportacionAnualUdis) ?? 0.0;
        } else if (aportacionAnualUdis is num) {
          importeNum = aportacionAnualUdis.toDouble();
        } else {
          importeNum = 0.0;
        }
        _importe = _formatCurrency(importeNum);
      }
    }
    
    // TC: valor de udis del plan
    final udis = widget.userPlan['udis'];
    if (udis != null) {
      _tc = udis.toString();
    }
    
    // Importe total: Importe * TC
    if (_importe.isNotEmpty && _tc.isNotEmpty && _importe != 'Cargando...' && _tc != 'Cargando...') {
      try {
        // Remover comas del importe y convertir a double
        final importeStr = _importe.replaceAll(',', '');
        final importeNum = double.tryParse(importeStr) ?? 0.0;
        
        // Convertir TC a double
        double tcNum;
        if (_tc is String) {
          tcNum = double.tryParse(_tc) ?? 0.0;
        } else {
          tcNum = 0.0;
        }
        
        final total = importeNum * tcNum;
        _importeTotal = _formatCurrency(total);
      } catch (e) {
        _importeTotal = 'Error en cálculo';
      }
    }
    
    // Actualizar la UI con todos los valores calculados
    setState(() {});
  }

  int _getPeriodicidadMultiplier(String periodicidad) {
    switch (periodicidad.toLowerCase()) {
      case 'mensual':
        return 12;
      case 'trimestral':
        return 4;
      case 'semestral':
        return 2;
      case 'anual':
        return 1;
      default:
        return 1;
    }
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Realizar siguiente aportación'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/seguros_atlas.png', height: 40),
                const SizedBox(width: 12),
                Image.asset('assets/images/logo_neek.png', height: 40),
              ],
            ),

            const SizedBox(height: 16),

            // Tarjeta
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardNeek(
                    nombrePlan: widget.userPlan['nombre_plan'] ?? 'Mi plan', 
                    mostrarBoton: false
                  ),
                  // Badge de estado
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: widget.userPlan['status'] == 'autorizado_por_pagar_1'
                          ? AppColors.primary100 // Azul claro
                          : const Color(0xFFD1FAE5), // Verde claro
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.userPlan['status'] == 'autorizado_por_pagar_1'
                              ? Icons.schedule // Reloj para "Listo para activar"
                              : Icons.check_circle, // Check para "Activo"
                          color: widget.userPlan['status'] == 'autorizado_por_pagar_1'
                              ? Theme.of(context).colorScheme.primary // Color primary del tema
                              : const Color(0xFF047857), // Verde
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.userPlan['status'] == 'autorizado_por_pagar_1'
                              ? 'Listo para activar'
                              : 'Activo',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: widget.userPlan['status'] == 'autorizado_por_pagar_1'
                                ? Theme.of(context).colorScheme.primary // Color primary del tema
                                : const Color(0xFF047857), // Verde
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),                  
                  const SizedBox(height: 16),
                  infoRow('PÓLIZA', _numeroPoliza),
                  infoRow('CONTRATANTE', _nombreCompleto),
                  infoRow('RECIBO', _recibo),
                  infoRow('MONEDA', _moneda),
                  infoRow('IMPORTE', _importe),
                  infoRow('TC', _tc),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Checkbox y mensaje
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
                                  child: Column(
                      children: [
                        // Icono de tarjeta de crédito en azul
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.credit_card,
                            color: Color(0xFF1976D2),
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Título en negro
                        const Text(
                          '¿Listo para hacer tu pago?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        
                        // Instrucciones en gris
                        const Text(
                          'Te enviaremos un correo con las instrucciones detalladas y los diferentes medios de pago disponibles (tarjeta de crédito o débito a través de pago en línea, depósito directo o vía telefónica).',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textGray500,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        
                        // Instrucciones de comprobante en gris
                        const Text(
                          'Una vez recibido podrás realizar tu pago y posteriormente, enviar tu comprobante a tu agente neek o al correo reportedepagos@neek.mx',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textGray500,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        
                        Row(
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                setState(() => isChecked = value!);
                              },
                            ),
                            const Expanded(
                              child: Text(
                                'He leído la información que se me ha proporcionado acerca de mi plan de ahorro en este módulo.',
                                style: TextStyle(fontSize: 13, color: AppColors.textGray900),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 12),
                  Text(
                    'Importe Total: \$ $_importeTotal',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textGray900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isChecked
                          ? () {
                              debugPrint('✅ Enviar instrucciones de pago');
                            }
                          : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Enviar instrucciones de pago'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.textGray300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: AppColors.textGray900, fontWeight: FontWeight.w600)),
          Text(value,
              style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}