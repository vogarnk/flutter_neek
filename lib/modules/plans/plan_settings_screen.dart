import 'package:flutter/material.dart';
import '../../shared/cards/card_neek.dart';
import 'plan_summary_card.dart';

class PlanSettingsScreen extends StatelessWidget {
  final Map<String, dynamic>? userPlan;
  final List<dynamic>? cotizaciones;
  final double? udisActual;
  final int? edadUsuario;
  
  const PlanSettingsScreen({
    super.key,
    this.userPlan,
    this.cotizaciones,
    this.udisActual,
    this.edadUsuario,
  });

  @override
  Widget build(BuildContext context) {
    // Log para ver qué contiene userPlan
    print('🔍 PlanSettingsScreen: userPlan = $userPlan');
    print('🔍 PlanSettingsScreen: userPlan keys = ${userPlan?.keys.toList()}');
    final nombrePlan = userPlan?['nombre_plan'] ?? 'Mi plan';
    final duracion = userPlan?['duracion'] ?? 0;
    final periodicidad = userPlan?['periodicidad'] ?? '';
    final numeroPoliza = userPlan?['numero_poliza'] ?? '';
    final udis = userPlan?['udis'] ?? 0.0;
    final status = userPlan?['status'] ?? '';
    final userPlanId = userPlan?['id']; // 👈 Extraer el ID del plan
    
    // Log de valores extraídos
    print('🔍 PlanSettingsScreen: nombrePlan = $nombrePlan');
    print('🔍 PlanSettingsScreen: duracion = $duracion');
    print('🔍 PlanSettingsScreen: periodicidad = $periodicidad');
    print('🔍 PlanSettingsScreen: numeroPoliza = $numeroPoliza');
    print('🔍 PlanSettingsScreen: udis = $udis');
    print('🔍 PlanSettingsScreen: status = $status');
    print('🔍 PlanSettingsScreen: userPlanId = $userPlanId'); // 👈 Log del ID
    print('🔍 PlanSettingsScreen: beneficiarios = ${userPlan?['beneficiarios']}');
    print('🔍 PlanSettingsScreen: cotizaciones = $cotizaciones');
    print('🔍 PlanSettingsScreen: cotizaciones length = ${cotizaciones?.length}');
    print('🔍 PlanSettingsScreen: udisActual = $udisActual');
    print('🔍 PlanSettingsScreen: edadUsuario = $edadUsuario');

    // Calcular valores basados en cotizaciones
    final ahorroAnual = _calculateAhorroAnual();
    final primaAnual = _calculatePrimaAnual();
    final sumaAsegurada = _calculateSumaAsegurada();
    final totalRetirarCorto = _calculateTotalRetirarCorto();
    final totalRetirarLargo = _calculateTotalRetirarLargo();
    final anioCorto = _calculateAnioCorto();
    final anioLargo = _calculateAnioLargo();

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
            CardNeek(
              nombrePlan: nombrePlan, 
              userPlanId: userPlanId,
              mostrarBoton: true,
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 16),
            PlanSummaryCard(
              plazo: duracion,
              ahorroAnual: ahorroAnual,
              primaAnual: primaAnual,
              sumaAsegurada: sumaAsegurada,
              totalRetirarCorto: totalRetirarCorto,
              totalRetirarLargo: totalRetirarLargo,
              anioCorto: anioCorto,
              anioLargo: anioLargo,
              beneficiarios: userPlan?['beneficiarios']?.length ?? 0, // Número real de beneficiarios
            ),
          ],
        ),
      ),
    );
  }

  // Función para calcular ahorro anual: aportacion_anual_udis * udis actual
  double _calculateAhorroAnual() {
    final udisPlan = userPlan?['udis'] ?? 0.0;
    if (cotizaciones == null || cotizaciones!.isEmpty || udisActual == null) {
      return (udisPlan * 0.1); // Fallback
    }
    
    final primeraCotizacion = cotizaciones!.first;
    final aportacionAnualUdis = primeraCotizacion['aportacion_anual_udis'];
    
    if (aportacionAnualUdis != null) {
      double aportacion;
      if (aportacionAnualUdis is String) {
        aportacion = double.tryParse(aportacionAnualUdis) ?? 0.0;
      } else if (aportacionAnualUdis is num) {
        aportacion = aportacionAnualUdis.toDouble();
      } else {
        aportacion = 0.0;
      }
      return aportacion * udisActual!;
    }
    
    return (udisPlan * 0.1); // Fallback
  }

  // Función para calcular prima anual: aportacion_anual_udis
  double _calculatePrimaAnual() {
    final udisPlan = userPlan?['udis'] ?? 0.0;
    if (cotizaciones == null || cotizaciones!.isEmpty) {
      return (udisPlan * 0.15); // Fallback
    }
    
    final primeraCotizacion = cotizaciones!.first;
    final aportacionAnualUdis = primeraCotizacion['aportacion_anual_udis'];
    
    if (aportacionAnualUdis != null) {
      if (aportacionAnualUdis is String) {
        return double.tryParse(aportacionAnualUdis) ?? 0.0;
      } else if (aportacionAnualUdis is num) {
        return aportacionAnualUdis.toDouble();
      }
    }
    
    return (udisPlan * 0.15); // Fallback
  }

  // Función para calcular suma asegurada: suma_asegurada_udis
  double _calculateSumaAsegurada() {
    final udisPlan = userPlan?['udis'] ?? 0.0;
    if (cotizaciones == null || cotizaciones!.isEmpty) {
      return (udisPlan * 2.0); // Fallback
    }
    
    final primeraCotizacion = cotizaciones!.first;
    final sumaAseguradaUdis = primeraCotizacion['suma_asegurada_udis'];
    
    if (sumaAseguradaUdis != null) {
      if (sumaAseguradaUdis is String) {
        return double.tryParse(sumaAseguradaUdis) ?? 0.0;
      } else if (sumaAseguradaUdis is num) {
        return sumaAseguradaUdis.toDouble();
      }
    }
    
    return (udisPlan * 2.0); // Fallback
  }

  // Función para calcular total retirar corto: recuperacion_udis del año objetivo (duración + año actual)
  double _calculateTotalRetirarCorto() {
    final udisPlan = userPlan?['udis'] ?? 0.0;
    if (cotizaciones == null || cotizaciones!.isEmpty) {
      return (udisPlan * 0.8); // Fallback
    }
    
    // Calcular el año objetivo: duración del plan + año actual
    final duracion = userPlan?['duracion'] ?? 0;
    final anioActual = DateTime.now().year;
    final anioObjetivo = anioActual + duracion;
    
    print('🔍 _calculateTotalRetirarCorto: duracion = $duracion');
    print('🔍 _calculateTotalRetirarCorto: anioActual = $anioActual');
    print('🔍 _calculateTotalRetirarCorto: anioObjetivo = $anioObjetivo');
    print('🔍 _calculateTotalRetirarCorto: cotizaciones length = ${cotizaciones!.length}');
    
    // Buscar la cotización que corresponda al año objetivo
    Map<String, dynamic>? cotizacionObjetivo;
    for (int i = 0; i < cotizaciones!.length; i++) {
      final cotizacion = cotizaciones![i];
      print('🔍 _calculateTotalRetirarCorto: cotizacion[$i] = $cotizacion');
      
      // Buscar por el campo 'year' si existe
      final year = cotizacion['year'];
      if (year != null) {
        int yearValue;
        if (year is String) {
          yearValue = int.tryParse(year) ?? 0;
        } else if (year is num) {
          yearValue = year.toInt();
        } else {
          yearValue = 0;
        }
        
        print('🔍 _calculateTotalRetirarCorto: year[$i] = $yearValue');
        
        if (yearValue == anioObjetivo) {
          cotizacionObjetivo = cotizacion;
          print('🔍 _calculateTotalRetirarCorto: ¡Encontrada cotización para año $anioObjetivo!');
          break;
        }
      }
    }
    
    // Si no se encontró por year, usar el índice basado en duración como fallback
    if (cotizacionObjetivo == null && duracion > 0 && duracion <= cotizaciones!.length) {
      cotizacionObjetivo = cotizaciones![duracion - 1];
      print('🔍 _calculateTotalRetirarCorto: Usando fallback por índice duracion-1 = ${duracion - 1}');
    }
    
    if (cotizacionObjetivo != null) {
      final recuperacionUdis = cotizacionObjetivo['recuperacion_udis'];
      final udisProyectado = cotizacionObjetivo['udis'];
      
      print('🔍 _calculateTotalRetirarCorto: recuperacionUdis = $recuperacionUdis');
      print('🔍 _calculateTotalRetirarCorto: udisProyectado = $udisProyectado');
      
      if (recuperacionUdis != null && udisProyectado != null) {
        double recuperacion;
        double udisValor;
        
        if (recuperacionUdis is String) {
          recuperacion = double.tryParse(recuperacionUdis) ?? 0.0;
        } else if (recuperacionUdis is num) {
          recuperacion = recuperacionUdis.toDouble();
        } else {
          recuperacion = 0.0;
        }
        
        if (udisProyectado is String) {
          udisValor = double.tryParse(udisProyectado) ?? 0.0;
        } else if (udisProyectado is num) {
          udisValor = udisProyectado.toDouble();
        } else {
          udisValor = 0.0;
        }
        
        // Multiplicar recuperacion_udis por el valor de UDIS proyectado para ese año
        final resultado = recuperacion * udisValor;
        print('🔍 _calculateTotalRetirarCorto: resultado = $recuperacion * $udisValor = $resultado');
        print('🔍 _calculateTotalRetirarCorto: NOTA: Usando UDIS proyectado del año $anioObjetivo, NO el valor actual');
        return resultado;
      }
    }
    
    print('🔍 _calculateTotalRetirarCorto: Usando fallback = ${udisPlan * 0.8}');
    return (udisPlan * 0.8); // Fallback
  }

  // Función para calcular total retirar largo: año que cumple 65 años * udis de ese índice
  double _calculateTotalRetirarLargo() {
    final udisPlan = userPlan?['udis'] ?? 0.0;
    if (cotizaciones == null || cotizaciones!.isEmpty || edadUsuario == null) {
      return (udisPlan * 1.5); // Fallback
    }
    
    final anioCumple65 = _calculateAnioLargo();
    final anioActual = DateTime.now().year;
    final aniosHasta65 = anioCumple65 - anioActual;
    
    if (aniosHasta65 > 0 && aniosHasta65 <= cotizaciones!.length) {
      final cotizacion = cotizaciones![aniosHasta65 - 1];
      final recuperacionUdis = cotizacion['recuperacion_udis'];
      final udisIndex = cotizacion['udis'];
      
      if (recuperacionUdis != null && udisIndex != null) {
        double recuperacion;
        double udisValor;
        
        if (recuperacionUdis is String) {
          recuperacion = double.tryParse(recuperacionUdis) ?? 0.0;
        } else if (recuperacionUdis is num) {
          recuperacion = recuperacionUdis.toDouble();
        } else {
          recuperacion = 0.0;
        }
        
        if (udisIndex is String) {
          udisValor = double.tryParse(udisIndex) ?? 0.0;
        } else if (udisIndex is num) {
          udisValor = udisIndex.toDouble();
        } else {
          udisValor = 0.0;
        }
        
        return recuperacion * udisValor;
      }
    }
    
    return (udisPlan * 1.5); // Fallback
  }

  // Función para calcular año corto: duración del plan
  int _calculateAnioCorto() {
    final duracion = userPlan?['duracion'] ?? 0;
    return DateTime.now().year + (duracion as int);
  }

  // Función para calcular año largo: año que cumple 65 años
  int _calculateAnioLargo() {
    if (edadUsuario == null) {
      return DateTime.now().year + 25; // Fallback
    }
    
    final aniosHasta65 = 65 - edadUsuario!;
    return DateTime.now().year + aniosHasta65;
  }

}