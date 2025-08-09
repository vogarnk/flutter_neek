import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CreateBeneficiaryScreen extends StatefulWidget {
  const CreateBeneficiaryScreen({super.key});

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
  String categoria = 'Básico';
  bool mismoDomicilio = true;
  bool tutorRequerido = false;
  DateTime? _selectedDate;
  DateTime? _tutorSelectedDate; // 👈 Agregar fecha del tutor

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
              _textField('Parentesco', controller: parentescoController),
              _textField('Ocupación', controller: ocupacionController),
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
                  _radioOption('Básico', categoria, (val) => setState(() => categoria = val!)),
                  _radioOption('Intermedio', categoria, (val) => setState(() => categoria = val!)),
                  _radioOption('Avanzado', categoria, (val) => setState(() => categoria = val!)),
                ],
              ),
              _sectionTitle('Tutor del Beneficiario'),
              if (_selectedDate != null) ...[
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Guardar beneficiario'),
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
        label,
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

  Widget _fileUploaderWidget() => Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD6DADF)),
        ),
        child: Column(
          children: const [
            Icon(Icons.upload_file, size: 32, color: AppColors.primary),
            SizedBox(height: 8),
            Text('Haz click para subir la imagen\no busca el archivo en tu dispositivo',
                textAlign: TextAlign.center, style: TextStyle(color: Colors.black)),
            SizedBox(height: 4),
            Text('Archivos compatibles JPG PNG o PDF\nTamaño máximo del archivo 30 MB',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      );

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
}