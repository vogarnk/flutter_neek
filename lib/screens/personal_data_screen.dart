import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/api_service.dart';
import '../modules/verification/ine_upload_screen.dart';

class PersonalDataScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const PersonalDataScreen({super.key, required this.user});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  String? _estadoCivil;
  String? _estadoNacimientoSeleccionado; // 👈 aquí
  bool _datosCorrectos = false;
  late final TextEditingController _curpController;
  late final TextEditingController _rfcController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _correoController;

  Map<String, dynamic> get user => widget.user;

  @override
  void initState() {
    super.initState();

    _curpController = TextEditingController(text: user['curp'] ?? '');
    _rfcController = TextEditingController(text: user['rfc'] ?? '');
    _telefonoController = TextEditingController(text: user['phone'] ?? '');
    _correoController = TextEditingController(text: user['email'] ?? '');

    if (user['estado_civil'] != null && user['estado_civil'].toString().isNotEmpty) {
      _estadoCivil = user['estado_civil'];
    }
  }

  @override
  void dispose() {
    _curpController.dispose();
    _rfcController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estadoCivilEditable = user['estado_civil'] == null || user['estado_civil'].toString().isEmpty;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: const Text('Datos personales'),
      ),
      body: SingleChildScrollView(
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
              Text(
                'Datos personales',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              // Nombre completo (solo lectura si presente)
              _buildTextField(
                'Nombre completo',
                initialValue: _fullName(),
                readOnly: true,
              ),
              const SizedBox(height: 12),

              // Fecha de nacimiento (editable solo si no existe)
              Text(
                'Fecha de Nacimiento',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 16,
                      color: AppColors.textGray500,
                    ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      '',
                      hint: 'DD',
                      initialValue: _getDatePart(0),
                      readOnly: user['dateBirth'] != null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField(
                      '',
                      hint: 'MM',
                      initialValue: _getDatePart(1),
                      readOnly: user['dateBirth'] != null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField(
                      '',
                      hint: 'YYYY',
                      initialValue: _getDatePart(2),
                      readOnly: user['dateBirth'] != null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Lugar de nacimiento
              _buildDropdown(
                'Lugar de Nacimiento',
                ['SP', 'Estado 2'],
                initialValue: user['estadoNacimiento'],
                enabled: user['estadoNacimiento'] == null || user['estadoNacimiento'].toString().isEmpty,
              ),
              const SizedBox(height: 12),

              _isPresent('curp')
                ? _buildTextField('CURP', initialValue: user['curp'], readOnly: true)
                : _buildTextField('CURP', controller: _curpController),


              const SizedBox(height: 12),

              _buildTextField('RFC', initialValue: user['rfc'], readOnly: _isPresent('rfc')),
              const SizedBox(height: 12),

              _buildTextField('Número de celular', initialValue: user['phone'], readOnly: _isPresent('phone')),
              const SizedBox(height: 12),

              _buildTextField('Correo', initialValue: user['email'], readOnly: _isPresent('email')),
              const SizedBox(height: 12),

              CheckboxListTile(
                value: _datosCorrectos,
                onChanged: (value) {
                  setState(() => _datosCorrectos = value!);
                },
                activeColor: AppColors.primary,
                title: Text(
                  'Mis datos personales son correctos',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textGray900,
                      ),
                ),
                subtitle: Text(
                  'Mis datos personales coinciden con mis datos proporcionados anteriormente',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: AppColors.textGray500,
                      ),
                ),
                contentPadding: EdgeInsets.zero, // opcional para que esté más alineado
                controlAffinity: ListTileControlAffinity.leading, // checkbox al inicio
                dense: true,
              ),


              const Divider(height: 16),
              Text(
                'Estado civil',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textGray900,
                ),
              ),

              const SizedBox(height: 10),

              _buildRadioOption('Soltero', enabled: estadoCivilEditable),
              _buildRadioOption('Casado(a)', enabled: estadoCivilEditable),
              _buildRadioOption('Divorciado(a)', enabled: estadoCivilEditable),
              _buildRadioOption('Viudo(a)', enabled: estadoCivilEditable),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _datosCorrectos ? _handleSubmit : null,
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16),
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey.shade400; // color cuando está deshabilitado
                    }
                    return Theme.of(context).primaryColor; // color normal
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.white70; // texto cuando está deshabilitado
                    }
                    return Colors.white; // texto normal
                  }),
                ),
                child: const Center(child: Text('Continuar')),
              ),


              const SizedBox(height: 16),

              OutlinedButton(
                onPressed: () {
                  // Acción de guardar para después
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Guardar y Continuar más tarde'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    String? hint,
    String? initialValue,
    TextEditingController? controller,
    bool readOnly = false,
    TextStyle? hintStyle,
    TextStyle? textStyle,
  }) {
    final baseStyle = Theme.of(context).textTheme.bodySmall;
    final effectiveTextStyle = (textStyle ?? baseStyle)?.copyWith(
      fontSize: 16,
      color: readOnly ? AppColors.textGray400 : AppColors.textGray500,
    );

    final effectiveHintStyle = (hintStyle ?? baseStyle)?.copyWith(
      fontSize: 16,
      color: AppColors.textGray400,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) Text(label, style: effectiveTextStyle),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null, // no usar ambos
          readOnly: readOnly,
          style: effectiveTextStyle,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: effectiveHintStyle,
            filled: true,
            fillColor: readOnly ? Colors.grey[100] : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: readOnly ? Colors.grey[300]! : AppColors.primary,
                width: readOnly ? 1 : 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: readOnly ? Colors.grey[300]! : Colors.grey[400]!,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }



  void _handleSubmit() async {
    final Map<String, dynamic> dataToSend = {};

    if (user['dateBirth'] == null || user['dateBirth'].toString().isEmpty) {
      // Asegúrate de tener inputs para capturar estos valores
      dataToSend['dateBirth'] = '${_getDatePart(2)}-${_getDatePart(1)}-${_getDatePart(0)}';
    }

    if ((user['estadoNacimiento'] == null || user['estadoNacimiento'].toString().isEmpty) &&
        _estadoNacimientoSeleccionado != null) {
      dataToSend['estadoNacimiento'] = _estadoNacimientoSeleccionado;
    }

    if (!_isPresent('curp')) dataToSend['curp'] = _curpController.text;
    if (!_isPresent('rfc')) dataToSend['rfc'] = _rfcController.text;
    if (!_isPresent('phone')) dataToSend['phone'] = _telefonoController.text;
    if (!_isPresent('email')) dataToSend['email'] = _correoController.text;
    if (_estadoCivil != null) dataToSend['estado_civil'] = _estadoCivil;
    if ((user['estado_civil'] == null || user['estado_civil'].toString().isEmpty) &&
        _estadoCivil != null) {
      dataToSend['estado_civil'] = _estadoCivil;
    }

    if (dataToSend.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay datos nuevos para enviar.')),
      );
      return;
    }

    final response = await ApiService.instance.post('/user/personal-data', body: dataToSend);

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const INEUploadScreen(), // 👈 Aquí va tu pantalla para subir INE
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.body}')),
      );
    }
  }


  Widget _buildDropdown(
    String label,
    List<String> items, {
    String? initialValue,
    bool enabled = true,
  }) {
    final baseStyle = Theme.of(context).textTheme.bodySmall;

    final textStyle = baseStyle?.copyWith(
      fontSize: 16,
      color: enabled ? AppColors.textGray500 : AppColors.textGray400,
    );

    final fillColor = enabled ? Colors.white : Colors.grey[100];
    final borderColor = enabled ? Colors.grey[400]! : Colors.grey[300]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textStyle),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: enabled ? null : initialValue,
          items: items.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e, style: textStyle),
            );
          }).toList(),
          onChanged: enabled
              ? (value) {
                  setState(() {
                    _estadoNacimientoSeleccionado = value;
                  });
                }
              : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
          ),
          style: textStyle,
          iconEnabledColor: enabled ? AppColors.textGray500 : AppColors.textGray400,
          iconDisabledColor: AppColors.textGray400,
          dropdownColor: Colors.white,
        ),
      ],
    );
  }




  Widget _buildRadioOption(String value, {bool enabled = true}) {
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500, // 👈 medium
          color: enabled ? AppColors.textGray900 : AppColors.textGray400,
        );

    return RadioListTile<String>(
      title: Text(value, style: textStyle),
      value: value,
      groupValue: _estadoCivil,
      onChanged: enabled ? (val) => setState(() => _estadoCivil = val) : null,
      activeColor: AppColors.primary,
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }


  String _fullName() {
    return '${user['name'] ?? ''} ${user['sName'] ?? ''} ${user['lName'] ?? ''} ${user['lName2'] ?? ''}'.trim();
  }

  bool _isPresent(String key) {
    return user[key] != null && user[key].toString().isNotEmpty;
  }

  String? _getDatePart(int index) {
    final date = user['dateBirth'];
    if (date == null || date.toString().isEmpty) return null;
    final parts = date.split('-'); // YYYY-MM-DD
    return parts.length == 3 ? parts[index == 0 ? 2 : (index == 1 ? 1 : 0)] : null;
  }
}
