import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'constancia_screen.dart';
import '../../core/api_service.dart';
import 'package:http/http.dart' as http;

class ProfesionScreen extends StatefulWidget {
  const ProfesionScreen({super.key});

  @override
  State<ProfesionScreen> createState() => _ProfesionScreenState();
}

class _ProfesionScreenState extends State<ProfesionScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController profesionController = TextEditingController();
  final TextEditingController antiguedadController = TextEditingController();
  final TextEditingController cpController = TextEditingController();
  final TextEditingController empresaController = TextEditingController();
  final TextEditingController lugarController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController ciudadController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController descripcionLaboresController = TextEditingController();
  final TextEditingController ingresosController = TextEditingController();

  String giro = 'Salud';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Profesión u Ocupación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField('Profesión u Ocupación', profesionController),
                _buildTextField('Antigüedad en el empleo actual', antiguedadController),
                const SizedBox(height: 8),
                const Text(
                  'Giro del negocio',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textGray900,
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: giro,
                  isExpanded: true,
                  decoration: _inputDecoration(),
                  style: const TextStyle(color: AppColors.textGray900),
                  dropdownColor: const Color(0xFFF9FAFB),
                  items: const [
                    DropdownMenuItem(value: 'Salud', child: Text('Salud')),
                    DropdownMenuItem(value: 'Educación', child: Text('Educación')),
                    DropdownMenuItem(value: 'Tecnología', child: Text('Tecnología')),
                    DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      giro = value!;
                    });
                  },
                ),
                const SizedBox(height: 8),
                _buildTextField('Código Postal', cpController, keyboard: TextInputType.number),
                _buildTextField('Nombre de la empresa o dependencia', empresaController),
                _buildTextField('Lugar físico de desempeño de labores', lugarController),
                _buildTextField('Teléfono de oficina', telefonoController, keyboard: TextInputType.phone),
                _buildTextField('Ciudad', ciudadController),
                _buildTextField('Estado', estadoController),
                _buildTextField(
                  'Descripción de Labores',
                  descripcionLaboresController,
                  maxLines: 4,
                ),

                _buildTextField(
                  'Ingresos Mensuales Promedio',
                  ingresosController,
                  keyboard: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _enviarDatosProfesion();
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Continuar'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Guardar y Continuar más tarde'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        style: const TextStyle(color: AppColors.textGray900),
        decoration: _inputDecoration(label),
        validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
      ),
    );
  }

  InputDecoration _inputDecoration([String? label]) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textGray500),
      hintStyle: const TextStyle(color: AppColors.textGray400),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }

  Future<void> _enviarDatosProfesion() async {
    final fieldsOcupacion = {
      'sector': giro,
      'company_name': empresaController.text,
      'activity_detail': lugarController.text,
      'position': profesionController.text,
      'description': descripcionLaboresController.text,
      'city': ciudadController.text,
      'state': estadoController.text,
      'antiguedad_laboral': antiguedadController.text,
    };

    final fieldsIngresos = {
      'ingresos': ingresosController.text,
    };

    final responseOcupacion = await ApiService.instance.post(
      '/user/occupation',
      body: fieldsOcupacion,
    );

    final responseIngresos = await ApiService.instance.post(
      '/user/ingresos',
      body: fieldsIngresos,
    );

    if (responseOcupacion.statusCode == 200 && responseIngresos.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ConstanciaScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar la información')),
      );
      print('Ocupación: ${responseOcupacion.body}');
      print('Ingresos: ${responseIngresos.body}');
    }
  }  
}
