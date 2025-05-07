import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import 'verificacion_completada_screen.dart';
import '../../core/api_service.dart';
import 'package:http/http.dart' as http;

class ConstanciaScreen extends StatefulWidget {
  const ConstanciaScreen({super.key});

  @override
  State<ConstanciaScreen> createState() => _ConstanciaScreenState();
}

class _ConstanciaScreenState extends State<ConstanciaScreen> {
  File? _constancia;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFile() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) {
      setState(() {
        _constancia = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Constancia de Situación Fiscal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Constancia de Situación Fiscal',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.textGray900,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.textGray300),
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.cloud_upload_outlined, size: 40),
                      SizedBox(height: 8),
                      Text(
                        'Haz click para subir la imagen\n o busca el archivo en tu dispositivo',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textGray900),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Recuerda que la imagen debe ser clara y legible, utiliza buena iluminación y un fondo neutral.\n\nArchivos compatibles JPG o PNG\nTamaño máximo del archivo 30 MB',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: AppColors.textGray500),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_constancia != null)
                Row(
                  children: [
                    const Icon(Icons.insert_drive_file_outlined, color: AppColors.textGray500),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _constancia!.path.split('/').last,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const Icon(Icons.check_circle, color: Colors.green),
                  ],
                ),
              const Spacer(),
              ElevatedButton(
                onPressed: _constancia != null ? _subirConstancia : null,

                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey.shade400;
                    }
                    return AppColors.primary;
                  }),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                ),
                child: const Center(child: Text('Finalizar verificación')),
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
    );
  }

  Future<void> _subirConstancia() async {
    if (_constancia == null) return;

    try {
      final file = await http.MultipartFile.fromPath('constancia', _constancia!.path);

      final response = await ApiService.instance.postMultipart(
        path: '/user/constancia',
        fields: {}, // Puedes incluir campos adicionales si es necesario
        files: [file],
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VerificacionCompletadaScreen()),
        );
      } else {
        print('❌ Error: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al subir la constancia')),
        );
      }
    } catch (e) {
      print('❌ Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error: $e')),
      );
    }
  }

}
