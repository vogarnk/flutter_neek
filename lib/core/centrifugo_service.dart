import 'dart:async';
import 'dart:convert';
import 'package:centrifuge/centrifuge.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:neek/core/api_service.dart';

/// Servicio singleton para manejar conexiones WebSocket con Centrifugo
/// Soporta múltiples usuarios y múltiples suscripciones a canales
class CentrifugoService {
  // Singleton instance
  static final CentrifugoService _instance = CentrifugoService._internal();
  factory CentrifugoService() => _instance;
  CentrifugoService._internal();

  // Configuración del servidor Centrifugo
  static const String _centrifugoUrl = 'wss://ws.neek.mx/connection/websocket';
  
  // Cliente de Centrifugo
  Client? _client;
  
  // Almacenamiento seguro
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  // Información del usuario actual
  String? _userId;
  String? _authToken;
  
  // Estado de conexión
  bool _isConnected = false;
  bool _isConnecting = false;
  
  // Suscripciones activas (canal -> suscripción)
  final Map<String, Subscription> _subscriptions = {};
  
  // Callbacks globales para eventos
  final List<Function()> _onConnectedCallbacks = [];
  final List<Function()> _onDisconnectedCallbacks = [];
  final Map<String, List<Function(Map<String, dynamic>)>> _channelCallbacks = {};
  
  // Stream controllers para eventos
  final StreamController<bool> _connectionStatusController = 
      StreamController<bool>.broadcast();
  
  /// Stream del estado de conexión
  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  
  /// Verifica si está conectado
  bool get isConnected => _isConnected;
  
  /// Obtiene el user ID actual
  String? get userId => _userId;

  /// Inicializar y conectar a Centrifugo
  /// Debe llamarse al iniciar sesión o al abrir la app
  Future<void> connect({
    Function()? onConnected,
    Function()? onDisconnected,
  }) async {
    // Si ya está conectando, esperar
    if (_isConnecting) {
      print('⏳ [Centrifugo] Ya hay una conexión en proceso, esperando...');
      return;
    }
    
    // Si ya está conectado, no hacer nada
    if (_isConnected && _client != null) {
      print('✅ [Centrifugo] Ya está conectado');
      onConnected?.call();
      return;
    }

    _isConnecting = true;
    
    try {
      // Obtener token de autenticación
      _authToken = await _storage.read(key: 'auth_token');
      if (_authToken == null) {
        throw Exception('No hay token de autenticación');
      }

      // Obtener user ID del token o del API
      _userId = await _extractUserIdFromToken(_authToken!);
      
      // Si no se pudo extraer del token, intentar desde el API
      if (_userId == null) {
        print('🔄 [Centrifugo] Intentando obtener user_id desde API...');
        _userId = await _getUserIdFromApi();
      }
      
      if (_userId == null) {
        throw Exception('No se pudo obtener el user ID del token ni del API');
      }

      print('🔑 [Centrifugo] User ID: $_userId');

      // Obtener token de conexión del backend
      final connectionToken = await _getConnectionToken();
      
      print('🔌 [Centrifugo] Conectando a: $_centrifugoUrl');

      // Registrar callbacks si se proporcionan
      if (onConnected != null) {
        _onConnectedCallbacks.add(onConnected);
      }
      if (onDisconnected != null) {
        _onDisconnectedCallbacks.add(onDisconnected);
      }

      // Configurar el cliente de Centrifugo
      final config = ClientConfig(
        token: connectionToken,
        timeout: const Duration(seconds: 10),
      );

      _client = createClient(_centrifugoUrl, config);

      // Configurar listeners de eventos de conexión
      _client!.connecting.listen((event) {
        print('⏳ [Centrifugo] Conectando...');
      });

      _client!.connected.listen((event) {
        print('✅ [Centrifugo] Conectado exitosamente');
        _isConnected = true;
        _isConnecting = false;
        _connectionStatusController.add(true);
        
        // Llamar callbacks de conexión
        for (var callback in _onConnectedCallbacks) {
          callback();
        }
      });

      _client!.disconnected.listen((event) {
        print('❌ [Centrifugo] Desconectado: ${event.reason}');
        _isConnected = false;
        _isConnecting = false;
        _connectionStatusController.add(false);
        
        // Llamar callbacks de desconexión
        for (var callback in _onDisconnectedCallbacks) {
          callback();
        }
        
        // Limpiar suscripciones
        _subscriptions.clear();
      });

      _client!.error.listen((event) {
        print('💥 [Centrifugo] Error: ${event.error}');
      });

      // Conectar
      _client!.connect();
      
      print('🚀 [Centrifugo] Iniciando conexión...');
      
    } catch (e) {
      _isConnecting = false;
      print('💥 [Centrifugo] Error al conectar: $e');
      rethrow;
    }
  }

  /// Obtener token de conexión del backend
  Future<String> _getConnectionToken() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.instance.baseUrl}/centrifugo/connection-token'),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Accept': 'application/json',
        },
      );

      print('📥 [Centrifugo] Respuesta token conexión: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['data']['token'];
        print('✅ [Centrifugo] Token de conexión obtenido');
        return token;
      } else {
        throw Exception('Error al obtener token de conexión: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 [Centrifugo] Error obteniendo token de conexión: $e');
      rethrow;
    }
  }

  /// Obtener token de suscripción para un canal específico
  Future<String> _getSubscriptionToken(String channel) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.instance.baseUrl}/centrifugo/subscription-token'),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({'channel': channel}),
      );

      print('📥 [Centrifugo] Respuesta token suscripción: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['data']['token'];
        print('✅ [Centrifugo] Token de suscripción obtenido para: $channel');
        return token;
      } else {
        throw Exception('Error al obtener token de suscripción: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 [Centrifugo] Error obteniendo token de suscripción: $e');
      rethrow;
    }
  }

  /// Suscribirse a un canal específico
  /// 
  /// [channel] - Nombre del canal (ej: "app_chat_uuid" o "conversations_123")
  /// [onMessage] - Callback que se ejecuta cuando llega un mensaje al canal
  Future<bool> subscribe(
    String channel, {
    required Function(Map<String, dynamic>) onMessage,
  }) async {
    if (_client == null || !_isConnected) {
      print('❌ [Centrifugo] No hay conexión activa. Debe llamar connect() primero');
      return false;
    }

    // Si ya existe la suscripción, solo agregar el callback
    if (_subscriptions.containsKey(channel)) {
      print('⚠️ [Centrifugo] Ya está suscrito a $channel, agregando callback');
      _channelCallbacks[channel]?.add(onMessage);
      return true;
    }

    try {
      // Obtener token de suscripción del backend
      final subscriptionToken = await _getSubscriptionToken(channel);

      // Crear suscripción
      final subscription = _client!.newSubscription(
        channel,
        SubscriptionConfig(
          token: subscriptionToken,
        ),
      );

      // Inicializar lista de callbacks para este canal
      _channelCallbacks[channel] = [onMessage];

      // Configurar listener para publicaciones
      subscription.publication.listen((event) {
        print('📨 [Centrifugo] Mensaje recibido en $channel');
        
        final data = event.data;
        
        // Llamar a todos los callbacks registrados para este canal
        if (_channelCallbacks.containsKey(channel)) {
          for (var callback in _channelCallbacks[channel]!) {
            try {
              callback(data as Map<String, dynamic>);
            } catch (e) {
              print('💥 [Centrifugo] Error en callback de $channel: $e');
            }
          }
        }
      });

      // Listener de estado de suscripción
      subscription.subscribed.listen((event) {
        print('✅ [Centrifugo] Suscrito exitosamente a: $channel');
      });

      subscription.subscribing.listen((event) {
        print('⏳ [Centrifugo] Suscribiendo a: $channel');
      });

      subscription.unsubscribed.listen((event) {
        print('👋 [Centrifugo] Desuscrito de: $channel');
        _subscriptions.remove(channel);
        _channelCallbacks.remove(channel);
      });

      subscription.error.listen((event) {
        print('❌ [Centrifugo] Error en suscripción de $channel: ${event.error}');
      });

      // Guardar suscripción
      _subscriptions[channel] = subscription;

      // Suscribirse al canal
      subscription.subscribe();

      print('🔔 [Centrifugo] Suscribiendo a canal: $channel');
      
      return true;
    } catch (e) {
      print('💥 [Centrifugo] Error al suscribirse al canal $channel: $e');
      return false;
    }
  }

  /// Desuscribirse de un canal específico
  Future<void> unsubscribe(String channel) async {
    if (_subscriptions.containsKey(channel)) {
      print('👋 [Centrifugo] Desuscribiendo de: $channel');
      await _subscriptions[channel]?.unsubscribe();
      _subscriptions.remove(channel);
      _channelCallbacks.remove(channel);
    }
  }

  /// Suscribirse a todos los canales disponibles del usuario
  Future<void> subscribeToUserChannels({
    Function(Map<String, dynamic>)? onMessageReceived,
    Function(Map<String, dynamic>)? onConversationUpdate,
  }) async {
    if (_userId == null) {
      print('❌ [Centrifugo] No hay user ID disponible');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiService.instance.baseUrl}/centrifugo/channels'),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Accept': 'application/json',
        },
      );

      print('📥 [Centrifugo] Respuesta canales: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final channels = List<String>.from(data['data']['channels']);
        
        print('📋 [Centrifugo] Canales disponibles: $channels');

        for (final channel in channels) {
          // Determinar el tipo de canal y asignar el callback apropiado
          if (channel.startsWith('app_chat_')) {
            // Canal de conversación específica
            if (onMessageReceived != null) {
              await subscribe(channel, onMessage: onMessageReceived);
            }
          } else if (channel.startsWith('conversations_')) {
            // Canal de actualizaciones de conversaciones del usuario
            if (onConversationUpdate != null) {
              await subscribe(channel, onMessage: onConversationUpdate);
            }
          }
        }
      } else {
        print('❌ [Centrifugo] Error al obtener canales: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 [Centrifugo] Error al obtener canales: $e');
    }
  }

  /// Suscribirse a un canal de conversación específico
  Future<bool> subscribeToConversation(
    String conversationId, {
    required Function(Map<String, dynamic>) onMessage,
  }) async {
    final channel = 'app_chat_$conversationId';
    return await subscribe(channel, onMessage: onMessage);
  }

  /// Suscribirse al canal de conversaciones del usuario
  Future<bool> subscribeToUserConversations({
    required Function(Map<String, dynamic>) onUpdate,
  }) async {
    if (_userId == null) {
      print('❌ [Centrifugo] No hay user ID disponible');
      return false;
    }
    
    final channel = 'conversations_$_userId';
    return await subscribe(channel, onMessage: onUpdate);
  }

  /// Desconectar y limpiar recursos
  Future<void> disconnect() async {
    print('👋 [Centrifugo] Desconectando...');
    
    // Desuscribirse de todos los canales
    for (var channel in _subscriptions.keys.toList()) {
      await unsubscribe(channel);
    }
    
    // Desconectar cliente
    _client?.disconnect();
    _client = null;
    
    // Limpiar estado
    _isConnected = false;
    _isConnecting = false;
    _userId = null;
    _authToken = null;
    _subscriptions.clear();
    _channelCallbacks.clear();
    _onConnectedCallbacks.clear();
    _onDisconnectedCallbacks.clear();
    
    _connectionStatusController.add(false);
    
    print('✅ [Centrifugo] Desconectado completamente');
  }

  /// Extraer user ID del token JWT
  Future<String?> _extractUserIdFromToken(String token) async {
    try {
      print('🔍 [Centrifugo] Extrayendo user_id del token JWT');
      
      final parts = token.split('.');
      if (parts.length != 3) {
        print('⚠️ [Centrifugo] Token no tiene formato JWT válido');
        return null;
      }

      String payload = parts[1];
      while (payload.length % 4 != 0) {
        payload += '=';
      }
      
      final decodedBytes = base64Url.decode(payload);
      final decodedString = utf8.decode(decodedBytes);
      final payloadData = jsonDecode(decodedString);
      
      final userId = payloadData['sub'] ?? 
                    payloadData['user_id'] ?? 
                    payloadData['id'] ?? 
                    payloadData['data']?['id'] ??
                    payloadData['data']?['user_id'];
      
      if (userId != null) {
        print('✅ [Centrifugo] User ID extraído del JWT: $userId');
      }
      return userId?.toString();
      
    } catch (e) {
      print('⚠️ [Centrifugo] Error al decodificar token JWT: $e');
      return null;
    }
  }

  /// Obtener user ID desde el endpoint /api/user (fallback)
  Future<String?> _getUserIdFromApi() async {
    try {
      print('🔍 [Centrifugo] Obteniendo user_id desde /api/user');
      
      final response = await http.get(
        Uri.parse('${ApiService.instance.baseUrl}/user'),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Accept': 'application/json',
        },
      );

      print('📥 [Centrifugo] Respuesta /api/user: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('📋 [Centrifugo] Datos del usuario: ${data['data']}');
        
        // Buscar user_id en diferentes ubicaciones
        final userId = data['data']?['id'] ?? 
                      data['data']?['user_id'] ?? 
                      data['id'] ?? 
                      data['user_id'] ??
                      data['user']?['id'];
        
        if (userId != null) {
          print('✅ [Centrifugo] User ID obtenido desde API: $userId');
          return userId.toString();
        }
      }
      
      print('❌ [Centrifugo] No se pudo obtener user_id desde API');
      return null;
    } catch (e) {
      print('💥 [Centrifugo] Error al obtener user_id desde API: $e');
      return null;
    }
  }

  /// Limpiar recursos al cerrar
  void dispose() {
    _connectionStatusController.close();
  }
}

