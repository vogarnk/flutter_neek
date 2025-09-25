import 'dart:convert';
import 'api_service.dart';

class PasswordResetService {
  static final PasswordResetService _instance = PasswordResetService._internal();
  factory PasswordResetService() => _instance;
  PasswordResetService._internal();

  /// Envía un email con un enlace para restablecer la contraseña
  Future<Map<String, dynamic>> sendResetLink(String email) async {
    try {
      final response = await ApiService.instance.post(
        '/password/send-reset-link',
        body: {
          'email': email,
        },
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Se ha enviado un enlace de restablecimiento de contraseña a tu correo electrónico.',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error al enviar el enlace de restablecimiento.',
          'errors': data['errors'] ?? {},
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
        'errors': {},
      };
    }
  }

  /// Verifica si el token de reset es válido
  Future<Map<String, dynamic>> verifyToken(String token, String email) async {
    try {
      final response = await ApiService.instance.post(
        '/api/password/verify-token',
        body: {
          'token': token,
          'email': email,
        },
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'El token es válido.',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'El token de restablecimiento no es válido o ha expirado.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  /// Restablece la contraseña del usuario usando el token válido
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await ApiService.instance.post(
        '/api/password/reset',
        body: {
          'token': token,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Tu contraseña ha sido restablecida exitosamente.',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error al restablecer la contraseña.',
          'errors': data['errors'] ?? {},
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
        'errors': {},
      };
    }
  }
}
