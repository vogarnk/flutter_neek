import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class FirstLoginService {
  static final FirstLoginService instance = FirstLoginService._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final http.Client _client = http.Client();

  FirstLoginService._internal();

  String get _baseUrl => 'https://app.neek.mx/api';

  Future<Map<String, String>> _buildHeaders() async {
    final token = await _storage.read(key: 'auth_token');
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Verifica si el usuario necesita cambiar su contraseña inicial
  Future<Map<String, dynamic>> checkFirstLoginStatus() async {
    try {
      final uri = Uri.parse('$_baseUrl/check-first-login-status');
      final headers = await _buildHeaders();

      final response = await _client.get(uri, headers: headers);
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'first_login': jsonData['first_login'] ?? false,
          'requires_password_change': jsonData['requires_password_change'] ?? false,
          'user': jsonData['user'],
        };
      } else {
        return {
          'success': false,
          'message': jsonData['message'] ?? 'Error al verificar el estado del primer login',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  /// Cambia la contraseña inicial del usuario
  Future<Map<String, dynamic>> changeFirstPassword({
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/change-first-password');
      final headers = await _buildHeaders();

      final body = jsonEncode({
        'password': password,
        'password_confirmation': passwordConfirmation,
      });

      final response = await _client.post(uri, headers: headers, body: body);
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': jsonData['message'] ?? 'Contraseña cambiada exitosamente',
          'user': jsonData['user'],
        };
      } else {
        return {
          'success': false,
          'message': jsonData['message'] ?? 'Error al cambiar la contraseña',
          'errors': jsonData['errors'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  /// Valida que la contraseña cumpla con los requisitos de seguridad
  static bool validatePassword(String password) {
    bool hasUpperCase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowerCase = password.contains(RegExp(r'[a-z]'));
    bool hasNumbers = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialChar = password.contains(RegExp(r'[!@#?$]'));
    bool hasMinLength = password.length >= 10;

    return hasUpperCase && hasLowerCase && hasNumbers && hasSpecialChar && hasMinLength;
  }

  /// Obtiene los detalles de validación de la contraseña
  static Map<String, bool> getPasswordValidationDetails(String password) {
    return {
      'hasMinLength': password.length >= 10,
      'hasUpperCase': password.contains(RegExp(r'[A-Z]')),
      'hasLowerCase': password.contains(RegExp(r'[a-z]')),
      'hasNumbers': password.contains(RegExp(r'[0-9]')),
      'hasSpecialChar': password.contains(RegExp(r'[!@#?$]')),
    };
  }
} 