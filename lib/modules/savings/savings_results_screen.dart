import 'package:flutter/material.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/modules/register/plan_register_screen_v2.dart';
import 'package:neek/core/quote_service.dart';
import 'package:neek/modules/savings/widgets/plan_selection_widget.dart';

class SavingsResultsScreen extends StatefulWidget {
  final Map<String, dynamic> simulationResults;
  final String token;
  final VoidCallback onBack;

  const SavingsResultsScreen({
    super.key,
    required this.simulationResults,
    required this.token,
    required this.onBack,
  });

  @override
  State<SavingsResultsScreen> createState() => _SavingsResultsScreenState();
}

class _SavingsResultsScreenState extends State<SavingsResultsScreen> {
  List<PlanOption>? plans;
  PlanOption? selectedPlan;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    try {
      // Si ya tenemos planes en los datos de simulación, usarlos
      if (widget.simulationResults.containsKey('plans')) {
        final List<dynamic> plansData = widget.simulationResults['plans'] as List<dynamic>;
        final List<PlanOption> plansList = plansData.map((plan) => PlanOption.fromJson(plan)).toList();
        setState(() {
          plans = plansList;
          isLoading = false;
        });
      } else {
        // Si no hay planes, crear planes de ejemplo
        final mockPlans = _createMockPlans();
        setState(() {
          plans = mockPlans;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar planes: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<PlanOption> _createMockPlans() {
    // Crear planes de ejemplo basados en los parámetros de simulación
    final parameters = widget.simulationResults['parameters'] as Map<String, dynamic>;
    
    List<PlanOption> mockPlans = [];
    
    // Generar 3-5 planes de ejemplo con variaciones
    for (int i = 0; i < 4; i++) {
      final baseAge = parameters['age'] as int? ?? 30;
      final baseDuration = parameters['plan_duration'] as int? ?? 10;
      final baseMonthly = parameters['monthly_savings'] as double? ?? 2500.0;
      
      mockPlans.add(PlanOption(
        id: 9056 + i,
        age: baseAge,
        year: baseDuration,
        ageRange: '${baseAge - 2}-${baseAge + 2}',
        coverageType: i == 0 ? 'Sin Cobertura' : 'Con Cobertura',
        planDuration: baseDuration,
        udiValueUsed: '8.54',
        monthlySavings: baseMonthly.toStringAsFixed(2),
        primaAnualUdis: (baseMonthly * 12).toStringAsFixed(2),
        primaMensualMxn: baseMonthly * 0.99,
        udiValueAt2050: 22.77 + (i * 0.5),
        annualGrowthRate: 0.04,
        sumaAseguradaMxn: (baseMonthly * 12 * baseDuration * (1.2 + i * 0.1)),
        sumaAseguradaUdis: (baseMonthly * 12 * baseDuration * (1.2 + i * 0.1) / 8.54).toStringAsFixed(0),
        totalRetirar2050Mxn: (baseMonthly * 12 * baseDuration * (1.8 + i * 0.2)),
        totalRetirarPlanMxn: (baseMonthly * 12 * baseDuration * (1.5 + i * 0.1)),
        udiValueAtPlanYear: 12.16 + (i * 0.3),
        totalRetirar2050Udis: (baseMonthly * 12 * baseDuration * (1.8 + i * 0.2) / 8.54).toStringAsFixed(0),
        totalRetirarPlanUdis: (baseMonthly * 12 * baseDuration * (1.5 + i * 0.1) / 8.54).toStringAsFixed(0),
      ));
    }
    
    return mockPlans;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Planes Disponibles',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              )
            : plans != null
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: PlanSelectionWidget(
                      plans: plans!,
                      onPlanSelected: _onPlanSelected,
                    ),
                  )
                : const Center(
                    child: Text(
                      'No se encontraron planes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
      ),
    );
  }

  void _onPlanSelected(PlanOption plan) {
    setState(() => selectedPlan = plan);
    
    // Navegar al registro con el plan seleccionado
    final userData = {
      'simulation_type': widget.simulationResults['simulation_type'],
      'simulation_token': widget.token,
      'simulation_parameters': widget.simulationResults['parameters'],
      'selected_plan': plan,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlanRegisterScreenV2(userData: userData),
      ),
    );
  }

}
