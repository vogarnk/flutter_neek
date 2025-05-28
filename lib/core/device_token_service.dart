import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class DeviceTokenService {
  static const _baseUrl = 'https://app.neek.mx';
  static const _storage = FlutterSecureStorage();

  static Future<void> registerToken(String fcmToken) async {
    try {
      final authToken = await _storage.read(key: 'auth_token');

      if (authToken == null) {
        debugPrint('❌ No se encontró el auth_token en storage.');
        return;
      }

      final platform = Platform.isIOS
          ? 'ios'
          : Platform.isAndroid
              ? 'android'
              : 'web';

      final response = await http.post(
        Uri.parse('$_baseUrl/api/device-token'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'token': fcmToken,
          'platform': platform,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Token FCM registrado correctamente.');
      } else {
        debugPrint('❌ Error al registrar token FCM: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      debugPrint('❗ Excepción al registrar token FCM: $e');
    }
  }
}