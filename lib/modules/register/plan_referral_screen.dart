import 'package:flutter/material.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/modules/register/plan_success_screen.dart';

class PlanReferralScreen extends StatefulWidget {
  final Map<String, dynamic> selectedPlan;
  final Map<String, dynamic> userData;

  const PlanReferralScreen({
    super.key,
    required this.selectedPlan,
    required this.userData,
  });

  @override
  State<PlanReferralScreen> createState() => _PlanReferralScreenState();
}

class _PlanReferralScreenState extends State<PlanReferralScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedOption = 'Agente Neek';
  final List<String> opciones = [
    'Agente Neek',
    'Redes Sociales',
    'Recomendación',
    'Publicidad',
    'Otro',
  ];

  final TextEditingController codigoController = TextEditingController();
  bool showValidationError = false;

  void _continuar() {
    final form = _formKey.currentState!;
    setState(() => showValidationError = false);

    if (!form.validate()) return;

    final allUserData = {
      ...widget.userData,
      'referenciaOrigen': selectedOption,
      'codigoAgente': selectedOption == 'Agente Neek'
          ? codigoController.text.trim()
          : null,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlanSuccessScreen(
          selectedPlan: widget.selectedPlan,
          userData: allUserData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '¡Estamos listos!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textGray900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Gracias por confiar en Neek, para nosotros es importante conocer cómo llegaste a nuestra plataforma.',
                      style: TextStyle(color: AppColors.textGray500),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tu respuesta nos ayuda a seguir creciendo contigo.',
                      style: TextStyle(color: AppColors.textGray500),
                    ),
                    const SizedBox(height: 24),

                    const Text('¿Cómo llegaste a Neek?', style: _labelStyle),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: selectedOption,
                      dropdownColor: Colors.white,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.textGray300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.textGray300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_drop_down),
                      items: opciones.map((opcion) {
                        return DropdownMenuItem<String>(
                          value: opcion,
                          child: Text(opcion,
                              style: const TextStyle(color: AppColors.textGray900)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                          showValidationError = false;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Selecciona una opción';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    if (selectedOption == 'Agente Neek') ...[
                      const Text('Código Agente Neek', style: _labelStyle),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: codigoController,
                        style: const TextStyle(color: AppColors.textGray900),
                        decoration: InputDecoration(
                          hintText: 'Ej. GRECIA00235',
                          hintStyle: const TextStyle(color: AppColors.textGray500),
                          filled: true,
                          fillColor: AppColors.background50,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: showValidationError
                                  ? Colors.red
                                  : AppColors.textGray300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: showValidationError
                                  ? Colors.red
                                  : AppColors.textGray300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.primary),
                          ),
                        ),
                        validator: (val) {
                          if (selectedOption == 'Agente Neek' &&
                              (val == null || val.trim().isEmpty)) {
                            setState(() => showValidationError = true);
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                    ],

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _continuar,
                        child: const Text('Continuar', style: TextStyle(fontSize: 16)),
                      ),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textGray900,
                          side: const BorderSide(color: AppColors.textGray900),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Regresar', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static const _labelStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColors.textGray900,
  );
}