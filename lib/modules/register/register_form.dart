import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/modules/register/plan_register_screen.dart';
import 'package:neek/shared/cards/register_card.dart';
import 'package:neek/shared/tables/udi_plan_summary_card.dart'; // <-- NUEVO

class PlanSummaryScreen extends StatefulWidget {
  const PlanSummaryScreen({super.key});

  @override
  State<PlanSummaryScreen> createState() => _PlanSummaryScreenState();
}

class _PlanSummaryScreenState extends State<PlanSummaryScreen> {
  List<dynamic> allPlans = [];
  dynamic selectedPlan;
  int selectedPlazo = 10;
  double? selectedPrimaAnual;
  bool isLoading = true;
  final TextEditingController _planNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchPlans();
  }
  @override
  void dispose() {
    _planNameController.dispose();
    super.dispose();
  }
  Future<void> fetchPlans() async {
    final response = await http.get(Uri.parse('https://app.neek.mx/api/getPlans'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        allPlans = data['planes'];
        final primas = _getPrimasAnuales(selectedPlazo);
        selectedPrimaAnual = primas.isNotEmpty ? primas.first : null;
        _filterPlan();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterPlan() {
    selectedPlan = allPlans.firstWhere(
      (plan) =>
          plan['duracion_plan'] == selectedPlazo &&
          double.tryParse(plan['prima_anual_pesos']) == selectedPrimaAnual,
      orElse: () => null,
    );

    // Prints for debugging
    if (selectedPlan != null) {
      print('🟢 Plan seleccionado:');
      print('Duración: ${selectedPlan['duracion_plan']} años');
      print('Prima anual: ${selectedPlan['prima_anual_pesos']}');
      print('Prima mensual: ${selectedPlan['prima_mensual_pesos']}');
    } else {
      print('🔴 No se encontró un plan con duración $selectedPlazo y prima anual $selectedPrimaAnual');
    }
  }

  List<int> get availablePlazos {
    return allPlans.map((p) => p['duracion_plan'] as int).toSet().toList()..sort();
  }

  List<double> _getPrimasAnuales(int plazo) {
    return allPlans
        .where((p) => p['duracion_plan'] == plazo)
        .map((p) => double.tryParse(p['prima_anual_pesos']))
        .whereType<double>()
        .toSet()
        .toList()
      ..sort();
  }

  void onPlazoChanged(int val) {
    final primas = _getPrimasAnuales(val);
    setState(() {
      selectedPlazo = val;
      selectedPrimaAnual = primas.isNotEmpty ? primas.first : null;
      _filterPlan();
    });
  }

  void onPrimaChanged(double val) {
    setState(() {
      selectedPrimaAnual = val;
      _filterPlan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(title: const Text('Resumen de Plan')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _formFieldDropdown<int>(
                          label: 'Plazo del ahorro',
                          currentValue: selectedPlazo,
                          items: availablePlazos,
                          onChanged: onPlazoChanged,
                          displayText: (val) => '$val años',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _formFieldDropdown<double>(
                          label: 'Ahorro anual',
                          currentValue: selectedPrimaAnual ?? 0,
                          items: _getPrimasAnuales(selectedPlazo),
                          onChanged: onPrimaChanged,
                          displayText: (val) => NumberFormat.currency(locale: 'es_MX', symbol: 'MXN').format(val),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: selectedPlan == null
                        ? const Text('No hay plan con esta configuración.')
                        : PlanSummaryCard(
                            planData: selectedPlan,
                            availablePlazos: availablePlazos,
                            availablePrimas: _getPrimasAnuales(selectedPlazo),
                            onPlazoChanged: onPlazoChanged,
                            onPrimaChanged: onPrimaChanged,
                            planNameController: _planNameController, // 👈 agregado
                          ),
                  ),
                ),
              ],
            ),
    );
  }
}

class PlanSummaryCard extends StatelessWidget {
  final Map<String, dynamic> planData;
  final List<int> availablePlazos;
  final List<double> availablePrimas;
  final ValueChanged<int> onPlazoChanged;
  final ValueChanged<double> onPrimaChanged;
  final TextEditingController planNameController; // 👈 nuevo

  const PlanSummaryCard({
    Key? key,
    required this.planData,
    required this.availablePlazos,
    required this.availablePrimas,
    required this.onPlazoChanged,
    required this.onPrimaChanged,
    required this.planNameController, // 👈 nuevo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'es_MX', symbol: 'MXN');
    final duracion = planData['duracion_plan'] as int;
    final primaAnual = double.tryParse(planData['prima_anual_pesos']) ?? 0;
    final sumaAsegurada = double.tryParse(planData['seguro_vida_proteccion']) ?? 0;

    // Generar lista dinámica de retiros
    final retiros = planData.entries
        .where((e) => e.key.startsWith('retira_') && e.value != null)
        .map((e) => MapEntry(int.parse(e.key.split('_')[1]), double.parse(e.value)))
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          RegisterCard(controller: planNameController),    
          const SizedBox(height: 20),

          UdiPlanSummaryCard(planData: planData),
          const SizedBox(height: 24),
          const Text(
            'Revisa tu cotización para más información detallada. Los valores pueden variar con préstamos o abonos.',
            style: TextStyle(fontSize: 10, color: AppColors.textGray400),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  final nombrePlan = planNameController.text.trim();

                  final userData = {
                    'plazo_ahorro': planData['duracion_plan'],
                    'ahorro_mensual': planData['prima_mensual_pesos'],
                    'nombre_proyecto': nombrePlan.isNotEmpty ? nombrePlan : 'Mi plan de ahorro',
                  };

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlanRegisterScreen(
                        userData: userData,
                      ),
                    ),
                  );
                },
                child: const Text('Continuar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),          
        ],
      ),
    );
  }

  Widget _formFieldDropdown<T>({
    required String label,
    required T currentValue,
    required List<T> items,
    required ValueChanged<T> onChanged,
    required String Function(T) displayText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textGray900)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.background50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.textGray300, width: 1.0),
          ),
          child: DropdownButton<T>(
            value: currentValue,
            isExpanded: true,
            underline: const SizedBox(),
            onChanged: (val) {
              if (val != null) onChanged(val);
            },
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(displayText(item)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

  Widget _formFieldDropdown<T>({
    required String label,
    required T currentValue,
    required List<T> items,
    required void Function(T) onChanged,
    required String Function(T) displayText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textGray900)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.background50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.textGray300, width: 1.0),
          ),
          child: DropdownButton<T>(
            value: currentValue,
            isExpanded: true,
            underline: const SizedBox(),
            onChanged: (val) {
              if (val != null) onChanged(val);
            },
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(displayText(item)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
