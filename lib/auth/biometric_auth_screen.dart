import 'package:flutter/material.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/core/biometric_auth_service.dart';
import 'package:neek/core/api_service.dart';
import 'package:neek/auth/login_screen.dart';
import 'package:neek/home_screen.dart';
import 'dart:convert';

class BiometricAuthScreen extends StatefulWidget {
  const BiometricAuthScreen({super.key});

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  
  bool _isAuthenticating = false;
  String? _errorMessage;
  String _biometricType = 'Biometría';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadBiometricType();
    _startAuthentication();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  Future<void> _loadBiometricType() async {
    try {
      final type = await BiometricAuthService.instance.getPrimaryBiometricTypeName();
      setState(() {
        _biometricType = type;
      });
    } catch (e) {
      setState(() {
        _biometricType = 'Biometría';
      });
    }
  }

  Future<void> _startAuthentication() async {
    setState(() {
      _isAuthenticating = true;
      _errorMessage = null;
    });

    try {
      final result = await BiometricAuthService.instance.authenticateForAppAccess();
      
      if (result['success']) {
        // Autenticación exitosa, obtener datos del usuario y ir directamente al HomeScreen
        await _goToHomeAfterAuth();
      } else {
        // Usuario canceló o falló la autenticación
        setState(() {
          _errorMessage = result['error'] ?? 'Autenticación cancelada';
          _isAuthenticating = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error en la autenticación biométrica';
        _isAuthenticating = false;
      });
    }
  }

  Future<void> _goToHomeAfterAuth() async {
    try {
      // Obtener datos del usuario
      final response = await ApiService.instance.get('/user');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final userData = decoded['data'];
        
        // user_plans ahora es un Map, necesitamos convertirlo a lista
        final Map<String, dynamic> userPlansMap = userData['user_plans'] ?? {};
        final List<dynamic> userPlans = userPlansMap.values.toList();
        final List<String> planNames = userPlans
            .map<String>((plan) => plan['nombre_plan'].toString())
            .toList();

        // Navegar directamente al HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(user: userData, planNames: planNames),
          ),
        );
      } else {
        // Error al obtener datos del usuario, ir al login
        _goToLogin();
      }
    } catch (e) {
      // Error al obtener datos del usuario, ir al login
      _goToLogin();
    }
  }

  Future<void> _retryAuthentication() async {
    await _startAuthentication();
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Widget _buildBiometricIcon() {
    if (_biometricType.contains('Face ID') || _biometricType.contains('Reconocimiento facial')) {
      return const Icon(
        Icons.face,
        size: 80,
        color: AppColors.primary,
      );
    } else if (_biometricType.contains('Huella')) {
      return const Icon(
        Icons.fingerprint,
        size: 80,
        color: AppColors.primary,
      );
    } else {
      return const Icon(
        Icons.security,
        size: 80,
        color: AppColors.primary,
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo de la app
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _opacityAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.account_balance,
                            size: 60,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 40),

                // Título
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: const Text(
                        'Bienvenido a Neek',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textWhite,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Subtítulo
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: Text(
                        'Usa $_biometricType para acceder',
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.textGray300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 60),

                // Icono de biometría con animación
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(60),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: _isAuthenticating
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                strokeWidth: 3,
                              )
                            : _buildBiometricIcon(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Mensaje de estado
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: Text(
                        _isAuthenticating 
                            ? 'Autenticando...'
                            : _errorMessage ?? 'Toca para autenticarte',
                        style: TextStyle(
                          fontSize: 16,
                          color: _errorMessage != null 
                              ? Colors.red.shade400 
                              : AppColors.textGray300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Botones de acción
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: Column(
                        children: [
                          if (!_isAuthenticating)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _retryAuthentication,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text(
                                  'Reintentar',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),

                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: _goToLogin,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.textGray300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                'Usar contraseña',
                                style: TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Información de seguridad
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.background50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.security,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Tus datos biométricos se almacenan de forma segura en tu dispositivo',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textGray500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 