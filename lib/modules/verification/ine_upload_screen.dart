import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../core/theme/app_colors.dart';
import 'direccion_screen.dart';
import '../../core/api_service.dart';
import 'package:http/http.dart' as http;

class INEUploadScreen extends StatefulWidget {
  const INEUploadScreen({super.key});

  @override
  State<INEUploadScreen> createState() => _INEUploadScreenState();
}

class _INEUploadScreenState extends State<INEUploadScreen> {
  File? _ineFrente;
  File? _ineReverso;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool isFrente) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Tomar foto'),
              onTap: () async {
                Navigator.pop(context); // Cierra el modal
                final picked = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
                _setPickedImage(picked, isFrente);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Seleccionar de galería'),
              onTap: () async {
                Navigator.pop(context); // Cierra el modal
                final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
                _setPickedImage(picked, isFrente);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _setPickedImage(XFile? picked, bool isFrente) {
    if (picked != null) {
      setState(() {
        if (isFrente) {
          _ineFrente = File(picked.path);
        } else {
          _ineReverso = File(picked.path);
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    bool ambosSubidos = _ineFrente != null && _ineReverso != null;

  return Scaffold(
    backgroundColor: AppColors.background, // Fondo general
    appBar: AppBar(title: const Text('Subir INE')),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
            _buildUploader(
              title: 'INE FRENTE',
              file: _ineFrente,
              onTap: () => _pickImage(true),
            ),
            const SizedBox(height: 20),
            _buildUploader(
              title: 'INE Reverso',
              file: _ineReverso,
              onTap: () => _pickImage(false),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: ambosSubidos ? _subirINEs : null,
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 16),
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.grey.shade400;
                  }
                  return Theme.of(context).primaryColor;
                }),
                foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.white70;
                  }
                  return Colors.white;
                }),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Más redondeado
                  ),
                ),
              ),
              child: const Center(child: Text('Continuar')),
            ),


            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Guardar y Continuar más tarde'),
            ),
          ],
        ),
      ),
    ),
  );

  }

  Widget _buildUploader({
    required String title,
    required File? file,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: file == null
              ? GestureDetector(
                  onTap: onTap,
                  child: Column(
                    children: [
                      const Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.black),
                      const SizedBox(height: 8),
                      Text(
                        'Haz click para subir la imagen\n o busca el archivo en tu dispositivo',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            file.path.split('/').last,
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.check_circle, color: Colors.green),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            if (title.toLowerCase().contains('frente')) {
                              _ineFrente = null;
                            } else {
                              _ineReverso = null;
                            }
                          });
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Eliminar archivo'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }


  void _confirmar() {
    // Aquí podrías enviar los archivos o ir a otra pantalla
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Documentos cargados correctamente')),
    );
  }

  Future<void> _subirINEs() async {
    if (_ineFrente == null || _ineReverso == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faltan archivos por cargar')),
      );
      return;
    }

    try {
      final files = [
        await http.MultipartFile.fromPath('ine_frente', _ineFrente!.path),
        await http.MultipartFile.fromPath('ine_reverso', _ineReverso!.path),
      ];

      final response = await ApiService.instance.postMultipart(
        path: '/user/ine',
        fields: {},
        files: files,
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DireccionScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al subir los archivos')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error: $e')),
      );
    }
  }


}
