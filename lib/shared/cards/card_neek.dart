import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neek/shared/common/gradient_circle_ring.dart';
import 'package:neek/core/theme/app_colors.dart'; // Asegúrate de importar tu archivo de colores
import 'package:neek/core/user_plan_service.dart';
import 'dart:ui';
class CardNeek extends StatefulWidget {
  final String nombrePlan;
  final bool mostrarBoton; // 👈 nuevo parámetro
  final int? userPlanId; // 👈 ID del plan de usuario (opcional)

  const CardNeek({
    super.key,
    required this.nombrePlan,
    this.userPlanId,
    this.mostrarBoton = true, // por defecto se muestra
  });

  @override
  State<CardNeek> createState() => _CardNeekState();
}

class _CardNeekState extends State<CardNeek> {
  late String _currentPlanName;

  @override
  void initState() {
    super.initState();
    _currentPlanName = widget.nombrePlan;
  }

  void _onPlanNameUpdated(String newName) {
    setState(() {
      _currentPlanName = newName;
    });
  }


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
                        _currentPlanName,
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
          if (widget.mostrarBoton) ...[
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                if (widget.userPlanId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No se puede cambiar el nombre del plan en este momento'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }
                
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (_) => _EditPlanNameModal(
                    userPlanId: widget.userPlanId!,
                    currentPlanName: _currentPlanName,
                    onPlanNameUpdated: _onPlanNameUpdated,
                  ),
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

class _EditPlanNameModal extends StatefulWidget {
  final dynamic userPlanId; // 👈 Cambiar a dynamic para manejar int o String
  final String currentPlanName;
  final Function(String) onPlanNameUpdated;

  const _EditPlanNameModal({
    required this.userPlanId,
    required this.currentPlanName,
    required this.onPlanNameUpdated,
  });

  @override
  State<_EditPlanNameModal> createState() => _EditPlanNameModalState();
}

class _EditPlanNameModalState extends State<_EditPlanNameModal> {
  late TextEditingController controller;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.currentPlanName);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _updatePlanName() async {
    print('🔍 _updatePlanName: Iniciando actualización');
    print('🔍 _updatePlanName: userPlanId = ${widget.userPlanId}');
    print('🔍 _updatePlanName: nombrePlan = ${controller.text.trim()}');
    
    if (controller.text.trim().isEmpty) {
      print('🔍 _updatePlanName: Nombre vacío, mostrando error');
      _showSnackBar('Por favor ingresa un nombre para el plan', isError: true);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      print('🔍 _updatePlanName: Llamando al servicio');
      final result = await UserPlanService.instance.updatePlanName(
        userPlanId: widget.userPlanId is int ? widget.userPlanId : int.tryParse(widget.userPlanId.toString()) ?? 0,
        nombrePlan: controller.text.trim(),
      );

      print('🔍 _updatePlanName: Resultado del servicio = $result');

      if (result['success']) {
        widget.onPlanNameUpdated(controller.text.trim());
        Navigator.pop(context);
      } else {
        print('🔍 _updatePlanName: Error en la actualización: ${result['message']}');
        _showSnackBar(result['message'] ?? 'Error al actualizar el plan', isError: true);
      }
    } catch (e) {
      print('🔍 _updatePlanName: Excepción capturada: $e');
      _showSnackBar('Error de conexión. Intenta nuevamente.', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

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
                onPressed: isLoading ? null : () {
                  print('🔍 Botón Guardar presionado');
                  _updatePlanName();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
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
