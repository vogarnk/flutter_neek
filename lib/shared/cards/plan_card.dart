import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neek/shared/common/gradient_circle_ring.dart';
import 'package:intl/intl.dart';
import 'package:neek/modules/plans/plan_detail_screen.dart'; // 👈 Asegúrate de importar correctamente

class PlanCard extends StatelessWidget {
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
  final int userPlanId;
  final String status;
  final String? polizaUrl;

  const PlanCard({
    super.key,
    required this.user,
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
    required this.beneficiarios,
    required this.status,
    required this.userPlanId,
    this.polizaUrl,
  });



  @override
  Widget build(BuildContext context) {
    final montoFinal = NumberFormat('#,###', 'en_US').format(recuperacionFinalUdis);
  // Estado visual
  final isCotizado = status == 'cotizado';
  final isAutorizadoPorPagar = status == 'autorizado_por_pagar_1';
  final estadoTexto = isCotizado ? 'Por Activar' : (isAutorizadoPorPagar ? 'Póliza autorizada' : 'Autorizado');
  final estadoColor = isCotizado ? const Color(0xFFFFF3C7) : (isAutorizadoPorPagar ? const Color(0xFFFFF3C7) : const Color(0xFFD1FAE5));
  final iconColor = isCotizado ? const Color(0xFFB45309) : (isAutorizadoPorPagar ? const Color(0xFFB45309) : const Color(0xFF047857));
  final textColor = iconColor;

    return Container(
      width: MediaQuery.of(context).size.width, // 🔧 Ocupa todo el ancho disponible
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjeta interior oscura con contenido
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Información del plan
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/logo.svg',
                        height: 16,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        nombrePlan,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('MOTIVO DE AHORRO:', style: TextStyle(color: Colors.white, fontSize: 12)),
                      const Text('Retiro', style: TextStyle(color: Colors.white, fontSize: 14)),
                      const SizedBox(height: 4),
                      const Text('PLAN DE AHORRO + PROTECCIÓN', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Centrado vertical
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    GradientCircleRing(size: 90, strokeWidth: 4),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Estado y botón
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: estadoColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time, size: 16, color: iconColor),
                    const SizedBox(width: 6),
                    Text(
                      estadoTexto,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlanDetailScreen(
                        user:user,
                        nombrePlan: nombrePlan,
                        duracion: duracion,
                        recuperacionFinalUdis: recuperacionFinalUdis,
                        recuperacionFinalMxn: recuperacionFinalMxn,
                        sumaAsegurada: sumaAsegurada,
                        sumaAseguradaMxn: sumaAseguradaMxn,
                        totalRetirar: totalRetirar,
                        totalRetirarMxn: totalRetirarMxn,
                        totalRetirar2065: totalRetirar2065,
                        totalRetirar2065Mxn: totalRetirar2065Mxn,
                        beneficiarios: beneficiarios,
                        status: status,
                        userPlanId: userPlanId,
                        polizaUrl: polizaUrl,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B5BFE),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Ver Plan'),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            '$montoFinal UDIS',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}