import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../core/beneficiario_service.dart';

class CreateBeneficiaryScreen extends StatefulWidget {
  final int? userPlanId;
  
  const CreateBeneficiaryScreen({
    super.key,
    this.userPlanId,
  });

  @override
  State<CreateBeneficiaryScreen> createState() => _CreateBeneficiaryScreenState();
}

class _CreateBeneficiaryScreenState extends State<CreateBeneficiaryScreen> {
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController segundoNombreController = TextEditingController();
  final TextEditingController apellidoPaternoController = TextEditingController();
  final TextEditingController apellidoMaternoController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController parentescoController = TextEditingController();
  final TextEditingController ocupacionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController calleController = TextEditingController();
  final TextEditingController coloniaController = TextEditingController();
  final TextEditingController cpController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController numeroExtController = TextEditingController();
  final TextEditingController numeroIntController = TextEditingController();
  final TextEditingController ciudadController = TextEditingController();
  final TextEditingController paisController = TextEditingController(text: 'México');
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _tutorDobController = TextEditingController(); // 👈 Agregar controlador para tutor

  double porcentaje = 25;
  String tipoBeneficiario = 'Tradicional';
  String categoria = 'basico'; // Cambiar a minúsculas para coincidir con el factory
  bool mismoDomicilio = true;
  bool tutorRequerido = false;
  bool isLoading = false;
  DateTime? _selectedDate;
  DateTime? _tutorSelectedDate; // 👈 Agregar fecha del tutor
  File? _selectedFile; // 👈 Archivo INE seleccionado
  String? _fileName; // 👈 Nombre del archivo

  // Dropdowns Parentesco/Ocupación
  String? parentescoSeleccionado;
  String? ocupacionSeleccionada;
  bool mostrarParentescoOtro = false;
  bool mostrarOcupacionOtro = false;
  final TextEditingController parentescoOtroController = TextEditingController();
  final TextEditingController ocupacionOtroController = TextEditingController();

  final List<String> opcionesParentesco = <String>[
    'Cónyuge',
    'Hijo/a',
    'Padre',
    'Madre',
    'Hermano/a',
    'Abuelo/a',
    'Nieto/a',
    'Tío/a',
    'Sobrino/a',
    'Primo/a',
    'Otro',
  ];

  final List<String> opcionesOcupacion = <String>[
    'Estudiante',
    'Empleado/a',
    'Profesionista',
    'Comerciante',
    'Empresario/a',
    'Jubilado/a',
    'Ama de casa',
    'Desempleado/a',
    'Otro',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Añadir beneficiario'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Agregar nuevo beneficiario'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _textField('Luis', controller: nombresController)),
                      const SizedBox(width: 12),
                      Expanded(child: _textField('Ernesto', controller: segundoNombreController)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _textField('Garcia', controller: apellidoPaternoController)),
                      const SizedBox(width: 12),
                      Expanded(child: _textField('Sánchez', controller: apellidoMaternoController)),
                    ],
                  ),
                ],
              ),
              _dobField(context),
              _parentescoDropdown(),
              _textField('Email', controller: emailController),
              _ocupacionDropdown(),
              const SizedBox(height: 8),
              const Text('Porcentaje', style: TextStyle(color: Colors.black)),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: porcentaje,
                      min: 0,
                      max: 100,
                      divisions: 20,
                      label: '${porcentaje.toInt()}%',
                      onChanged: (val) => setState(() => porcentaje = val),
                    ),
                  ),
                  Text('${porcentaje.toInt()}%', style: const TextStyle(color: Colors.black)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text('Tipo de beneficiario', style: TextStyle(color: Colors.black)),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _showBeneficiaryTypeInfo(context),
                    child: const Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _radioOption('Tradicional', tipoBeneficiario, (val) => setState(() => tipoBeneficiario = val!)),
                  const SizedBox(width: 16),
                  _radioOption('Intermedio', tipoBeneficiario, (val) => setState(() => tipoBeneficiario = val!)),
                ],
              ),
              _sectionTitle('Domicilio del beneficiario'),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: mismoDomicilio,
                onChanged: (val) => setState(() => mismoDomicilio = val ?? false),
                title: const Text('Es el mismo que el del asegurado', style: TextStyle(color: Colors.black)),
              ),
              if (!mismoDomicilio) ...[
                _textField('Calle', controller: calleController),
                _textField('Colonia', controller: coloniaController),
                _textField('Código Postal', controller: cpController),
                _textField('Estado', controller: estadoController),
                _textField('Número Exterior', controller: numeroExtController),
                _textField('Número Interior (opcional)', controller: numeroIntController),
                _textField('Ciudad', controller: ciudadController),
                _textField('País', controller: paisController),
              ],
                             _sectionTitle('INE del Beneficiario'),
               _fileUploaderWidget(),
              _sectionTitle('Categoría de acceso a la información'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _radioOption('basico', categoria, (val) => setState(() => categoria = val!)),
                  _radioOption('intermedio', categoria, (val) => setState(() => categoria = val!)),
                  _radioOption('avanzado', categoria, (val) => setState(() => categoria = val!)),
                ],
              ),
              if (_selectedDate != null) ...[
                _sectionTitle('Tutor del Beneficiario'),
                Text('Debug: Edad = ${_calculateAge(_selectedDate!)} años'), // 👈 Debug temporal
                if (_isMinor(_selectedDate!)) ...[
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: tutorRequerido,
                    onChanged: (val) => setState(() => tutorRequerido = val ?? false),
                    title: const Text('Es el mismo que el del asegurado', style: TextStyle(color: Colors.black)),
                  ),
                  if (tutorRequerido) ...[
                    _textField('Nombre Completo'),
                    _dobField(context, isTutor: true),
                    _textField('Parentesco'),
                    _textField('Ocupación'),
                    _textField('Calle'),
                    _textField('Colonia'),
                  ],
                ] else ...[
                  const Text(
                    'El beneficiario es mayor de edad, no requiere tutor',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _guardarBeneficiario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: isLoading 
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Guardar beneficiario'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      );

  Widget _textField(String label, {TextEditingController? controller}) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD6DADF)),
            ),
          ),
        ),
      );

  Widget _parentescoDropdown() => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: parentescoSeleccionado,
              decoration: InputDecoration(
                labelText: 'Parentesco',
                labelStyle: const TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD6DADF)),
                ),
              ),
              items: opcionesParentesco.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  parentescoSeleccionado = newValue;
                  mostrarParentescoOtro = newValue == 'Otro';
                  if (newValue != 'Otro') {
                    parentescoOtroController.clear();
                  }
                });
              },
            ),
            if (mostrarParentescoOtro)
              const SizedBox(height: 8),
            if (mostrarParentescoOtro)
              TextField(
                controller: parentescoOtroController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Especificar parentesco',
                  labelStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD6DADF)),
                  ),
                ),
              ),
          ],
        ),
      );

  Widget _ocupacionDropdown() => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: ocupacionSeleccionada,
              decoration: InputDecoration(
                labelText: 'Ocupación',
                labelStyle: const TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD6DADF)),
                ),
              ),
              items: opcionesOcupacion.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  ocupacionSeleccionada = newValue;
                  mostrarOcupacionOtro = newValue == 'Otro';
                  if (newValue != 'Otro') {
                    ocupacionOtroController.clear();
                  }
                });
              },
            ),
            if (mostrarOcupacionOtro)
              const SizedBox(height: 8),
            if (mostrarOcupacionOtro)
              TextField(
                controller: ocupacionOtroController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Especificar ocupación',
                  labelStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD6DADF)),
                  ),
                ),
              ),
          ],
        ),
      );

  Widget _dobField(BuildContext context, {bool isTutor = false}) {
    return TextFormField(
      controller: isTutor ? _tutorDobController : _dobController, // 👈 Usar el controlador correcto
      readOnly: true,
      style: const TextStyle(color: Colors.black),
      onTap: () async {
        final now = DateTime.now();
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: isTutor ? DateTime(now.year - 25) : DateTime(now.year - 18),
          firstDate: DateTime(1900),
          lastDate: now,
          locale: const Locale('es', 'MX'),
        );
        if (picked != null) {
          if (isTutor) {
            // Para tutor, validar que sea mayor de edad
            if (_isMinor(picked)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('El tutor debe ser mayor de edad'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            _tutorSelectedDate = picked; // 👈 Guardar fecha del tutor
          } else {
            // Para beneficiario, actualizar la fecha seleccionada
            _selectedDate = picked;
            setState(() {}); // 👈 Forzar rebuild para mostrar/ocultar sección de tutor
          }
          final controller = isTutor ? _tutorDobController : _dobController;
          controller.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
        }
      },
      decoration: InputDecoration(
        labelText: isTutor ? 'Fecha de nacimiento del tutor' : 'Fecha de nacimiento',
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
    );
  }

Widget _radioOption(String label, String groupValue, Function(String?) onChanged) {
  // Mapear valores internos a etiquetas de visualización
  String displayLabel = label;
  if (label == 'basico') displayLabel = 'Básico';
  if (label == 'intermedio') displayLabel = 'Intermedio';
  if (label == 'avanzado') displayLabel = 'Avanzado';
  
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Radio<String>(
        value: label,
        groupValue: groupValue,
        onChanged: onChanged,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      Text(
        displayLabel,
        style: const TextStyle(color: Colors.black, fontSize: 13),
      ),
    ],
  );
}

  void _showBeneficiaryTypeInfo(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.background, // 👈 Usar AppColors.background
                  AppColors.contrastBackground, // 👈 Usar AppColors.contrastBackground
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                const Text(
                  '¿Qué es un beneficiario?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textWhite, // 👈 Usar AppColors.textWhite
                  ),
                ),
                const SizedBox(height: 16),
                
                // Descripción
                const Text(
                  'Un beneficiario es la persona que el "Asegurado" selecciona en caso de hacer valida la cobertura básica. Neek te ofrece personalizar el nivel de acceso a la información de tu seguro.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textWhite, // 👈 Usar AppColors.textWhite
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Subtítulo
                const Text(
                  'Tipo de beneficiario',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textWhite, // 👈 Usar AppColors.textWhite
                  ),
                ),
                const SizedBox(height: 16),
                
                // Opción Tradicional
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Tradicional',
                    textAlign: TextAlign.center, // 👈 Centrar el texto
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Este nivel incluye los dos niveles anteriores más: Información completa de todos los beneficiarios y porcentajes de cada uno.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textWhite,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Opción Irrevocable
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Irrevocable',
                    textAlign: TextAlign.center, // 👈 Centrar el texto
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Este nivel incluye los dos niveles anteriores más: Información completa de todos los beneficiarios y porcentajes de cada uno.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textWhite, // 👈 Usar AppColors.textWhite
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Botón cerrar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textWhite, // 👈 Usar AppColors.textWhite
                      foregroundColor: AppColors.background, // 👈 Usar AppColors.background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Entendido',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _fileUploaderWidget() => GestureDetector(
        onTap: _pickFile,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD6DADF)),
          ),
          child: Column(
            children: [
              if (_selectedFile != null) ...[
                Row(
                  children: [
                    const Icon(Icons.file_present, size: 24, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _fileName ?? 'Archivo seleccionado',
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _selectedFile = null;
                          _fileName = null;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Archivo seleccionado correctamente',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ] else ...[
                const Icon(Icons.upload_file, size: 32, color: AppColors.primary),
                const SizedBox(height: 8),
                const Text(
                  'Haz click para seleccionar el archivo INE',
                  textAlign: TextAlign.center, 
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)
                ),
                const SizedBox(height: 4),
                const Text(
                  'Puedes usar cámara, galería o explorador de archivos',
                  textAlign: TextAlign.center, 
                  style: TextStyle(fontSize: 12, color: Colors.black54)
                ),
                const SizedBox(height: 4),
                const Text(
                  'Formatos: JPG, PNG, PDF • Máximo: 30 MB',
                  textAlign: TextAlign.center, 
                  style: TextStyle(fontSize: 11, color: Colors.black45)
                ),
              ],
            ],
          ),
        ),
      );

  Future<void> _pickFile() async {
    try {
      print('🔍 [CreateBeneficiaryScreen] Iniciando selección de archivo...');
      
      // Mostrar diálogo para elegir método de selección
      final String? method = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Seleccionar archivo INE'),
            content: const Text('¿Cómo deseas seleccionar el archivo?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop('camera'),
                child: const Text('Cámara'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop('gallery'),
                child: const Text('Galería'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop('file_picker'),
                child: const Text('Explorador de archivos'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text('Cancelar'),
              ),
            ],
          );
        },
      );

      if (method == null) return;

      if (method == 'camera' || method == 'gallery') {
        await _pickImage(method);
      } else if (method == 'file_picker') {
        await _pickFileWithFilePicker();
      }
    } catch (e) {
      print('💥 [CreateBeneficiaryScreen] Error al seleccionar archivo: $e');
      _mostrarError('Error al seleccionar archivo: $e');
    }
  }

  Future<void> _pickImage(String source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source == 'camera' ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedFile = File(image.path);
          _fileName = image.name;
        });
        print('✅ [CreateBeneficiaryScreen] Imagen seleccionada: ${image.name}');
      }
    } catch (e) {
      print('💥 [CreateBeneficiaryScreen] Error al seleccionar imagen: $e');
      _mostrarError('Error al seleccionar imagen: $e');
    }
  }

  Future<void> _pickFileWithFilePicker() async {
    try {
      print('🔍 [CreateBeneficiaryScreen] Usando FilePicker...');
      
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false,
      );

      print('📁 [CreateBeneficiaryScreen] Resultado de FilePicker: ${result != null ? 'Archivo seleccionado' : 'Cancelado'}');

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        print('📁 [CreateBeneficiaryScreen] Archivo seleccionado: ${file.name}');
        print('📁 [CreateBeneficiaryScreen] Ruta del archivo: ${file.path}');
        
        if (file.path != null) {
          setState(() {
            _selectedFile = File(file.path!);
            _fileName = file.name;
          });
          
          print('✅ [CreateBeneficiaryScreen] Archivo configurado correctamente');
        } else {
          print('❌ [CreateBeneficiaryScreen] La ruta del archivo es null');
          _mostrarError('No se pudo obtener la ruta del archivo seleccionado');
        }
      }
    } catch (e) {
      print('💥 [CreateBeneficiaryScreen] Error con FilePicker: $e');
      _mostrarError('Error con explorador de archivos: $e');
    }
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  bool _isMinor(DateTime birthDate) {
    return _calculateAge(birthDate) < 18;
  }

  // Método para guardar el beneficiario
  Future<void> _guardarBeneficiario() async {
    // Validaciones básicas
    if (nombresController.text.trim().isEmpty) {
      _mostrarError('El nombre es obligatorio');
      return;
    }

    if (apellidoPaternoController.text.trim().isEmpty) {
      _mostrarError('El apellido paterno es obligatorio');
      return;
    }

    if (_selectedDate == null) {
      _mostrarError('La fecha de nacimiento es obligatoria');
      return;
    }

    // Validación parentesco (dropdown + "Otro")
    final String parentescoFinal = (() {
      if (parentescoSeleccionado == null) return '';
      if (parentescoSeleccionado == 'Otro') {
        return parentescoOtroController.text.trim();
      }
      return parentescoSeleccionado ?? '';
    })();

    if (parentescoFinal.isEmpty) {
      _mostrarError('El parentesco es obligatorio');
      return;
    }

    if (porcentaje <= 0) {
      _mostrarError('El porcentaje debe ser mayor a 0');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Preparar datos del domicilio
      Map<String, dynamic>? domicilio;
      if (!mismoDomicilio) {
        domicilio = {
          'calle': calleController.text.trim(),
          'colonia': coloniaController.text.trim(),
          'codigo_postal': cpController.text.trim(),
          'estado': estadoController.text.trim(),
          'numero_exterior': numeroExtController.text.trim(),
          'numero_interior': numeroIntController.text.trim(),
          'ciudad': ciudadController.text.trim(),
          'pais': paisController.text.trim(),
        };
      }

      // Preparar datos del tutor si es necesario
      Map<String, dynamic>? tutor;
      if (_isMinor(_selectedDate!) && tutorRequerido) {
        tutor = {
          'nombre_completo': '', // TODO: Agregar campo para nombre del tutor
          'fecha_nacimiento': _tutorSelectedDate?.toIso8601String(),
          'parentesco': '', // TODO: Agregar campo para parentesco del tutor
          'ocupacion': '', // TODO: Agregar campo para ocupación del tutor
          'domicilio': {
            'calle': '', // TODO: Agregar campos para domicilio del tutor
            'colonia': '',
          },
        };
      }

      // Convertir archivo a base64 si existe
      String? ineFileBase64;
      if (_selectedFile != null) {
        try {
          final bytes = await _selectedFile!.readAsBytes();
          ineFileBase64 = base64Encode(bytes);
        } catch (e) {
          _mostrarError('Error al procesar el archivo INE: $e');
          return;
        }
      }

      // Crear el beneficiario usando el servicio
      final beneficiario = await BeneficiarioService.createBeneficiario(
        nombres: nombresController.text.trim(),
        segundoNombre: segundoNombreController.text.trim().isEmpty 
            ? null 
            : segundoNombreController.text.trim(),
        apellidoPaterno: apellidoPaternoController.text.trim(),
        apellidoMaterno: apellidoMaternoController.text.trim().isEmpty 
            ? null 
            : apellidoMaternoController.text.trim(),
        fechaNacimiento: _selectedDate!,
        parentesco: parentescoFinal,
        email: emailController.text.trim().isEmpty 
            ? null 
            : emailController.text.trim(),
        ocupacion: (() {
          if (ocupacionSeleccionada == null) return null;
          if (ocupacionSeleccionada == 'Otro') {
            final val = ocupacionOtroController.text.trim();
            return val.isEmpty ? null : val;
          }
          return ocupacionSeleccionada;
        })(),
        porcentaje: porcentaje,
        tipo: categoria, // Usar la categoría como tipo
        mismoDomicilio: mismoDomicilio,
        domicilio: domicilio,
        ineFile: ineFileBase64,
        tutor: tutor,
        userPlanId: widget.userPlanId,
      );

      setState(() {
        isLoading = false;
      });

      // Mostrar mensaje de éxito y regresar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Beneficiario guardado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, beneficiario);
      }

    } catch (e) {
      setState(() {
        isLoading = false;
      });
      
      if (mounted) {
        _mostrarError('Error al guardar beneficiario: ${e.toString()}');
      }
    }
  }

  // Método para mostrar errores
  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Método de prueba eliminado por no ser utilizado
}