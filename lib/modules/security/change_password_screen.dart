import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/security_api_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String password = '';

  bool has10Chars = false;
  bool hasLowercase = false;
  bool hasSpecialChar = false;
  bool hasNumber = false;
  
  bool _passwordsDoNotMatch = false;
  bool _currentPasswordError = false;
  bool _requirementsInvalid = false;
  bool _isSubmitting = false;

  void validatePassword(String input) {
    setState(() {
      has10Chars = input.length >= 10;
      hasLowercase = input.contains(RegExp(r'[a-z]'));
      hasSpecialChar = input.contains(RegExp(r'[!@#?]'));
      hasNumber = input.contains(RegExp(r'\d'));
    });
  }

  Widget buildRequirement(String text, bool valid) {
    return Row(
      children: [
        Icon(
          valid ? Icons.check_circle : Icons.cancel,
          color: valid ? Colors.green : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textGray500,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Cambiar contraseña'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.textWhite,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Contraseña actual',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textGray900,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Escribe tu contraseña actual',
                  hintStyle: const TextStyle(color: AppColors.textGray500),
                  filled: true,
                  fillColor: AppColors.background50,
                  errorText: _currentPasswordError ? 'Contraseña actual incorrecta' : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Nueva contraseña',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textGray900,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.black),
                onChanged: (value) {
                  validatePassword(value);
                  setState(() {
                    _requirementsInvalid = false;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Lacontrasena123!',
                  hintStyle: const TextStyle(color: AppColors.textGray500),
                  filled: true,
                  fillColor: AppColors.background50,
                  errorText: _requirementsInvalid ? 'No cumple con los requisitos' : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Confirma tu contraseña',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textGray900,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Lacontrasena123!',
                  hintStyle: const TextStyle(color: AppColors.textGray500),
                  filled: true,
                  fillColor: AppColors.background50,
                  errorText: _passwordsDoNotMatch ? 'Las contraseñas no coinciden' : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),


              const SizedBox(height: 20),

              const Text(
                'Requerimientos para la nueva contraseña:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textGray900,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Asegúrate de que se cumplan los siguientes requisitos:',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textGray500,
                ),
              ),
              const SizedBox(height: 12),
              buildRequirement('Al menos 10 caracteres', has10Chars),
              const SizedBox(height: 6),
              buildRequirement('Un carácter en minúscula', hasLowercase),
              const SizedBox(height: 6),
              buildRequirement(
                  'Un carácter especial: ! @ # ?', hasSpecialChar),
              const SizedBox(height: 6),
              buildRequirement('Al menos un número', hasNumber),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          setState(() {
                            _passwordsDoNotMatch = false;
                            _requirementsInvalid = false;
                            _currentPasswordError = false;
                          });

                          final current = currentPasswordController.text;
                          final newPass = newPasswordController.text;
                          final confirm = confirmPasswordController.text;

                          if (newPass != confirm) {
                            setState(() => _passwordsDoNotMatch = true);
                            return;
                          }

                          if (!has10Chars || !hasLowercase || !hasSpecialChar || !hasNumber) {
                            setState(() => _requirementsInvalid = true);
                            return;
                          }

                          setState(() => _isSubmitting = true);

                          final result = await SecurityApiService.instance.changePassword(
                            currentPassword: current,
                            newPassword: newPass,
                            confirmPassword: confirm,
                          );

                          setState(() => _isSubmitting = false);

                          if (result['success']) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Contraseña actualizada con éxito')),
                            );
                            Navigator.pop(context);
                          } else {
                            setState(() => _currentPasswordError = true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result['message'])),
                            );
                          }
                        },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Guardar cambios',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
