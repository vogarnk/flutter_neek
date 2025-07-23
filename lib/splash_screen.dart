import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';

import 'core/api_service.dart';
import 'core/first_login_service.dart';
import 'auth/login_screen.dart';
import 'home_screen.dart';
import 'modules/register/change_password_screen.dart';
import 'core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Configura el parpadeo
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true); // Repite de ida y vuelta

    _opacityAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);

    // Inicia la lógica de navegación después de un tiempo
    _checkToken();
  }

  Future<void> _checkToken() async {
    await Future.delayed(const Duration(seconds: 3)); // deja que "parpadee" unos segundos

    final token = await _secureStorage.read(key: 'auth_token');

    if (token == null) {
      _goToLogin();
      return;
    }

    try {
      // Primero verificar el estado del primer login
      final firstLoginStatus = await FirstLoginService.instance.checkFirstLoginStatus();
      
      if (firstLoginStatus['success']) {
        final requiresPasswordChange = firstLoginStatus['requires_password_change'] ?? false;
        
        if (requiresPasswordChange) {
          // Usuario necesita cambiar su contraseña
          _goToChangePassword();
          return;
        } else {
          // Usuario ya cambió su contraseña, verificar datos del usuario
          final response = await ApiService.instance.get('/user');

          if (response.statusCode == 200) {
            final decoded = jsonDecode(response.body);
            final userData = decoded['data'];
            _goToHome(userData);
          } else {
            await _secureStorage.delete(key: 'auth_token');
            _goToLogin();
          }
        }
      } else {
        // Error al verificar estado del primer login, intentar obtener datos del usuario
        final response = await ApiService.instance.get('/user');

        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          final userData = decoded['data'];
          _goToHome(userData);
        } else {
          await _secureStorage.delete(key: 'auth_token');
          _goToLogin();
        }
      }
    } catch (e) {
      await _secureStorage.delete(key: 'auth_token');
      _goToLogin();
    }
  }

  void _goToHome(Map<String, dynamic> userData) {
    final List<dynamic> userPlans = userData['user_plans'] ?? [];
    final List<String> planNames = userPlans
        .map<String>((plan) => plan['nombre_plan'].toString())
        .toList();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(user: userData, planNames: planNames),
      ),
    );
  }

  void _goToChangePassword() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
    );
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // ✅ única llamada válida
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: SvgPicture.asset(
            'assets/images/second_logo.svg',
            height: 80,
          ),
        ),
      ),
    );
  }
}