import 'package:flutter/material.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/modules/register/plan_verification_screen.dart';

class PlanInfoScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const PlanInfoScreen({
    super.key,
    required this.userData,
  });

  @override
  State<PlanInfoScreen> createState() => _PlanInfoScreenState();
}

class _PlanInfoScreenState extends State<PlanInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _name1Controller = TextEditingController();
  final TextEditingController _name2Controller = TextEditingController();
  final TextEditingController _lastName1Controller = TextEditingController();
  final TextEditingController _lastName2Controller = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  DateTime? selectedDate;
  String genero = 'Femenino';
  String salud = 'Excelente';
  String fumador = 'No';

  void _continue() {
    if (_formKey.currentState!.validate()) {
      final personalData = {
        ...widget.userData,
        'primer_nombre': _name1Controller.text.trim(),
        'segundo_nombre': _name2Controller.text.trim(),
        'apellido_paterno': _lastName1Controller.text.trim(),
        'apellido_materno': _lastName2Controller.text.trim(),
        'dia': selectedDate?.day,
        'mes': selectedDate?.month,
        'year': selectedDate?.year,
        'genero': genero.toLowerCase(), // 👈 en minúsculas
        'estado_salud': _mapSaludToEnglish(salud), // 👈 traducido a inglés
        'fumador': fumador == 'Sí' ? 'yes' : 'no',
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlanVerificationScreen(
            userData: personalData,
          ),
        ),
      );
    }
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
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Continuemos por conocerte',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textGray900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Completa tus datos personales para poder generar tu cotización personalizada.\n\nEste paso es clave para ofrecerte un plan ajustado a tus necesidades y asegurarte la mejor protección.',
                      style: TextStyle(fontSize: 14, color: AppColors.textGray500),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(child: _inputLabel('Primer Nombre', _name1Controller)),
                        const SizedBox(width: 12),
                        Expanded(child: _inputLabel('Segundo Nombre', _name2Controller)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(child: _inputLabel('Apellido paterno', _lastName1Controller)),
                        const SizedBox(width: 12),
                        Expanded(child: _inputLabel('Apellido materno', _lastName2Controller)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    const Text('¿Cuál es tu fecha de nacimiento?', style: _labelStyle),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: _inputField(
                          controller: _birthDateController,
                          hint: 'DD/MM/YYYY',
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text('Género', style: _labelStyle),
                    Row(
                      children: [
                        _radioOption('Femenino', genero, (val) => setState(() => genero = val)),
                        _radioOption('Masculino', genero, (val) => setState(() => genero = val)),
                      ],
                    ),
                    const Divider(height: 32),

                    const Text('Estado de Salud', style: _labelStyle),
                    Wrap(
                      spacing: 12,
                      children: [
                        _radioOption('Malo', salud, (val) => setState(() => salud = val)),
                        _radioOption('Regular', salud, (val) => setState(() => salud = val)),
                        _radioOption('Excelente', salud, (val) => setState(() => salud = val)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    const Text('¿Eres fumador?', style: _labelStyle),
                    Wrap(
                      spacing: 12,
                      children: [
                        _radioOption('Sí', fumador, (val) => setState(() => fumador = val)),
                        _radioOption('No', fumador, (val) => setState(() => fumador = val)),
                      ],
                    ),
                    const Divider(height: 32),

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
                        onPressed: _continue,
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

  Widget _inputLabel(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle),
        const SizedBox(height: 6),
        _inputField(controller: controller),
      ],
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    String? hint,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: (val) => val == null || val.trim().isEmpty ? 'Requerido' : null,
      style: const TextStyle(color: AppColors.textGray900),
      decoration: InputDecoration(
        hintText: hint ?? '',
        hintStyle: const TextStyle(color: AppColors.textGray500),
        filled: true,
        fillColor: AppColors.background50,
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
    );
  }

  Widget _radioOption(String text, String groupValue, ValueChanged<String> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: text,
          groupValue: groupValue,
          activeColor: AppColors.primary,
          onChanged: (val) => onChanged(val!),
        ),
        Text(text, style: const TextStyle(color: AppColors.textGray900)),
      ],
    );
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime maxDate = DateTime(today.year - 18, today.month, today.day);
    final DateTime firstDate = DateTime(1900);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: maxDate,
      firstDate: firstDate,
      lastDate: maxDate,
      locale: const Locale('es', 'MX'),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _birthDateController.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }  
  String _mapSaludToEnglish(String valor) {
    switch (valor) {
      case 'Excelente':
        return 'excelente';
      case 'Regular':
        return 'regular';
      case 'Malo':
        return 'mal';
      default:
        return 'unknown';
    }
  }  
}