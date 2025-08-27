import 'package:flutter/material.dart';
import 'package:neek/shared/app_bars/custom_home_app_bar.dart';
import 'package:neek/shared/cards/detail_card.dart';
import 'package:intl/intl.dart';
import 'package:neek/shared/cards/udi_card.dart';
import 'package:neek/shared/tables/plan_contributions_screen.dart' show PlanContributionsTable;
import 'package:neek/shared/tables/plan_movements_table.dart' show PlanMovementsTable;
import '../verification/verificacion_completada_screen.dart';
import 'package:neek/modules/verification/verificacion_screen.dart';
import '../beneficiaries/beneficiaries_screen.dart';
import 'package:neek/shared/cards/autorizado/plan_authorized_card.dart';
import '../../shared/charts/suma_asegurada_chart_card.dart';
import 'package:neek/shared/buttons/plan_actions_row.dart';
import '../../core/theme/app_colors.dart';
import 'package:neek/core/cotizacion_service.dart';
import 'package:neek/core/movimientos_service.dart';
import 'package:neek/core/api_service.dart';
import 'dart:convert';
import 'contributions/next_contribution_screen.dart';

class PlanDetailScreen extends StatefulWidget {
  final String nombrePlan;
  final int duracion;
  final double recuperacionFinalUdis;
  final double recuperacionFinalMxn;
  final double sumaAsegurada;
  final double sumaAseguradaMxn;
  final double totalRetirar;
  final double totalRetirarMxn;
  final double totalRetirar2065;
  final double totalRetirar2065Mxn;
  final Map<String, dynamic> user;
  final List<dynamic> beneficiarios;
  final String status;
  final int userPlanId;
  final String? polizaUrl;

  const PlanDetailScreen({
    super.key,
    required this.user,
    required this.beneficiarios,
    required this.nombrePlan,
    required this.duracion,
    required this.recuperacionFinalUdis,
    required this.recuperacionFinalMxn,
    required this.sumaAsegurada,
    required this.sumaAseguradaMxn,
    required this.totalRetirar,
    required this.totalRetirarMxn,
    required this.totalRetirar2065,
    required this.totalRetirar2065Mxn,
    required this.status,
    required this.userPlanId,
    this.polizaUrl,
  });

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  List<dynamic>? cotizaciones;
  List<dynamic>? movimientos;
  Map<String, dynamic>? userPlanInfo;
  
  @override
  void initState() {
    super.initState();

    if (widget.status == 'autorizado_por_pagar_1') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showPlanAuthorizedDialog(context);
      });
    }

    // Obtener información del plan del usuario
    _loadUserPlanInfo();

    // Cargar datos según el estado del plan
    if (widget.status == 'cotizado') {
      CotizacionService.obtenerCotizaciones(widget.userPlanId).then((result) {
        setState(() {
          cotizaciones = result;
        });
      });
    } else if (widget.status == 'autorizado') {
      MovimientosService.obtenerMovimientos(widget.userPlanId).then((result) {
        setState(() {
          movimientos = result;
        });
      });
    } else if (widget.status == 'autorizado_por_pagar_1') {
      CotizacionService.obtenerCotizaciones(widget.userPlanId).then((result) {
        setState(() {
          cotizaciones = result;
        });
      });
    }
  }

  Future<void> _loadUserPlanInfo() async {
    try {
      // Obtener información del usuario para obtener los datos del plan
      final response = await ApiService.instance.get('/user');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data['data'];
        final userPlans = userData['user_plans'] as List?;
        
        if (userPlans != null) {
          // Buscar el plan que coincida con el userPlanId
          final currentPlan = userPlans.firstWhere(
            (plan) => plan['id'] == widget.userPlanId,
            orElse: () => {},
          );
          
          setState(() {
            userPlanInfo = currentPlan;
          });
        }
      }
    } catch (e) {
      debugPrint('Error al obtener información del plan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'es_MX', symbol: 'MXN \$');
    final numberFormat = NumberFormat('#,###', 'es_MX');
    final currentYear = DateTime.now().year;
    final retiroEnAnio = currentYear + widget.duracion;

    final isCotizado = widget.status == 'cotizado';
    final isAutorizadoPorPagar = widget.status == 'autorizado_por_pagar_1';
    final estadoTexto = isCotizado ? 'Por Activar' : (isAutorizadoPorPagar ? 'Pago Pendiente' : 'Autorizado');
    final estadoColor = isCotizado ? const Color(0xFFFFF3C7) : (isAutorizadoPorPagar ? const Color(0xFFFFF3C7) : const Color(0xFFD1FAE5));
    final textColor = isCotizado ? const Color(0xFFB45309) : (isAutorizadoPorPagar ? const Color(0xFFB45309) : const Color(0xFF047857));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: CustomHomeAppBar(user: widget.user),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.nombrePlan,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: estadoColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                estadoTexto,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            ..._buildStatusWidgets(
              context,
              widget.status,
              numberFormat,
              currencyFormat,
              retiroEnAnio,
            ),

            const SizedBox(height: 24),
            DetailCard(
              title: 'Retira en año 2065',
              udis: '${numberFormat.format(widget.totalRetirar2065)} UDIS',
              mxn: currencyFormat.format(widget.totalRetirar2065Mxn),
              icon: Icons.lock,
            ),
            const SizedBox(height: 24),
            UdiCard(
              udisActual: widget.user['udis_actual']?.toDouble(),
            ),
            const SizedBox(height: 24),
            _buildTableWidget(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStatusWidgets(
    BuildContext context,
    String status,
    NumberFormat numberFormat,
    NumberFormat currencyFormat,
    int retiroEnAnio,
  ) {
    if (status == 'cotizado') {
      return [
        DetailCard(
          title: 'Suma Asegurada',
          udis: '${numberFormat.format(widget.sumaAsegurada)} UDIS',
          mxn: currencyFormat.format(widget.sumaAseguradaMxn),
          icon: Icons.lock,
        ),
        const SizedBox(height: 16),
        DetailCard(
          title: 'Total a Retirar en ${retiroEnAnio-1}',
          udis: '${numberFormat.format(widget.recuperacionFinalUdis)} UDIS',
          mxn: currencyFormat.format(widget.recuperacionFinalMxn),
          icon: Icons.lock,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              final verificacion = widget.user['verificacion'];
              final perfilCompleto = widget.user['perfil_completo'] == 1;

              if (perfilCompleto) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BeneficiariesScreen(
                      user: widget.user,
                      beneficiarios: widget.beneficiarios,
                      userPlanId: widget.userPlanId,
                      status: widget.status,
                    ),
                  ),
                );
              } else if (verificacion['completed'] == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VerificacionCompletadaScreen()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => VerificacionScreen(user: widget.user)),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E5AFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Activar mi plan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        PlanActionsRow(
          user: widget.user, 
          beneficiarios: widget.beneficiarios, 
          status: widget.status,
          userPlanId: widget.userPlanId,
        ),
      ];
    }

    if (status == 'autorizado_por_pagar_1') {
      return [
        PlanAuthorizedCard(polizaUrl: widget.polizaUrl),
        const SizedBox(height: 16),
        SumaAseguradaChartCard(
          sumaUdis: widget.sumaAsegurada,
          sumaMxn: widget.sumaAseguradaMxn,
          beneficiarios: widget.beneficiarios.asMap().entries.map((entry) {
            final index = entry.key;
            final b = entry.value;
            final colores = [Colors.blue, Colors.lightBlue, Colors.indigo, Colors.green, Colors.orange];
            return {
              'nombre': b['nombre'] ?? 'Sin nombre',
              'porcentaje': b['porcentaje'] ?? 0,
              'color': colores[index % colores.length],
            };
          }).toList(),
        ),
        const SizedBox(height: 16),
        DetailCard(
          title: 'Total a Retirar en ${retiroEnAnio-1}',
          udis: '${numberFormat.format(widget.recuperacionFinalUdis)} UDIS',
          mxn: currencyFormat.format(widget.recuperacionFinalMxn),
          icon: Icons.lock,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Crear userPlan con los datos necesarios
              final Map<String, dynamic> userPlan = {
                'numero_poliza': userPlanInfo?['numero_poliza'],
                'duracion': widget.duracion,
                'periodicidad': 'anual', // Valor por defecto, se puede obtener del API
                'udis': widget.sumaAsegurada,
                'status': widget.status,
              };
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NextContributionScreen(
                    user: widget.user,
                    userPlan: userPlan,
                    cotizaciones: cotizaciones ?? [],
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Comenzar y pagar primera aportación',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        PlanActionsRow(
          user: widget.user,
          beneficiarios: widget.beneficiarios,
          status: widget.status,
          userPlanId: widget.userPlanId,
          polizaUrl: widget.polizaUrl,
        ),        
      ];
    }

    if (status == 'autorizado') {
      return [
        PlanAuthorizedCard(polizaUrl: widget.polizaUrl),
        const SizedBox(height: 16),
        SumaAseguradaChartCard(
          sumaUdis: widget.sumaAsegurada,
          sumaMxn: widget.sumaAseguradaMxn,
          beneficiarios: widget.beneficiarios.asMap().entries.map((entry) {
            final index = entry.key;
            final b = entry.value;
            final colores = [Colors.blue, Colors.lightBlue, Colors.indigo, Colors.green, Colors.orange];
            return {
              'nombre': b['nombre'] ?? 'Sin nombre',
              'porcentaje': b['porcentaje'] ?? 0,
              'color': colores[index % colores.length],
            };
          }).toList(),
        ),
        const SizedBox(height: 16),
        DetailCard(
          title: 'Total a Retirar en ${retiroEnAnio-1}',
          udis: '${numberFormat.format(widget.recuperacionFinalUdis)} UDIS',
          mxn: currencyFormat.format(widget.recuperacionFinalMxn),
          icon: Icons.lock,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Crear userPlan con los datos necesarios
              final Map<String, dynamic> userPlan = {
                'numero_poliza': userPlanInfo?['numero_poliza'],
                'duracion': widget.duracion,
                'periodicidad': 'anual', // Valor por defecto, se puede obtener del API
                'udis': widget.sumaAsegurada,
                'status': widget.status,
              };
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NextContributionScreen(
                    user: widget.user,
                    userPlan: userPlan,
                    cotizaciones: cotizaciones ?? [],
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Comenzar y pagar primera aportación',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        PlanActionsRow(
          user: widget.user,
          beneficiarios: widget.beneficiarios,
          status: widget.status,
          userPlanId: widget.userPlanId,
          polizaUrl: widget.polizaUrl,
        ),        
      ];
    }    

    return [];
  }

  Widget _buildTableWidget() {
    if (widget.status == 'cotizado' || widget.status == 'autorizado_por_pagar_1') {
      return cotizaciones == null
          ? const Center(child: CircularProgressIndicator())
          : PlanContributionsTable(
              cotizaciones: cotizaciones!,
              status: widget.status,
              user: widget.user,
              currentPlan: {
                'id': widget.userPlanId,
                'nombre_plan': widget.nombrePlan,
                'status': widget.status,
                'duracion': widget.duracion,
                'numero_poliza': userPlanInfo?['numero_poliza'],
                'periodicidad': userPlanInfo?['periodicidad'],
                'udis': userPlanInfo?['udis'],
                'beneficiarios': widget.beneficiarios,
              },
            );
    } else if (widget.status == 'autorizado') {
      return movimientos == null
          ? const Center(child: CircularProgressIndicator())
          : PlanMovementsTable(
              movimientos: movimientos!,
              status: widget.status,
              user: widget.user,
              currentPlan: {
                'id': widget.userPlanId,
                'nombre_plan': widget.nombrePlan,
                'status': widget.status,
                'duracion': widget.duracion,
                'numero_poliza': userPlanInfo?['numero_poliza'],
                'periodicidad': userPlanInfo?['periodicidad'],
                'udis': userPlanInfo?['udis'],
                'beneficiarios': widget.beneficiarios,
              },
              cotizaciones: cotizaciones,
            );
    }
    
    return const SizedBox.shrink();
  }
}

void showPlanAuthorizedDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified, color: Colors.green, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Tu plan ha sido autorizado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textGray900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Tu plan ha sido autorizado por un periodo de 30 días\n\n'
              'Al contestar los cuestionarios y revisar tu plan cotizado, has autorizado tu plan.\n\n'
              'Para activar tu plan por completo y tener acceso a todas las herramientas que Neek tiene para ti, '
              'debes revisar tu póliza y realizar la primera aportación.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textGray500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Entendido',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

