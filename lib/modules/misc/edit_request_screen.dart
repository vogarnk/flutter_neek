import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/change_request_service.dart';

class EditRequestScreen extends StatefulWidget {
  const EditRequestScreen({super.key});

  @override
  State<EditRequestScreen> createState() => _EditRequestScreenState();
}

class _EditRequestScreenState extends State<EditRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  
  String? _selectedDataType;
  String? _selectedTipoSolicitud;
  File? _selectedFile;
  bool _isLoading = false;
  
  final ChangeRequestService _changeRequestService = ChangeRequestService.instance;

  final List<Map<String, String>> _dataTypes = [
    {'value': 'correo', 'label': 'Correo'},
    {'value': 'nombre', 'label': 'Nombre'},
    {'value': 'telefono', 'label': 'Teléfono'},
    {'value': 'direccion', 'label': 'Dirección'},
    {'value': 'fecha_nacimiento', 'label': 'Fecha de nacimiento'},
    {'value': 'rfc', 'label': 'RFC'},
    {'value': 'curp', 'label': 'CURP'},
    {'value': 'estado_civil', 'label': 'Estado civil'},
    {'value': 'beneficiarios', 'label': 'Beneficiarios'},
    {'value': 'otro', 'label': 'Otro'},
  ];

  final List<Map<String, String>> _tipoSolicitud = [
    {'value': 'datos_personales', 'label': 'Datos Personales'},
    {'value': 'documentos', 'label': 'Documentos'},
    {'value': 'plan', 'label': 'Plan'},
    {'value': 'beneficiarios', 'label': 'Beneficiarios'},
    {'value': 'otro', 'label': 'Otro'},
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  /// Selecciona un archivo desde el dispositivo
  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        
        // Verificar tamaño del archivo (máximo 10MB)
        final fileSize = await file.length();
        if (fileSize > 10 * 1024 * 1024) {
          _showErrorDialog('El archivo es demasiado grande. El tamaño máximo permitido es 10MB.');
          return;
        }

        setState(() {
          _selectedFile = file;
        });
      }
    } catch (e) {
      _showErrorDialog('Error al seleccionar el archivo: ${e.toString()}');
    }
  }

  /// Envía la solicitud de cambio
  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _changeRequestService.createChangeRequest(
        dataToModify: _selectedDataType!,
        problemDescription: _descriptionController.text.trim(),
        tipoSolicitud: _selectedTipoSolicitud!,
        file: _selectedFile,
      );

      if (result['success'] == true) {
        _showSuccessDialog();
        _clearForm();
      } else {
        _showErrorDialog(result['message'] ?? 'Error al enviar la solicitud');
      }
    } catch (e) {
      _showErrorDialog('Error inesperado: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Limpia el formulario después del envío exitoso
  void _clearForm() {
    setState(() {
      _selectedDataType = null;
      _selectedTipoSolicitud = null;
      _selectedFile = null;
      _descriptionController.clear();
    });
  }

  /// Muestra un diálogo de éxito
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¡Solicitud enviada!'),
        content: const Text('Tu solicitud de cambio ha sido enviada exitosamente. Te notificaremos sobre el estado de tu solicitud.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Regresar a la pantalla anterior
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  /// Muestra un diálogo de error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1320),
      appBar: AppBar(
        title: const Text('Solicitud de Cambio'),
        backgroundColor: const Color(0xFF0E1320),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Solicitud de cambio de datos',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,                  
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '¿Qué te gustaría cambiar?',
                  style: TextStyle(
                    color: Colors.black87,
                  )
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedDataType,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  items: _dataTypes.map((item) => DropdownMenuItem(
                    value: item['value'],
                    child: Text(item['label']!),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDataType = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  hint: Text(
                    'Selecciona un dato',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor selecciona un dato';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Tipo de solicitud',
                  style: TextStyle(
                    color: Colors.black87,
                  )
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedTipoSolicitud,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  items: _tipoSolicitud.map((item) => DropdownMenuItem(
                    value: item['value'],
                    child: Text(item['label']!),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTipoSolicitud = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  hint: Text(
                    'Selecciona el tipo',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor selecciona el tipo de solicitud';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Describe aquí que te gustaria cambiar',
                  style: TextStyle(
                    color: Colors.black87,
                  )
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                  ),
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Escribe aquí...',
                    hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 1.5,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor describe el cambio solicitado';
                    }
                    if (value.trim().length < 10) {
                      return 'La descripción debe tener al menos 10 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _pickFile,
                  icon: const Icon(Icons.upload),
                  label: Text(_selectedFile != null ? 'Archivo seleccionado' : 'Subir imagen o archivo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedFile != null ? Colors.green : const Color(0xFF2B5FF3),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                if (_selectedFile != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.attach_file, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _selectedFile!.path.split('/').last,
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedFile = null;
                            });
                          },
                          icon: Icon(Icons.close, color: Colors.green.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                    children: [
                      const TextSpan(
                        text: 'Tu información está protegida, para más información puedes leer nuestro ',
                      ),
                      TextSpan(
                        text: 'Aviso de Privacidad',
                        style: const TextStyle(
                          color: Color(0xFF2B5FF3),
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Abrir enlace de privacidad
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2B5FF3),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading 
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Enviar solicitud'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}