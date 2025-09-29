import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/core/quote_service.dart' as quote;
import 'package:neek/models/savings_models.dart';
import 'package:neek/modules/savings/cards/monthly_savings_card.dart';
import 'package:neek/modules/savings/cards/target_amount_card.dart';
import 'package:neek/modules/savings/cards/education_card.dart';
import 'package:neek/modules/savings/cards/insurance_amount_card.dart';
import 'package:neek/modules/savings/widgets/simulation_plan_card.dart';
import 'package:neek/modules/register/plan_register_screen_v2.dart';

class SavingsTypeSelectionScreen extends StatefulWidget {
  final Map<String, dynamic>? previousParameters;
  final String? previousSimulationType;
  
  const SavingsTypeSelectionScreen({
    super.key,
    this.previousParameters,
    this.previousSimulationType,
  });

  @override
  State<SavingsTypeSelectionScreen> createState() => _SavingsTypeSelectionScreenState();
}

class _SavingsTypeSelectionScreenState extends State<SavingsTypeSelectionScreen> {
  String? selectedType;
  bool isLoading = false;
  String? generatedToken;
  Map<String, dynamic>? simulationResults;
  List<quote.PlanOption>? plans;
  bool showInputs = true;
  late PageController _pageController;
  
  // Variables para mantener los valores actuales de los parámetros
  Map<String, dynamic>? currentParameters;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    // Si hay parámetros previos, inicializar con ellos
    if (widget.previousParameters != null) {
      currentParameters = widget.previousParameters;
      selectedType = widget.previousSimulationType;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          plans != null ? 'Planes Disponibles' : 'Selecciona tu tipo de ahorro',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: plans != null ? [
          IconButton(
            onPressed: () => setState(() => showInputs = !showInputs),
            icon: Icon(
              showInputs ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ),
        ] : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (selectedType == null) _buildTypeSelection(),
            if (selectedType != null && plans == null) _buildInputCard(),
            if (isLoading) _buildLoadingIndicator(),
            if (plans != null) ...[
              if (showInputs) _buildCollapsedInputs(),
              Expanded(child: _buildPlansList()),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelection() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Como te gustaría calcular tu plan?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Elige el tipo de simulación que mejor se adapte a tus metas de ahorro.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textGray300,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: SavingsType.allTypes.length,
              itemBuilder: (context, index) {
                final type = SavingsType.allTypes[index];
                return _buildTypeCard(type);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeCard(SavingsType type) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => setState(() => selectedType = type.id),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: type.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SvgPicture.asset(
                  type.iconPath,
                  width: 12,
                  height: 12,
                  colorFilter: ColorFilter.mode(
                    type.color,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                type.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textGray900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                type.description,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textGray500,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    switch (selectedType) {
      case 'monthly-savings':
        return MonthlySavingsCard(
          onSimulate: _simulateMonthlySavings,
          onBack: () => setState(() => selectedType = null),
          initialAge: currentParameters?['age'],
          initialPlanDuration: currentParameters?['plan_duration'],
          initialMonthlySavings: currentParameters?['monthly_savings'],
        );
      case 'target-amount':
        return TargetAmountCard(
          onSimulate: _simulateTargetAmount,
          onBack: () => setState(() => selectedType = null),
          initialAge: currentParameters?['age'],
          initialTargetAmount: currentParameters?['target_amount'],
          initialTargetAge: currentParameters?['target_age'],
        );
      case 'education':
        return EducationCard(
          onSimulate: _simulateEducation,
          onBack: () => setState(() => selectedType = null),
          initialAge: currentParameters?['age'],
          initialMonthlySavings: currentParameters?['monthly_savings'],
          initialYearsToUniversity: currentParameters?['years_to_university'],
        );
      case 'insurance-amount':
        return InsuranceAmountCard(
          onSimulate: _simulateInsuranceAmount,
          onBack: () => setState(() => selectedType = null),
          initialAge: currentParameters?['age'],
          initialInsuranceAmount: currentParameters?['insurance_amount'],
        );
      default:
        return Container();
    }
  }

  Widget _buildLoadingIndicator() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            const Text(
              'Generando tu simulación...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Esto puede tomar unos momentos',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textGray300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedInputs() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                _getSimulationIcon(selectedType!),
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getSimulationTypeTitle(selectedType!),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGray900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Toca un parámetro para editarlo',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textGray500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => setState(() => showInputs = !showInputs),
                icon: Icon(
                  showInputs ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.textGray500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildParameterChips(),
        ],
      ),
    );
  }

  Widget _buildParameterChips() {
    if (simulationResults == null) return const SizedBox.shrink();
    
    final parameters = simulationResults!['parameters'] as Map<String, dynamic>;
    final simulationType = simulationResults!['simulation_type'] as String;
    
    List<Widget> chips = [];
    
    switch (simulationType) {
      case 'monthly-savings':
        chips = [
          _buildParameterChip('Edad', '${parameters['age']} años', () => _editParameter('age')),
          _buildParameterChip('Plazo', '${parameters['plan_duration']} años', () => _editParameter('plan_duration')),
          _buildParameterChip('Ahorro Mensual', '\$${NumberFormat('#,###', 'es_MX').format(parameters['monthly_savings'])}', () => _editParameter('monthly_savings')),
        ];
        break;
      case 'target-amount':
        chips = [
          _buildParameterChip('Edad', '${parameters['age']} años', () => _editParameter('age')),
          _buildParameterChip('Monto Objetivo', '\$${NumberFormat('#,###', 'es_MX').format(parameters['target_amount'])}', () => _editParameter('target_amount')),
          _buildParameterChip('Edad Objetivo', '${parameters['target_age']} años', () => _editParameter('target_age')),
        ];
        break;
      case 'education':
        chips = [
          _buildParameterChip('Edad', '${parameters['age']} años', () => _editParameter('age')),
          _buildParameterChip('Ahorro Mensual', '\$${NumberFormat('#,###', 'es_MX').format(parameters['monthly_savings'])}', () => _editParameter('monthly_savings')),
          _buildParameterChip('Años a Universidad', '${parameters['years_to_university']} años', () => _editParameter('years_to_university')),
        ];
        break;
      case 'insurance-amount':
        chips = [
          _buildParameterChip('Edad', '${parameters['age']} años', () => _editParameter('age')),
          _buildParameterChip('Monto Seguro', '\$${NumberFormat('#,###', 'es_MX').format(parameters['insurance_amount'])}', () => _editParameter('insurance_amount')),
          _buildParameterChip('Beneficiarios', '${parameters['beneficiaries']} personas', () => _editParameter('beneficiaries')),
        ];
        break;
    }
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips,
    );
  }

  Widget _buildParameterChip(String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: ',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textGray900,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.edit,
              size: 14,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  void _editParameter(String parameterName) {
    // Expandir inputs y limpiar la selección de planes
    setState(() {
      showInputs = true;
      plans = null; // Limpiar planes para permitir nueva simulación
      generatedToken = null;
      simulationResults = null;
    });
  }

  Widget _buildPlansList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Desliza para ver todos los planes disponibles:',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textGray300,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _buildPlansSlider(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlansSlider() {
    return Column(
      children: [
        // PageView con los planes
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: plans!.length,
            itemBuilder: (context, index) {
              final plan = plans![index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SingleChildScrollView(
                  child: SimulationPlanCard(
                    plan: plan,
                    isSelected: false,
                    onTap: () => _selectPlan(plan),
                    simulationType: simulationResults!['simulation_type'],
                  ),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Indicador de páginas
        Center(
          child: SmoothPageIndicator(
            controller: _pageController,
            count: plans!.length,
            effect: const ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              spacing: 6,
              activeDotColor: AppColors.primary,
              dotColor: AppColors.textGray500,
            ),
          ),
        ),
      ],
    );
  }


  void _selectPlan(quote.PlanOption plan) {
    // Navegar al registro con el plan seleccionado
    final userData = {
      'simulation_type': simulationResults!['simulation_type'],
      'simulation_token': generatedToken!,
      'simulation_parameters': simulationResults!['parameters'],
      'selected_plan': plan.toJson(),
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlanRegisterScreenV2(userData: userData),
      ),
    );
  }

  Future<void> _simulateMonthlySavings({
    required int age,
    required int planDuration,
    required double monthlySavings,
  }) async {
    setState(() => isLoading = true);
    
    try {
      // Debug: mostrar parámetros que se envían
      debugPrint('=== SIMULACIÓN AHORRO MENSUAL ===');
      debugPrint('Parámetros enviados:');
      debugPrint('- age: $age');
      debugPrint('- planDuration: $planDuration');
      debugPrint('- monthlySavings: $monthlySavings');
      
      // Llamada real a la API
      final response = await quote.QuoteService().simulateMonthlySavings(
        age: age,
        planDuration: planDuration,
        monthlySavings: monthlySavings,
      );
      
      // Debug: mostrar respuesta de la API
      debugPrint('Respuesta de la API:');
      debugPrint('- success: ${response.success}');
      debugPrint('- token: ${response.token}');
      debugPrint('- message: ${response.message}');
      debugPrint('- expiresAt: ${response.expiresAt}');
      
      if (response.success) {
        // Debug: consultar resultados por token
        debugPrint('Consultando resultados con token: ${response.token}');
        
        // Obtener los resultados usando el token
        final results = await quote.QuoteService().getResultsByToken(response.token);
        
        // Debug: mostrar resultados obtenidos
        debugPrint('Resultados obtenidos:');
        debugPrint('- simulationType: ${results.simulationType}');
        debugPrint('- plans count: ${results.plans.length}');
        if (results.plans.isNotEmpty) {
          debugPrint('- primer plan ID: ${results.plans.first.id}');
          debugPrint('- primer plan duración: ${results.plans.first.planDuration}');
        }
        
        final simulationData = {
          'simulation_type': 'monthly-savings',
          'parameters': {
            'age': age,
            'plan_duration': planDuration,
            'monthly_savings': monthlySavings,
          },
          'plans': results.plans.map((plan) => plan.toJson()).toList(),
          'token': response.token,
          'expires_at': response.expiresAt.toIso8601String(),
        };
        
        setState(() {
          generatedToken = response.token;
          simulationResults = simulationData;
          plans = results.plans.isNotEmpty ? results.plans : _createMockPlans(age, planDuration, monthlySavings);
          showInputs = false; // Contraer inputs después de la simulación
          currentParameters = {
            'age': age,
            'plan_duration': planDuration,
            'monthly_savings': monthlySavings,
          };
          isLoading = false;
        });
        
        // Debug: verificar que los planes se cargaron
        debugPrint('Planes cargados: ${plans?.length}');
        if (plans != null && plans!.isNotEmpty) {
          debugPrint('Primer plan: ${plans!.first.id}');
        }
      } else {
        setState(() => isLoading = false);
        _showError('Error al generar la simulación: ${response.message}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showError('Error al generar la simulación: $e');
    }
  }

  Future<void> _simulateTargetAmount({
    required int age,
    required double targetAmount,
    required int targetAge,
  }) async {
    setState(() => isLoading = true);
    
    try {
      // Debug: mostrar parámetros que se envían
      debugPrint('=== SIMULACIÓN MONTO OBJETIVO ===');
      debugPrint('Parámetros enviados:');
      debugPrint('- age: $age');
      debugPrint('- targetAmount: $targetAmount');
      debugPrint('- targetAge: $targetAge');
      
      // Llamada real a la API
      final response = await quote.QuoteService().simulateTargetAmount(
        age: age,
        targetAmount: targetAmount,
        targetAge: targetAge,
      );
      
      // Debug: mostrar respuesta de la API
      debugPrint('Respuesta de la API:');
      debugPrint('- success: ${response.success}');
      debugPrint('- token: ${response.token}');
      debugPrint('- message: ${response.message}');
      debugPrint('- expiresAt: ${response.expiresAt}');
      
      if (response.success) {
        // Debug: consultar resultados por token
        debugPrint('Consultando resultados con token: ${response.token}');
        
        // Obtener los resultados usando el token
        final results = await quote.QuoteService().getResultsByToken(response.token);
        
        // Debug: mostrar resultados obtenidos
        debugPrint('Resultados obtenidos:');
        debugPrint('- simulationType: ${results.simulationType}');
        debugPrint('- plans count: ${results.plans.length}');
        if (results.plans.isNotEmpty) {
          debugPrint('- primer plan ID: ${results.plans.first.id}');
          debugPrint('- primer plan duración: ${results.plans.first.planDuration}');
        }
        
        final simulationData = {
          'simulation_type': 'target-amount',
          'parameters': {
            'age': age,
            'target_amount': targetAmount,
            'target_age': targetAge,
          },
          'plans': results.plans.map((plan) => plan.toJson()).toList(),
          'token': response.token,
          'expires_at': response.expiresAt.toIso8601String(),
        };
        
        setState(() {
          generatedToken = response.token;
          simulationResults = simulationData;
          plans = results.plans.isNotEmpty ? results.plans : _createMockPlans(age, targetAge - age, targetAmount / ((targetAge - age) * 12));
          showInputs = false; // Contraer inputs después de la simulación
          currentParameters = {
            'age': age,
            'target_amount': targetAmount,
            'target_age': targetAge,
          };
          isLoading = false;
        });
        
        // Debug: verificar que los planes se cargaron
        debugPrint('Planes cargados: ${plans?.length}');
        if (plans != null && plans!.isNotEmpty) {
          debugPrint('Primer plan: ${plans!.first.id}');
        }
      } else {
        setState(() => isLoading = false);
        _showError('Error al generar la simulación: ${response.message}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showError('Error al generar la simulación: $e');
    }
  }

  Future<void> _simulateEducation({
    required int age,
    required double monthlySavings,
    required int yearsToUniversity,
  }) async {
    setState(() => isLoading = true);
    
    try {
      // Debug: mostrar parámetros que se envían
      debugPrint('=== SIMULACIÓN EDUCACIÓN ===');
      debugPrint('Parámetros enviados:');
      debugPrint('- age: $age');
      debugPrint('- monthlySavings: $monthlySavings');
      debugPrint('- yearsToUniversity: $yearsToUniversity');
      
      // Llamada real a la API
      final response = await quote.QuoteService().simulateEducation(
        age: age,
        monthlySavings: monthlySavings,
        yearsToUniversity: yearsToUniversity,
      );
      
      // Debug: mostrar respuesta de la API
      debugPrint('Respuesta de la API:');
      debugPrint('- success: ${response.success}');
      debugPrint('- token: ${response.token}');
      debugPrint('- message: ${response.message}');
      debugPrint('- expiresAt: ${response.expiresAt}');
      
      if (response.success) {
        // Debug: consultar resultados por token
        debugPrint('Consultando resultados con token: ${response.token}');
        
        // Obtener los resultados usando el token
        final results = await quote.QuoteService().getResultsByToken(response.token);
        
        // Debug: mostrar resultados obtenidos
        debugPrint('Resultados obtenidos:');
        debugPrint('- simulationType: ${results.simulationType}');
        debugPrint('- plans count: ${results.plans.length}');
        if (results.plans.isNotEmpty) {
          debugPrint('- primer plan ID: ${results.plans.first.id}');
          debugPrint('- primer plan duración: ${results.plans.first.planDuration}');
        }
        
        final simulationData = {
          'simulation_type': 'education',
          'parameters': {
            'age': age,
            'monthly_savings': monthlySavings,
            'years_to_university': yearsToUniversity,
          },
          'plans': results.plans.map((plan) => plan.toJson()).toList(),
          'token': response.token,
          'expires_at': response.expiresAt.toIso8601String(),
        };
        
        setState(() {
          generatedToken = response.token;
          simulationResults = simulationData;
          plans = results.plans.isNotEmpty ? results.plans : _createMockPlans(age, yearsToUniversity, monthlySavings);
          showInputs = false; // Contraer inputs después de la simulación
          currentParameters = {
            'age': age,
            'monthly_savings': monthlySavings,
            'years_to_university': yearsToUniversity,
          };
          isLoading = false;
        });
        
        // Debug: verificar que los planes se cargaron
        debugPrint('Planes cargados: ${plans?.length}');
        if (plans != null && plans!.isNotEmpty) {
          debugPrint('Primer plan: ${plans!.first.id}');
        }
      } else {
        setState(() => isLoading = false);
        _showError('Error al generar la simulación: ${response.message}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showError('Error al generar la simulación: $e');
    }
  }

  Future<void> _simulateInsuranceAmount({
    required int age,
    required double insuranceAmount,
  }) async {
    setState(() => isLoading = true);
    
    try {
      // Debug: mostrar parámetros que se envían
      debugPrint('=== SIMULACIÓN SUMA ASEGURADA ===');
      debugPrint('Parámetros enviados:');
      debugPrint('- age: $age');
      debugPrint('- insuranceAmount: $insuranceAmount');
      
      // Llamada real a la API
      final response = await quote.QuoteService().simulateInsuranceAmount(
        age: age,
        insuranceAmount: insuranceAmount,
      );
      
      // Debug: mostrar respuesta de la API
      debugPrint('Respuesta de la API:');
      debugPrint('- success: ${response.success}');
      debugPrint('- token: ${response.token}');
      debugPrint('- message: ${response.message}');
      debugPrint('- expiresAt: ${response.expiresAt}');
      
      if (response.success) {
        // Debug: consultar resultados por token
        debugPrint('Consultando resultados con token: ${response.token}');
        
        // Obtener los resultados usando el token
        final results = await quote.QuoteService().getResultsByToken(response.token);
        
        // Debug: mostrar resultados obtenidos
        debugPrint('Resultados obtenidos:');
        debugPrint('- simulationType: ${results.simulationType}');
        debugPrint('- plans count: ${results.plans.length}');
        if (results.plans.isNotEmpty) {
          debugPrint('- primer plan ID: ${results.plans.first.id}');
          debugPrint('- primer plan duración: ${results.plans.first.planDuration}');
        }
        
        final simulationData = {
          'simulation_type': 'insurance-amount',
          'parameters': {
            'age': age,
            'insurance_amount': insuranceAmount,
          },
          'plans': results.plans.map((plan) => plan.toJson()).toList(),
          'token': response.token,
          'expires_at': response.expiresAt.toIso8601String(),
        };
        
        setState(() {
          generatedToken = response.token;
          simulationResults = simulationData;
          plans = results.plans.isNotEmpty ? results.plans : _createMockPlans(age, 10, insuranceAmount * 0.01);
          showInputs = false; // Contraer inputs después de la simulación
          currentParameters = {
            'age': age,
            'insurance_amount': insuranceAmount,
          };
          isLoading = false;
        });
        
        // Debug: verificar que los planes se cargaron
        debugPrint('Planes cargados: ${plans?.length}');
        if (plans != null && plans!.isNotEmpty) {
          debugPrint('Primer plan: ${plans!.first.id}');
        }
      } else {
        setState(() => isLoading = false);
        _showError('Error al generar la simulación: ${response.message}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showError('Error al generar la simulación: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<quote.PlanOption> _createMockPlans(int age, int planDuration, double monthlySavings) {
    List<quote.PlanOption> mockPlans = [];
    
    // Generar 4 planes de ejemplo con variaciones
    for (int i = 0; i < 4; i++) {
      mockPlans.add(quote.PlanOption(
        id: 9056 + i,
        age: age,
        year: planDuration,
        ageRange: '${age - 2}-${age + 2}',
        coverageType: i == 0 ? 'Sin Cobertura' : 'Con Cobertura',
        planDuration: planDuration,
        udiValueUsed: '8.54',
        monthlySavings: monthlySavings.toStringAsFixed(2),
        primaAnualUdis: (monthlySavings * 12).toStringAsFixed(2),
        primaMensualMxn: monthlySavings * 0.99,
        udiValueAt2050: 22.77 + (i * 0.5),
        annualGrowthRate: 0.04,
        sumaAseguradaMxn: (monthlySavings * 12 * planDuration * (1.2 + i * 0.1)),
        sumaAseguradaUdis: (monthlySavings * 12 * planDuration * (1.2 + i * 0.1) / 8.54).toStringAsFixed(0),
        totalRetirar2050Mxn: (monthlySavings * 12 * planDuration * (1.8 + i * 0.2)),
        totalRetirarPlanMxn: (monthlySavings * 12 * planDuration * (1.5 + i * 0.1)),
        udiValueAtPlanYear: 12.16 + (i * 0.3),
        totalRetirar2050Udis: (monthlySavings * 12 * planDuration * (1.8 + i * 0.2) / 8.54).toStringAsFixed(0),
        totalRetirarPlanUdis: (monthlySavings * 12 * planDuration * (1.5 + i * 0.1) / 8.54).toStringAsFixed(0),
      ));
    }
    
    return mockPlans;
  }

  String _getSimulationTypeTitle(String simulationType) {
    switch (simulationType) {
      case 'monthly-savings':
        return 'Ahorro Mensual';
      case 'target-amount':
        return 'Monto Objetivo';
      case 'education':
        return 'Educación';
      case 'insurance-amount':
        return 'Suma Asegurada';
      default:
        return 'Simulación';
    }
  }

  IconData _getSimulationIcon(String simulationType) {
    switch (simulationType) {
      case 'monthly-savings':
        return Icons.savings;
      case 'target-amount':
        return Icons.flag;
      case 'education':
        return Icons.school;
      case 'insurance-amount':
        return Icons.security;
      default:
        return Icons.analytics;
    }
  }
}
