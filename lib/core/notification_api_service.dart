import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationApiService {
  static final NotificationApiService instance = NotificationApiService._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final http.Client _client = http.Client();

  NotificationApiService._internal();

  String get _baseUrl {
    // Si usas IP local para pruebas, cámbialo
    return 'https://app.neek.mx/api';
  }

  Future<Map<String, String>> _buildHeaders() async {
    final token = await _storage.read(key: 'auth_token');
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<bool> toggleNotification(String key, bool value) async {
    final uri = Uri.parse('$_baseUrl/notifications/toggle');
    final headers = await _buildHeaders();

    final response = await _client.post(
      uri,
      headers: headers,
      body: jsonEncode({
        'key': key,
        'value': value,
      }),
    );
    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>?> getNotifications() async {
    final uri = Uri.parse('$_baseUrl/notifications');
    final headers = await _buildHeaders();

    final response = await _client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data']; // contiene los campos
      
    } else {
      print('Error al obtener notificaciones: ${response.body}');
      return null;
    }
  }

}
