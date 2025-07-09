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

  // Estado de coberturas
  bool extraSeleccionada = false;
  int? coberturaDSeleccionada;

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
      print('Duración:  [32m${selectedPlan['duracion_plan']} años [0m');
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

  void onExtraChanged(bool value) {
    setState(() {
      extraSeleccionada = value;
    });
  }

  void onCoberturaDChanged(int? value) {
    setState(() {
      coberturaDSeleccionada = value;
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
                            extraSeleccionada: extraSeleccionada,
                            coberturaDSeleccionada: coberturaDSeleccionada,
                            onExtraChanged: onExtraChanged,
                            onCoberturaDChanged: onCoberturaDChanged,
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

class PlanSummaryCard extends StatelessWidget {
  final Map<String, dynamic> planData;
  final List<int> availablePlazos;
  final List<double> availablePrimas;
  final ValueChanged<int> onPlazoChanged;
  final ValueChanged<double> onPrimaChanged;
  final TextEditingController planNameController; // 👈 nuevo
  final bool extraSeleccionada;
  final int? coberturaDSeleccionada;
  final ValueChanged<bool> onExtraChanged;
  final ValueChanged<int?> onCoberturaDChanged;

  const PlanSummaryCard({
    Key? key,
    required this.planData,
    required this.availablePlazos,
    required this.availablePrimas,
    required this.onPlazoChanged,
    required this.onPrimaChanged,
    required this.planNameController, // 👈 nuevo
    required this.extraSeleccionada,
    required this.coberturaDSeleccionada,
    required this.onExtraChanged,
    required this.onCoberturaDChanged,
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

          UdiPlanSummaryCard(
            planData: planData,
            extraSeleccionada: extraSeleccionada,
            coberturaDSeleccionada: coberturaDSeleccionada,
            onExtraChanged: onExtraChanged,
            onCoberturaDChanged: onCoberturaDChanged,
          ),
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
                    'cobertura_extra': extraSeleccionada,
                    'cobertura_d': coberturaDSeleccionada,
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
}

class Cobertura {
  final String titulo;
  final String descripcion;
  final bool incluida;
  Cobertura({required this.titulo, required this.descripcion, this.incluida = false});
}

class CoberturasSection extends StatefulWidget {
  @override
  State<CoberturasSection> createState() => _CoberturasSectionState();
}

class _CoberturasSectionState extends State<CoberturasSection> {
  // Datos de ejemplo, reemplaza por los reales si los tienes
  final List<Cobertura> coberturasIncluidas = [
    Cobertura(
      titulo: "Cobertura por Fallecimiento",
      descripcion: "La cobertura básica del seguro de vida y ahorro pagará la suma asegurada a los beneficiarios designados en la póliza al ocurrir el fallecimiento del Asegurado.",
      incluida: true,
    ),
    Cobertura(
      titulo: "Eliminación de aportaciones en caso de invalidez total y permanente (BIT)",
      descripcion: "Si durante el plazo de seguro de esta cobertura el asegurado contratante sufre invalidez total y permanente, la compañía lo eximirá del pago de primas que correspondan al riesgo de su cobertura básica que venzan después de transcurrir el período de espera de 6 meses, cancelándose los beneficios adicionales que se tengan contratados.",
      incluida: true,
    ),
    Cobertura(
      titulo: "Adelanto de Suma Asegurada al asegurado en caso de enfermedad terminal",
      descripcion: "Se pagará el 25% de la suma asegurada correspondiente a la cobertura básica de la póliza, con un límite máximo de 500 SMGMVDF.",
      incluida: true,
    ),
  ];

  final List<Cobertura> coberturasExtra = [
    Cobertura(
      titulo: "BIPA Pago de Suma Asegurada por Invalidez total y permanente",
      descripcion: "Si durante el plazo de seguro de esta cobertura el asegurado sufre invalidez total y permanente, la compañía pagará al asegurado, en una sola exhibición, la suma asegurada contratada para este beneficio inmediatamente después de transcurrir el período de espera de 6 meses. La suma asegurada se pagará en una sola exhibición, después de haberse comprobado el estado de invalidez del Asegurado.",
    ),
  ];

  final List<Cobertura> coberturasD = [
    Cobertura(
      titulo: "DI1 Doble indemnización por muerte accidental",
      descripcion: "La Compañía pagará la suma asegurada contratada en esta cobertura, en caso de que el asegurado sufra un accidente durante la vigencia de la póliza, mismo que le causa la muerte.",
    ),
    Cobertura(
      titulo: "DI2 Indemnización por muerte accidental ó pérdida de miembros.",
      descripcion: "DI1 + Pago de suma asegurada por pérdida de miembros. Las lesiones se pagarán de acuerdo a la escala elegida (\"Escala A\" o \"Escala B\") conforme a lo indicado en la tabla de indemnización correspondiente.",
    ),
    Cobertura(
      titulo: "DI3 Indemnización por muerte ó pérdida de miembros colectiva",
      descripcion: "DI2 + Muerte colectiva. Solo se duplicará si el accidente que les dio origen ocurre: Mientras viaje como pasajero en cualquier vehículo público, con pago de pasaje, sobre una ruta establecida normalmente para ruta de pasajeros y sujeta a itinerarios regulares o mientras se encuentre en un ascensor que opere para servicio público.",
    ),
  ];

  bool extraSeleccionada = false;
  int? coberturaDSeleccionada;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Coberturas Incluidas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        ...coberturasIncluidas.map(_buildCoberturaCard),
        const SizedBox(height: 16),
        const Text("Coberturas Extra", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const Text("Puedes seleccionar la siguiente cobertura", style: TextStyle(fontSize: 12, color: AppColors.textGray400)),
        ...coberturasExtra.asMap().entries.map((entry) => _buildCoberturaExtraCard(entry.key, entry.value)),
        const SizedBox(height: 16),
        const Text("Coberturas D", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const Text("Puedes añadir una de las siguientes 3", style: TextStyle(fontSize: 12, color: AppColors.textGray400)),
        ...coberturasD.asMap().entries.map((entry) => _buildCoberturaDCard(entry.key, entry.value)),
      ],
    );
  }

  Widget _buildCoberturaCard(Cobertura c) => Card(
    margin: const EdgeInsets.symmetric(vertical: 4),
    child: ListTile(
      leading: const Icon(Icons.info_outline, color: AppColors.primary),
      title: Text(c.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(c.descripcion),
    ),
  );

  Widget _buildCoberturaExtraCard(int idx, Cobertura c) => Card(
    margin: const EdgeInsets.symmetric(vertical: 4),
    child: SwitchListTile(
      value: extraSeleccionada,
      onChanged: (val) => setState(() => extraSeleccionada = val),
      title: Text(c.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(c.descripcion),
      activeColor: AppColors.primary,
    ),
  );

  Widget _buildCoberturaDCard(int idx, Cobertura c) => Card(
    margin: const EdgeInsets.symmetric(vertical: 4),
    child: RadioListTile<int>(
      value: idx,
      groupValue: coberturaDSeleccionada,
      onChanged: (val) => setState(() => coberturaDSeleccionada = val),
      title: Text(c.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(c.descripcion),
      activeColor: AppColors.primary,
    ),
  );
}
