import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/user_session_model.dart';

class SecurityApiService {
  static final SecurityApiService instance = SecurityApiService._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final http.Client _client = http.Client();

  SecurityApiService._internal();

  String get _baseUrl => 'https://app.neek.mx/api';

  Future<Map<String, String>> _buildHeaders() async {
    final token = await _storage.read(key: 'auth_token');
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Obtener lista de sesiones
  Future<List<UserSession>> getSessions() async {
    final uri = Uri.parse('$_baseUrl/security/sessions');
    final headers = await _buildHeaders();

    final response = await _client.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List sessions = jsonData['data'];
      return sessions.map((e) => UserSession.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener sesiones');
    }
  }
  
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final uri = Uri.parse('$_baseUrl/security/change-password');
    final token = await _storage.read(key: 'auth_token');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
      'current_password': currentPassword,
      'new_password': newPassword,
      'new_password_confirmation': confirmPassword,
    });

    final response = await _client.post(uri, headers: headers, body: body);
    final json = jsonDecode(response.body);

    return {
      'success': response.statusCode == 200,
      'message': json['message'] ?? 'Ocurrió un error',
    };
  }

  // Cerrar sesión por ID
  Future<bool> closeSession(String sessionId) async {
    final uri = Uri.parse('$_baseUrl/security/sessions/$sessionId');
    final headers = await _buildHeaders();

    final response = await _client.delete(uri, headers: headers);
    return response.statusCode == 200;
  }
}
