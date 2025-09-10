import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:neek/core/api_service.dart';
import 'package:neek/models/chat_message_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatService {
  static const String _chatEndpoint = '/app-chat';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Obtener user_id del usuario autenticado
  static Future<String?> _getUserId() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null) {
        print('❌ [ChatService] No hay token almacenado');
        return null;
      }

      print('🔍 [ChatService] Token encontrado, intentando decodificar...');

      // Intentar decodificar token JWT
      try {
        final parts = token.split('.');
        if (parts.length == 3) {
          String payload = parts[1];
          while (payload.length % 4 != 0) {
            payload += '=';
          }

          final decodedBytes = base64Url.decode(payload);
          final decodedString = utf8.decode(decodedBytes);
          final payloadData = jsonDecode(decodedString);
          
          print('📋 [ChatService] Payload del token: $payloadData');
          
          final userId = payloadData['sub'] ?? 
                        payloadData['user_id'] ?? 
                        payloadData['id'] ?? 
                        payloadData['user']['id'] ??
                        payloadData['data']['id'] ??
                        payloadData['data']['user_id'];
          
          if (userId != null) {
            print('✅ [ChatService] User ID encontrado en token: $userId');
            return userId.toString();
          }
        }
      } catch (e) {
        print('⚠️ [ChatService] Error decodificando JWT: $e');
      }

      // Intentar extraer user_id usando el mismo método que BeneficiarioService
      final tokenUserId = _extractUserIdFromToken(token);
      if (tokenUserId != null) {
        print('✅ [ChatService] User ID extraído del token: $tokenUserId');
        return tokenUserId.toString();
      }

      // Fallback: obtener user_id de la API
      print('🔄 [ChatService] Intentando obtener user_id de la API...');
      return await _getUserIdFromApi();
      
    } catch (e) {
      print('💥 [ChatService] Error al obtener user_id: $e');
      return null;
    }
  }

  // Método auxiliar para extraer user_id del token (similar a BeneficiarioService)
  static String? _extractUserIdFromToken(String token) {
    try {
      print('🔍 [ChatService] Intentando extraer user_id del token JWT');
      
      // Los tokens JWT tienen formato: header.payload.signature
      final parts = token.split('.');
      if (parts.length != 3) {
        print('❌ [ChatService] Token no tiene formato JWT válido');
        return null;
      }

      // Decodificar el payload (segunda parte)
      final payload = parts[1];
      
      // Agregar padding si es necesario para base64
      String paddedPayload = payload;
      while (paddedPayload.length % 4 != 0) {
        paddedPayload += '=';
      }
      
      // Decodificar base64
      final decodedBytes = base64Url.decode(paddedPayload);
      final decodedString = utf8.decode(decodedBytes);
      
      print('📋 [ChatService] Payload del token: $decodedString');
      
      final payloadData = jsonDecode(decodedString);
      final userId = payloadData['sub'] ?? 
                    payloadData['user_id'] ?? 
                    payloadData['id'] ?? 
                    payloadData['data']['id'] ??
                    payloadData['data']['user_id'];
      
      print('📋 [ChatService] User ID del token: $userId');
      return userId?.toString();
      
    } catch (e) {
      print('💥 [ChatService] Error al decodificar token JWT: $e');
      return null;
    }
  }

  // Método de fallback para obtener user_id de la API (usando el mismo patrón que BeneficiarioService)
  static Future<String?> _getUserIdFromApi() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null) {
        print('❌ [ChatService] No hay token para obtener user_id de API');
        return null;
      }

      print('🔍 [ChatService] Intentando obtener user_id de /api/user');

      // Usar el mismo patrón que BeneficiarioService
      final response = await http.get(
        Uri.parse('${ApiService.instance.baseUrl}/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('📥 [ChatService] Respuesta de /api/user: ${response.statusCode}');
      print('📥 [ChatService] Cuerpo de respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('📋 [ChatService] Datos del usuario: $data');
        
        // Buscar user_id en diferentes ubicaciones (igual que BeneficiarioService)
        final userId = data['data']['id'] ?? 
                      data['data']['user_id'] ?? 
                      data['id'] ?? 
                      data['user_id'] ??
                      data['user']['id'];
        
        if (userId != null) {
          print('✅ [ChatService] User ID obtenido de API: $userId');
          return userId.toString();
        }
      }
      
      print('❌ [ChatService] No se pudo obtener user_id de la API');
      return null;
    } catch (e) {
      print('💥 [ChatService] Error al obtener user_id de API: $e');
      return null;
    }
  }

  // Inicializar chat (crear nueva conversación o retornar existente)
  static Future<ChatInitializeResponse> initializeChat({String? sessionId}) async {
    try {
      final userId = await _getUserId();
      if (userId == null) {
        throw Exception('No se pudo obtener el ID del usuario');
      }

      final body = <String, dynamic>{'user_id': userId};
      if (sessionId != null) {
        body['session_id'] = sessionId;
      }

      final response = await ApiService.instance.post(
        '$_chatEndpoint/initialize',
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ChatInitializeResponse.fromJson(data);
      } else {
        throw Exception('Error al inicializar chat: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener mensajes de una conversación
  static Future<List<ChatMessage>> getMessages(String conversationId) async {
    try {
      final response = await ApiService.instance.get(
        '$_chatEndpoint/conversations/$conversationId/messages',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> messages = data['messages'] ?? [];
        return messages.map((msg) => ChatMessage.fromJson(msg)).toList();
      } else {
        throw Exception('Error al obtener mensajes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Enviar mensaje de texto
  static Future<ChatMessage> sendMessage({
    required String conversationId,
    required String text,
    File? file,
  }) async {
    try {
      if (file == null) {
        // Enviar mensaje de texto
        final response = await ApiService.instance.post(
          '$_chatEndpoint/send-message',
          body: {
            'conversation_id': conversationId,
            'text': text,
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return ChatMessage.fromJson(data['message']);
        } else {
          throw Exception('Error al enviar mensaje: ${response.statusCode}');
        }
      } else {
        // Enviar mensaje con archivo
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('${ApiService.instance.baseUrl}$_chatEndpoint/send-message'),
        );

        // Agregar headers de autenticación
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          request.headers['Authorization'] = 'Bearer $token';
        }

        request.fields['conversation_id'] = conversationId;
        request.fields['text'] = text;
        request.files.add(await http.MultipartFile.fromPath('file', file.path));

        final response = await request.send();
        final responseData = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          final data = jsonDecode(responseData);
          return ChatMessage.fromJson(data['message']);
        } else {
          throw Exception('Error al enviar archivo: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Marcar conversación como leída
  static Future<bool> markAsRead(String conversationId) async {
    try {
      final response = await ApiService.instance.put(
        '$_chatEndpoint/conversations/$conversationId/mark-read',
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error al marcar como leído: $e');
      return false;
    }
  }

  // Cerrar conversación
  static Future<bool> closeConversation(String conversationId) async {
    try {
      final response = await ApiService.instance.put(
        '$_chatEndpoint/conversations/$conversationId/close',
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error al cerrar conversación: $e');
      return false;
    }
  }

  // Obtener conversaciones del usuario
  static Future<List<ChatConversation>> getUserConversations() async {
    try {
      final userId = await _getUserId();
      if (userId == null) {
        throw Exception('No se pudo obtener el ID del usuario');
      }

      final response = await ApiService.instance.get(
        '$_chatEndpoint/users/$userId/conversations',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> conversations = data['conversations'] ?? [];
        return conversations.map((conv) => ChatConversation.fromJson(conv)).toList();
      } else {
        throw Exception('Error al obtener conversaciones: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}

// Respuesta de inicialización del chat
class ChatInitializeResponse {
  final String conversationId;
  final String sessionId;
  final ChatMessage? welcomeMessage;
  final List<ChatMessage>? existingMessages;
  final bool isNewConversation;

  ChatInitializeResponse({
    required this.conversationId,
    required this.sessionId,
    this.welcomeMessage,
    this.existingMessages,
    required this.isNewConversation,
  });

  factory ChatInitializeResponse.fromJson(Map<String, dynamic> json) {
    return ChatInitializeResponse(
      conversationId: json['conversation_id'] ?? '',
      sessionId: json['session_id'] ?? '',
      welcomeMessage: json['welcome_message'] != null 
          ? ChatMessage.fromJson(json['welcome_message'])
          : null,
      existingMessages: json['messages'] != null
          ? (json['messages'] as List).map((msg) => ChatMessage.fromJson(msg)).toList()
          : null,
      isNewConversation: json['welcome_message'] != null,
    );
  }
}

// Modelo de conversación
class ChatConversation {
  final String id;
  final String status;
  final int unreadCount;
  final ChatMessage? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatConversation({
    required this.id,
    required this.status,
    required this.unreadCount,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'] ?? '',
      status: json['status'] ?? 'active',
      unreadCount: json['unread_count'] ?? 0,
      lastMessage: json['last_message'] != null
          ? ChatMessage.fromJson(json['last_message'])
          : null,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
