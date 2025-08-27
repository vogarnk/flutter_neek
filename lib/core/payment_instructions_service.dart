import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PaymentInstructionsService {
  static final PaymentInstructionsService instance = PaymentInstructionsService._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final http.Client _client = http.Client();

  PaymentInstructionsService._internal();

  String get _baseUrl => 'https://app.neek.mx/api';

  Future<Map<String, String>> _buildHeaders() async {
    final token = await _storage.read(key: 'auth_token');
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Envía instrucciones de pago por email
  Future<Map<String, dynamic>> sendPaymentInstructionsEmail({
    required int userPlanId,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/user/payment-email');
      final headers = await _buildHeaders();

      final response = await _client.post(
        uri,
        headers: headers,
        body: jsonEncode({
          'user_plan_id': userPlanId,
        }),
      );

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': jsonData['message'] ?? 'Instrucciones de pago enviadas correctamente',
          'data': jsonData['data'],
        };
      } else {
        return {
          'success': false,
          'message': jsonData['message'] ?? 'Error al enviar instrucciones de pago',
          'error': jsonData['error'] ?? 'Error desconocido',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
        'error': e.toString(),
      };
    }
  }
}
