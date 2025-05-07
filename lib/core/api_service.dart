import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService._internal();
  static final ApiService instance = ApiService._internal();

  // Cliente HTTP reutilizable
  final http.Client _client = http.Client();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Define aquí tu URL base; se elige automáticamente según plataforma
  String get _baseUrl {
    if (Platform.isAndroid) {
      return 'https://app.neek.mx/api';
      //return 'http://10.0.2.2:8000/api';
    } else {
      return 'https://app.neek.mx/api';
      //return 'http://192.168.1.69:8000/api';
      //return 'http://192.168.110.37:8000/api';
      return 'https://app.neek.mx/api';
    }
  }

  // Construye las cabeceras incluyendo el token si existe
  Future<Map<String, String>> _buildHeaders() async {
    final token = await _storage.read(key: 'auth_token');
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // GET genérico
  Future<http.Response> get(String path) async {
    final uri = Uri.parse('$_baseUrl$path');
    final headers = await _buildHeaders();
    return _client.get(uri, headers: headers);
  }

  // POST genérico con body JSON
  Future<http.Response> post(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$_baseUrl$path');
    final headers = await _buildHeaders();
    return _client.post(uri, headers: headers, body: jsonEncode(body));
  }

  // PUT genérico
  Future<http.Response> put(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$_baseUrl$path');
    final headers = await _buildHeaders();
    return _client.put(uri, headers: headers, body: jsonEncode(body));
  }

  // DELETE genérico
  Future<http.Response> delete(String path) async {
    final uri = Uri.parse('$_baseUrl$path');
    final headers = await _buildHeaders();
    return _client.delete(uri, headers: headers);
  }
  // POST con archivos (multipart/form-data)
  Future<http.Response> postMultipart({
    required String path,
    required Map<String, String> fields,
    required List<http.MultipartFile> files,
  }) async {
    final uri = Uri.parse('$_baseUrl$path');
    final token = await _storage.read(key: 'auth_token');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json' // 👈 esto es lo que falta
      ..fields.addAll(fields)
      ..files.addAll(files);

    final streamedResponse = await request.send();
    return http.Response.fromStream(streamedResponse);
  }


  // Opcional: expone el storage para borrar token en logout
  Future<void> clearToken() => _storage.delete(key: 'auth_token');
}