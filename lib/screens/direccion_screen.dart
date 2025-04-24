import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../core/theme/app_colors.dart';
import 'profesion_screen.dart'; // ajusta la ruta si está en otra carpeta
import '../core/api_service.dart';
import 'package:http/http.dart' as http;

class DireccionScreen extends StatefulWidget {
  const DireccionScreen({super.key});

  @override
  State<DireccionScreen> createState() => _DireccionScreenState();
}

class _DireccionScreenState extends State<DireccionScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController calleController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController coloniaController = TextEditingController();
  final TextEditingController cpController = TextEditingController();
  final TextEditingController ciudadController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController paisController = TextEditingController(text: 'México');

  String relacion = 'Propio';
  File? comprobanteDomicilio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111928), // Fondo oscuro
      appBar: AppBar(
        backgroundColor: const Color(0xFF111928),
        title: const Text('Domicilio'),
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
                _buildTextField('Calle', calleController),
                _buildTextField('Número exterior', numeroController),
                _buildTextField('Colonia', coloniaController),
                _buildTextField('Código Postal', cpController, keyboard: TextInputType.number),
                _buildTextField('Ciudad', ciudadController),
                _buildTextField('Estado', estadoController),
                _buildTextField('País', paisController),
                const SizedBox(height: 16),
                Text(
                  'Relación del comprobante de domicilio',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textGray900,
                  ),
                ),

                DropdownButtonFormField<String>(
                  value: relacion,
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF9FAFB), // Fondo gris claro
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFD1D5DB)), // Borde gris 300
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                  style: const TextStyle(color: AppColors.textGray900),
                  dropdownColor: Color(0xFFF9FAFB), // Fondo del menú desplegable
                  items: const [
                    DropdownMenuItem(value: 'Propio', child: Text('Propio')),
                    DropdownMenuItem(value: 'Familiar', child: Text('Familiar')),
                    DropdownMenuItem(value: 'Renta', child: Text('Renta')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      relacion = value!;
                    });
                  },
                ),


                const SizedBox(height: 16),
                DottedBorderBox(onTap: _pickComprobante),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final isValid = _formKey.currentState?.validate() ?? false;
                    if (isValid) {
                      _subirDireccion();
                    }
                  },


                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B5FF3),
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

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        style: const TextStyle(color: AppColors.textGray900), // Texto ingresado
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textGray500), // Label del campo
          hintStyle: const TextStyle(color: AppColors.textGray400),
          filled: true,
          fillColor: Color(0xFFF9FAFB), // 👈 Fondo gris claro
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)), // gray-300
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary),
          ),

        ),
        validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
      ),
    );
  }
  Future<void> _pickComprobante() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) {
      setState(() {
        comprobanteDomicilio = File(picked.path);
      });
    }
  }

  Future<void> _subirDireccion() async {
    if (comprobanteDomicilio == null) return;

    final requestFile = await http.MultipartFile.fromPath('comprobante', comprobanteDomicilio!.path);

    final fields = {
      'street': calleController.text,
      'ext_number': numeroController.text,
      'suburb': coloniaController.text,
      'zip_code': cpController.text,
      'city': ciudadController.text,
      'state': estadoController.text,
      'country': paisController.text,
      'tipo_vivienda': relacion,
    };

    final response = await ApiService.instance.postMultipart(
      path: '/user/address',
      fields: fields,
      files: [requestFile],
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfesionScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al subir la dirección')),
      );
      
        print('Error: ${response.body}');
    }
  }


}

class DottedBorderBox extends StatelessWidget {
  final VoidCallback onTap;

  const DottedBorderBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            const Icon(Icons.upload_file, size: 40, color: Colors.black),
            SizedBox(height: 8),
            Text(
              'Haz click para subir la imagen\n o busca el archivo en tu dispositivo',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}


