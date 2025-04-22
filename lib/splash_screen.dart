import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'core/api_service.dart';
import 'package:neek/auth/login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final token = await _secureStorage.read(key: 'auth_token');

    if (token == null) {
      _goToLogin();
      return;
    }

    try {
      final response = await ApiService.instance.get('/user');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final userData = decoded['data'];
        _goToHome(userData);
      } else {
        await _secureStorage.delete(key: 'auth_token');
        _goToLogin();
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

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}