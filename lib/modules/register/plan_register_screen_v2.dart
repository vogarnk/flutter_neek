import 'package:flutter/material.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/modules/register/plan_info_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlanRegisterScreenV2 extends StatefulWidget {
  final Map<String, dynamic> userData;
  const PlanRegisterScreenV2({
    super.key,
    required this.userData,
  });

  @override
  State<PlanRegisterScreenV2> createState() => _PlanRegisterScreenV2State();
}

class _PlanRegisterScreenV2State extends State<PlanRegisterScreenV2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Si hay datos de simulación, mostrarlos en la UI
  }

  void _continue() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final userData = {
        ...widget.userData,
        'email': _emailController.text.trim(),
        'celular': _phoneController.text.trim(),
      };

      final codeSent = await sendVerificationCode(userData['celular']!);
      setState(() => isLoading = false);

      if (codeSent) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlanInfoScreen(
              userData: userData,
            ),
          ),
        );
      }
    }
  }

  Future<bool> sendVerificationCode(String phone) async {
    final formattedPhone = phone.replaceAll(RegExp(r'\D'), '');
    final url = Uri.parse('https://app.neek.mx/api/register');
    final email = _emailController.text.trim();

    print('📤 Enviando código a: $formattedPhone');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'celular': formattedPhone, 'email': email}),
      );

      print('📥 Respuesta: ${response.statusCode}');
      print('📥 Body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Código enviado correctamente');
        return true;
      } else {
        final resBody = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resBody['message'] ?? 'Error al enviar el código')),
        );
        return false;
      }
    } catch (e) {
      print('❌ Error en la solicitud: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo conectar al servidor')),
      );
      return false;
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
                      '¡Estamos listos para empezar!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textGray900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Vamos a crear un plan personalizado y en base a tus metas de ahorro.\n\nEmpecemos con tus datos de contacto.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textGray500,
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text('¿Cuál es tu email?', style: _labelStyle),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _emailController,
                      hintText: 'ejemplo@hotmail.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Este campo es requerido';
                        }
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        return emailRegex.hasMatch(value.trim()) ? null : 'Correo inválido';
                      },
                    ),
                    const SizedBox(height: 20),

                    const Text('Número de celular a 10 dígitos', style: _labelStyle),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _phoneController,
                      hintText: '6671900961',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Este campo es requerido';
                        }
                        final digitsOnly = value.trim().replaceAll(RegExp(r'\D'), '');
                        return digitsOnly.length == 10 ? null : 'Debe tener 10 dígitos';
                      },
                    ),
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
                        onPressed: isLoading ? null : _continue,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Continuar', style: TextStyle(fontSize: 16)),
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
                        onPressed: isLoading ? null : () => Navigator.pop(context),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    IconData? icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType ?? TextInputType.text,
      style: const TextStyle(color: AppColors.textGray900),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textGray500),
        prefixIcon: icon != null ? Icon(icon, color: AppColors.textGray500) : null,
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
}
