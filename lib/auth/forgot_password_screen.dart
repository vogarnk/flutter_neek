import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme/app_colors.dart';
import '../core/password_reset_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String? preFilledEmail;
  
  const ForgotPasswordScreen({super.key, this.preFilledEmail});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final PasswordResetService _passwordResetService = PasswordResetService();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    // Prellenar el email si se proporciona
    if (widget.preFilledEmail != null && widget.preFilledEmail!.isNotEmpty) {
      _emailCtrl.text = widget.preFilledEmail!;
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
      _successMessage = null;
    });
  }

  void _showSuccess(String message) {
    setState(() {
      _successMessage = message;
      _errorMessage = null;
    });
  }

  Future<void> _handleSendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final result = await _passwordResetService.sendResetLink(_emailCtrl.text);
      
      if (result['success']) {
        _showSuccess(result['message']);
        setState(() {
          _emailSent = true;
        });
      } else {
        _showError(result['message']);
      }
    } catch (e) {
      _showError('Error inesperado: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _goBackToLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header con logo
                    Center(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/images/second_logo.svg',
                            height: 20,
                            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Restablecer Contraseña',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textGray900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (!_emailSent) ...[
                      // Formulario de solicitud
                      const Text(
                        'Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.',
                        style: TextStyle(
                          color: AppColors.textGray500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: AppColors.textGray900),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.background50,
                          hintText: 'nombre@ejemplo.com',
                          hintStyle: const TextStyle(color: AppColors.textGray500),
                          labelText: 'Correo electrónico',
                          labelStyle: const TextStyle(color: AppColors.textGray500),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: AppColors.textGray300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: AppColors.textGray300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa tu correo electrónico';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Ingresa un correo electrónico válido';
                          }
                          return null;
                        },
                      ),
                      
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ],
                      
                      if (_successMessage != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _successMessage!,
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Botón enviar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSendResetLink,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Enviar Enlace',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ] else ...[
                      // Mensaje de confirmación
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.green.shade600,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '¡Enlace Enviado!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Hemos enviado un enlace de restablecimiento a tu correo electrónico. Revisa tu bandeja de entrada y sigue las instrucciones.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.green.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Botón volver al login
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _goBackToLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            'Volver al Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 16),
                    
                    // Botón cancelar (siempre visible)
                    Center(
                      child: TextButton(
                        onPressed: _goBackToLogin,
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: AppColors.textGray500),
                        ),
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
}
