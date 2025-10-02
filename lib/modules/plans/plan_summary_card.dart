import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/shared/tables/udi_plan_summary.dart';
import 'package:neek/core/api_service.dart';
import 'package:neek/core/beneficiario_service.dart';
import 'package:neek/modules/verification/verificacion_screen.dart';
import 'package:neek/modules/beneficiaries/beneficiaries_screen.dart';
import 'package:neek/modules/plans/questionnaire_stepper_screen.dart';
import 'dart:convert';

class PlanSummaryScreen extends StatelessWidget {
  final int plazo;
  final double ahorroAnual;
  final double primaAnual;
  final double sumaAsegurada;
  final double totalRetirarCorto;
  final double totalRetirarLargo;
  final int anioCorto;
  final int anioLargo;
  final int beneficiarios;

  const PlanSummaryScreen({
    super.key,
    required this.plazo,
    required this.ahorroAnual,
    required this.primaAnual,
    required this.sumaAsegurada,
    required this.totalRetirarCorto,
    required this.totalRetirarLargo,
    required this.anioCorto,
    required this.anioLargo,
    required this.beneficiarios,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: PlanSummaryCard(
            plazo: plazo,
            ahorroAnual: ahorroAnual,
            primaAnual: primaAnual,
            sumaAsegurada: sumaAsegurada,
            totalRetirarCorto: totalRetirarCorto,
            totalRetirarLargo: totalRetirarLargo,
            anioCorto: anioCorto,
            anioLargo: anioLargo,
            beneficiarios: beneficiarios,
          ),
        ),
      ),
    );
  }
}

class PlanSummaryCard extends StatefulWidget {
  final int plazo;
  final double ahorroAnual;
  final double primaAnual;
  final double sumaAsegurada;
  final double totalRetirarCorto;
  final double totalRetirarLargo;
  final int anioCorto;
  final int anioLargo;
  final int beneficiarios;

  const PlanSummaryCard({
    super.key,
    required this.plazo,
    required this.ahorroAnual,
    required this.primaAnual,
    required this.sumaAsegurada,
    required this.totalRetirarCorto,
    required this.totalRetirarLargo,
    required this.anioCorto,
    required this.anioLargo,
    required this.beneficiarios,
  });

  @override
  State<PlanSummaryCard> createState() => _PlanSummaryCardState();
}

class _PlanSummaryCardState extends State<PlanSummaryCard> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'es_MX', symbol: 'MXN');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Detalles de tu plan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold , color: AppColors.background)),

          const SizedBox(height: 20),
          _formField('Plazo del ahorro', '${widget.plazo} años'),
          const SizedBox(height: 12),
          _formField('Ahorro anual', currencyFormat.format(widget.ahorroAnual)),

          const SizedBox(height: 20),

          UdiPlanSummaryCard(
            primaAnual: widget.primaAnual,
            sumaAsegurada: widget.sumaAsegurada,
            totalRetirarCorto: widget.totalRetirarCorto,
            totalRetirarLargo: widget.totalRetirarLargo,
            anioCorto: widget.anioCorto,
            anioLargo: widget.anioLargo,
            beneficiarios: widget.beneficiarios,
            udisActual: 8.54, // Valor por defecto, idealmente debería venir como parámetro
          ),

          const SizedBox(height: 24),
          const Text(
            'Revisa tu cotización más información a detalle. Toma en cuenta que el total a retirar o el valor de recuperación puede verse afectado por movimientos como préstamos o abonos que realices.',
            style: TextStyle(fontSize: 10, color: AppColors.textGray400),
          ),

          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _handleActivateButton,
                  icon: _isLoading 
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.arrow_forward),
                  label: Text(
                    _isLoading ? 'Verificando...' : 'Activar',
                    overflow: TextOverflow.ellipsis, // 👈 evita desbordamiento
                    softWrap: false,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // 👈 suficiente espacio
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

            ],
          )
        ],
      ),
    );
  }

  Future<void> _handleActivateButton() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Obtener datos del usuario
      final userData = await _getUserData();
      if (userData == null) {
        _showError('No se pudieron obtener los datos del usuario');
        return;
      }

      // Verificar si el usuario está verificado
      final isUserVerified = userData['perfil_completo'] == 1;
      
      if (!isUserVerified) {
        // Usuario no verificado, ir a verificación
        _navigateToVerification(userData);
        return;
      }

      // Usuario verificado, verificar beneficiarios
      final beneficiarios = await _getBeneficiarios();
      final areBeneficiariesComplete = _areBeneficiariesComplete(beneficiarios);

      if (!areBeneficiariesComplete) {
        // Beneficiarios no completos, ir a agregar beneficiarios
        _navigateToBeneficiaries(userData, beneficiarios);
        return;
      }

      // Usuario verificado y beneficiarios completos, ir al cuestionario
      _navigateToQuestionnaire();
      
    } catch (e) {
      _showError('Error al verificar el estado: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>?> _getUserData() async {
    try {
      final response = await ApiService.instance.get('/user');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      }
      return null;
    } catch (e) {
      print('Error obteniendo datos del usuario: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> _getBeneficiarios() async {
    try {
      final userPlanId = await BeneficiarioService.obtenerUserPlanId();
      if (userPlanId == null) {
        return [];
      }
      return await BeneficiarioService.getBeneficiarios(userPlanId: userPlanId);
    } catch (e) {
      print('Error obteniendo beneficiarios: $e');
      return [];
    }
  }

  bool _areBeneficiariesComplete(List<Map<String, dynamic>> beneficiarios) {
    if (beneficiarios.isEmpty) {
      return false;
    }

    // Verificar que la suma de porcentajes sea exactamente 100%
    final totalPercentage = beneficiarios.fold<int>(
      0,
      (sum, beneficiario) => sum + (int.tryParse(beneficiario['porcentaje']?.toString() ?? '0') ?? 0),
    );

    return totalPercentage == 100;
  }

  void _navigateToVerification(Map<String, dynamic> userData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerificacionScreen(user: userData),
      ),
    );
  }

  void _navigateToBeneficiaries(Map<String, dynamic> userData, List<Map<String, dynamic>> beneficiarios) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BeneficiariesScreen(
          user: userData,
          beneficiarios: beneficiarios,
          status: 'cotizado',
        ),
      ),
    );
  }

  void _navigateToQuestionnaire() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuestionnaireStepperScreen(),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _formField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textGray900, // Título en gris oscuro
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.background50, // 👈 Fondo claro
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.textGray300, // 👈 Borde gris
              width: 1.0,
            ),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textGray500, // Texto oscuro
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}