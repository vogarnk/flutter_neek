import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/notifications_model.dart';

class NotificationApiService {
  static final NotificationApiService instance = NotificationApiService._internal();

  final _client = http.Client();
  final _storage = const FlutterSecureStorage();
  final String _baseUrl = 'https://app.neek.mx/api';

  NotificationApiService._internal();

  Future<Map<String, String>> _buildHeaders() async {
    final token = await _storage.read(key: 'auth_token');
    final deviceToken = await _storage.read(key: 'device_token'); // 👈 este lo guardas al registrar FCM

    if (token == null || deviceToken == null) {
      throw Exception('Faltan tokens para autenticar');
    }

    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'X-Device-Token': deviceToken, // 👈 se envía como header personalizado
    };
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    final url = Uri.parse('$_baseUrl/notifications');
    final headers = await _buildHeaders();

    final response = await _client.get(url, headers: headers);
    final status = response.statusCode;
    final body = response.body;

    print('🔹 Código de respuesta: $status');
    print('🔹 Cuerpo: $body');

    if (status == 200) {
      final json = jsonDecode(body);
      final List<dynamic> list = json['notifications']; // 👈 asegúrate que sea así en tu backend
      return list.map((e) => NotificationModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar notificaciones: $status');
    }
  }
}