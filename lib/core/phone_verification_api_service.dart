import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PhoneVerificationApiService {
  static final PhoneVerificationApiService instance = PhoneVerificationApiService._internal();
  final _client = http.Client();
  final _storage = const FlutterSecureStorage();

  PhoneVerificationApiService._internal();

  final String _baseUrl = 'https://app.neek.mx/api';

  Future<Map<String, String>> _buildHeaders() async {
    final token = await _storage.read(key: 'auth_token');
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> sendVerificationCode(String phone) async {
    final url = Uri.parse('$_baseUrl/verify/send');
    final headers = await _buildHeaders();

    final response = await _client.post(
      url,
      headers: headers,
      body: jsonEncode({'phone': phone}),
    );

    final json = jsonDecode(response.body);
    return {
      'success': response.statusCode == 200,
      'message': json['message'] ?? 'Error inesperado',
    };
  }

  Future<Map<String, dynamic>> confirmCode(String phone, String code) async {
    final url = Uri.parse('$_baseUrl/verify/confirm');
    final headers = await _buildHeaders();

    final response = await _client.post(
      url,
      headers: headers,
      body: jsonEncode({'phone': phone, 'code': code}),
    );

    final json = jsonDecode(response.body);
    return {
      'success': response.statusCode == 200,
      'message': json['message'] ?? 'Error inesperado',
    };
  }
}
