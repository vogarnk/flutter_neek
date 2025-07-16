import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class MovimientosService {
  static const _baseUrl = 'https://app.neek.mx';
  static const _storage = FlutterSecureStorage();

  static Future<List<dynamic>> obtenerMovimientos(int userPlanId) async {
    try {
      final authToken = await _storage.read(key: 'auth_token');

      if (authToken == null) {
        debugPrint('❌ No se encontró el auth_token en storage.');
        return [];
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/api/user/movimientos'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'user_plan_id': userPlanId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('✅ Movimientos obtenidos.');
        return data['movimientos'] ?? [];
      } else {
        debugPrint('❌ Error al obtener movimientos: ${response.statusCode} ${response.body}');
        return [];
      }
    } catch (e) {
      debugPrint('❗ Excepción al obtener movimientos: $e');
      return [];
    }
  }
} 