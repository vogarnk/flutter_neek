import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';

import 'core/api_service.dart';
import 'core/first_login_service.dart';
import 'core/biometric_auth_service.dart';
import 'auth/login_screen.dart';
import 'auth/biometric_auth_screen.dart';
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

    print('🚀 SplashScreen initState iniciado');

    // Configura el parpadeo
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true); // Repite de ida y vuelta

    _opacityAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);

    print('🚀 Animación configurada, iniciando _checkToken');

    // Inicia la lógica de navegación después de un tiempo
    _checkToken();
  }

  Future<void> _checkToken() async {
    try {
      print('🔍 Iniciando _checkToken');
      
      await Future.delayed(const Duration(seconds: 3)); // deja que "parpadee" unos segundos
      print('⏰ Delay completado');

      final token = await _secureStorage.read(key: 'auth_token');
      print('🔑 Token obtenido: ${token != null ? 'Sí' : 'No'}');

      if (token == null) {
        print('❌ No hay token, yendo al login');
        _goToLogin();
        return;
      }

      print('🔍 Verificando autenticación con API...');
      // Primero verificar si el usuario ya está autenticado correctamente
      final response = await ApiService.instance.get('/user');
      print('📡 Respuesta de API: ${response.statusCode}');

      if (response.statusCode != 200) {
        // Token inválido, ir al login
        print('❌ Token inválido, limpiando y yendo al login');
        await _secureStorage.delete(key: 'auth_token');
        _goToLogin();
        return;
      }

      print('✅ Token válido, verificando biometría...');
      // Token válido, verificar si la autenticación biométrica está habilitada
      final biometricStatus = await BiometricAuthService.instance.getBiometricStatus();
      print('📱 Estado de biometría: ${biometricStatus['canUseBiometric']}');
      
      if (biometricStatus['canUseBiometric'] == true) {
        // Usuario tiene biometría habilitada, ir a pantalla de autenticación biométrica
        print('🔐 Biometría habilitada, yendo a autenticación biométrica');
        _goToBiometricAuth();
        return;
      }

      print('🔍 Verificando estado de primer login...');
      // Si no tiene biometría habilitada, continuar con el flujo normal
      final firstLoginStatus = await FirstLoginService.instance.checkFirstLoginStatus();
      print('📋 Estado de primer login: ${firstLoginStatus['success']}');
      
      if (firstLoginStatus['success']) {
        final requiresPasswordChange = firstLoginStatus['requires_password_change'] ?? false;
        print('🔐 Requiere cambio de contraseña: $requiresPasswordChange');
        
        if (requiresPasswordChange) {
          // Usuario necesita cambiar su contraseña
          print('🔐 Yendo a cambio de contraseña');
          _goToChangePassword();
          return;
        } else {
          // Usuario ya cambió su contraseña, verificar datos del usuario
          print('🏠 Yendo al home');
          final decoded = jsonDecode(response.body);
          final userData = decoded['data'];
          _goToHome(userData);
        }
      } else {
        // Error al verificar estado del primer login, usar los datos ya obtenidos
        print('🏠 Error en primer login, yendo al home con datos existentes');
        final decoded = jsonDecode(response.body);
        final userData = decoded['data'];
        _goToHome(userData);
      }
    } catch (e, stackTrace) {
      print('❌ Error en _checkToken: $e');
      print('❌ Stack trace: $stackTrace');
      
      // En caso de error, intentar limpiar el token y ir al login
      try {
        await _secureStorage.delete(key: 'auth_token');
      } catch (storageError) {
        print('❌ Error limpiando token: $storageError');
      }
      
      print('🔐 Yendo al login por error');
      _goToLogin();
    }
  }

  void _goToHome(Map<String, dynamic> userData) {
    try {
      print('🏠 Datos del usuario recibidos: ${userData.keys.toList()}');
      print('🏠 user_plans tipo: ${userData['user_plans'].runtimeType}');
      print('🏠 user_plans contenido: ${userData['user_plans']}');
      
      // user_plans puede ser un Map o una List, necesitamos manejarlo correctamente
      List<dynamic> userPlans = [];
      
      if (userData['user_plans'] is Map) {
        print('🏠 user_plans es Map, convirtiendo a lista');
        // Si es un Map, convertir a lista
        final Map<String, dynamic> userPlansMap = userData['user_plans'] ?? {};
        userPlans = userPlansMap.values.toList();
      } else if (userData['user_plans'] is List) {
        print('🏠 user_plans es List, usando directamente');
        // Si ya es una List, usarla directamente
        userPlans = userData['user_plans'] ?? [];
      } else {
        print('🏠 user_plans es de tipo inesperado: ${userData['user_plans'].runtimeType}');
        userPlans = [];
      }
      
      print('🏠 userPlans procesado: ${userPlans.length} elementos');
      
      final List<String> planNames = userPlans
          .map<String>((plan) {
            try {
              return plan['nombre_plan']?.toString() ?? 'Plan sin nombre';
            } catch (e) {
              print('🏠 Error procesando plan: $e');
              return 'Plan sin nombre';
            }
          })
          .toList();
      
      print('🏠 planNames generado: $planNames');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(user: userData, planNames: planNames),
        ),
      );
    } catch (e, stackTrace) {
      print('❌ Error en _goToHome: $e');
      print('❌ Stack trace: $stackTrace');
      print('🔐 Yendo al login por error en _goToHome');
      _goToLogin();
    }
  }

  void _goToBiometricAuth() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const BiometricAuthScreen()),
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