import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

import 'package:neek/auth/login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  String getBackendUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api';
    } else {
      return 'http://192.168.1.221:8000/api';
    }
  }

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
      final response = await http.get(
        Uri.parse('${getBackendUrl()}/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final userData = decoded['data']; // ✅ Aquí ya accedes al objeto con name, email, etc.
        _goToHome(userData);
      } else {
        await _secureStorage.delete(key: 'auth_token');
        _goToLogin();
      }
    } catch (e) {
      _goToLogin();
    }
  }

  void _goToHome(Map<String, dynamic> userData) {
    final List<dynamic> userPlans = userData['user_plans'] ?? [];

    // Extrae solo los nombres
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