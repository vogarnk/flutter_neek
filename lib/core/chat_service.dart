import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:neek/core/api_service.dart';
import 'package:neek/models/chat_message_model.dart';

class ChatService {
  static const String _chatEndpoint = '/chat';

  // Enviar mensaje de texto
  static Future<ChatResponse> sendTextMessage({
    required String message,
    required String sessionId,
    String? conversationId,
  }) async {
    try {
      final response = await ApiService.instance.post(
        '$_chatEndpoint/message',
        body: {
          'message': message,
          'session_id': sessionId,
          'conversation_id': conversationId,
          'type': 'text',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ChatResponse.fromJson(data);
      } else {
        throw Exception('Error al enviar mensaje: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Enviar archivo (imagen o PDF)
  static Future<ChatResponse> sendFileMessage({
    required File file,
    required String sessionId,
    String? conversationId,
    String? message,
  }) async {
    try {
      final fields = <String, String>{
        'session_id': sessionId,
        'conversation_id': conversationId ?? '',
        'message': message ?? '',
        'type': 'file',
      };

      final files = [
        http.MultipartFile(
          'file',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: file.path.split('/').last,
        ),
      ];

      final response = await ApiService.instance.postMultipart(
        path: '$_chatEndpoint/file',
        fields: fields,
        files: files,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ChatResponse.fromJson(data);
      } else {
        throw Exception('Error al enviar archivo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener historial de conversación
  static Future<List<ChatMessage>> getConversationHistory({
    required String conversationId,
    int? limit,
    int? offset,
  }) async {
    try {
      String path = '$_chatEndpoint/history?conversation_id=$conversationId';
      if (limit != null) path += '&limit=$limit';
      if (offset != null) path += '&offset=$offset';

      final response = await ApiService.instance.get(path);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> messages = data['messages'] ?? [];
        return messages.map((msg) => ChatMessage.fromJson(msg)).toList();
      } else {
        throw Exception('Error al obtener historial: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Crear nueva conversación
  static Future<String> createConversation({
    required String sessionId,
    String? initialMessage,
  }) async {
    try {
      final response = await ApiService.instance.post(
        '$_chatEndpoint/conversation',
        body: {
          'session_id': sessionId,
          'initial_message': initialMessage,
        },
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['conversation_id'] ?? '';
      } else {
        throw Exception('Error al crear conversación: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Marcar mensaje como leído
  static Future<bool> markMessageAsRead({
    required String messageId,
    required String conversationId,
  }) async {
    try {
      final response = await ApiService.instance.put(
        '$_chatEndpoint/message/read',
        body: {
          'message_id': messageId,
          'conversation_id': conversationId,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Obtener estado de la conversación
  static Future<ConversationStatus> getConversationStatus({
    required String conversationId,
  }) async {
    try {
      final response = await ApiService.instance.get(
        '$_chatEndpoint/conversation/$conversationId/status',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ConversationStatus.fromJson(data);
      } else {
        throw Exception('Error al obtener estado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}

class ChatResponse {
  final String messageId;
  final String conversationId;
  final String response;
  final bool isBot;
  final DateTime timestamp;
  final String? agentId;
  final String? agentName;

  ChatResponse({
    required this.messageId,
    required this.conversationId,
    required this.response,
    required this.isBot,
    required this.timestamp,
    this.agentId,
    this.agentName,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      messageId: json['message_id'] ?? '',
      conversationId: json['conversation_id'] ?? '',
      response: json['response'] ?? '',
      isBot: json['is_bot'] ?? true,
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      agentId: json['agent_id'],
      agentName: json['agent_name'],
    );
  }
}

class ConversationStatus {
  final String conversationId;
  final bool isActive;
  final bool isBotResponding;
  final String? currentAgentId;
  final String? currentAgentName;
  final DateTime lastActivity;
  final int unreadMessages;

  ConversationStatus({
    required this.conversationId,
    required this.isActive,
    required this.isBotResponding,
    this.currentAgentId,
    this.currentAgentName,
    required this.lastActivity,
    required this.unreadMessages,
  });

  factory ConversationStatus.fromJson(Map<String, dynamic> json) {
    return ConversationStatus(
      conversationId: json['conversation_id'] ?? '',
      isActive: json['is_active'] ?? false,
      isBotResponding: json['is_bot_responding'] ?? true,
      currentAgentId: json['current_agent_id'],
      currentAgentName: json['current_agent_name'],
      lastActivity: DateTime.parse(json['last_activity'] ?? DateTime.now().toIso8601String()),
      unreadMessages: json['unread_messages'] ?? 0,
    );
  }
}
