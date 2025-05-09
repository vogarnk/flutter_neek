import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neek/shared/common/gradient_circle_ring.dart';
import 'package:neek/core/theme/app_colors.dart'; // Asegúrate de importar tu archivo de colores
import 'dart:ui';
class CardNeek extends StatelessWidget {
  final String nombrePlan;
  final bool mostrarBoton; // 👈 nuevo parámetro

  const CardNeek({
    super.key,
    required this.nombrePlan,
    this.mostrarBoton = true, // por defecto se muestra
  });


  @override
  Widget build(BuildContext context) {

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
          const SizedBox(height: 20),
          if (mostrarBoton) ...[
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (_) => const _EditPlanNameModal(),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: AppColors.textGray200,
                    width: 1.5,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Cambiar nombre del plan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.background,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.edit, size: 18, color: AppColors.background),
                  ],
                ),
              ),
            ),
          ],
  
        ],
      ),
    );
  }
}

class _EditPlanNameModal extends StatelessWidget {
  const _EditPlanNameModal({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Padding(
      padding: MediaQuery.of(context).viewInsets, // para mover con el teclado
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.hardEdge, // necesario para que el blur no se desborde
              child: Stack(
                children: [
                  // Fondo decorativo (círculo)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 22), // 👈 aquí defines el espacio a la derecha
                      child: GradientCircleRing(size: 80, strokeWidth: 4),
                    ),
                  ),
                  // Capa de desenfoque y contenido principal
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  'assets/logo.svg',
                                  height: 16,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 8),
                                // Campo de texto
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: TextField(
                                    controller: controller,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      hintText: 'Nombra tu plan de ahorro',
                                      hintStyle: TextStyle(color: Colors.white70),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'PLAN DE AHORRO + PROTECCIÓN',
                                  style: TextStyle(fontSize: 10, color: Colors.white54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),



            const SizedBox(height: 20),
            const Text(
              'Recuerda nombrar tu plan de acuerdo a tu objetivo de ahorro o sobre las metas que deseas lograr. Una vez que cambies el nombre te notificaremos para confirmar.',
              style: TextStyle(fontSize: 13, color: AppColors.textGray500),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: acción guardar
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Guardar',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
