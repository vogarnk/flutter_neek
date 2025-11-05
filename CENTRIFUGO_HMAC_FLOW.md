# Flujo de Autenticación HMAC con Centrifugo

## 🔐 ¿Qué es HMAC?

HMAC (Hash-based Message Authentication Code) es un mecanismo de autenticación que garantiza que los tokens sean generados únicamente por tu backend y no puedan ser falsificados por el cliente.

## 📊 Flujo de Autenticación Completo

### 1. Cliente Flutter → Backend Laravel

```
Cliente                          Backend
   │                                │
   │  GET /api/centrifugo/          │
   │      connection-token          │
   │  Authorization: Bearer {token} │
   ├────────────────────────────────>
   │                                │
   │                                │ 1. Verifica autenticación
   │                                │ 2. Obtiene user_id
   │                                │ 3. Genera token HMAC
   │                                │    usando SECRET
   │                                │
   │  {"token": "eyJhbGc..."}       │
   <────────────────────────────────┤
   │                                │
```

### 2. Cliente → Servidor Centrifugo

```
Cliente                    Centrifugo Server
   │                             │
   │  WSS Connection             │
   │  wss://ws.neek.mx           │
   │  Token: eyJhbGc...          │
   ├─────────────────────────────>
   │                             │
   │                             │ Verifica token HMAC
   │                             │ usando mismo SECRET
   │                             │
   │  Connection Established     │
   <─────────────────────────────┤
   │                             │
```

## 🔧 Implementación en Backend Laravel

### Configuración `.env`

```env
CENTRIFUGO_URL=http://localhost:8000
CENTRIFUGO_API_KEY=2d23b7c0f7ee2a12786ac37c723f967d717faa4e5bd5f8f49e6c4bc8d72e0dee
CENTRIFUGO_SECRET=d72ddc0449e4c675c27f7c82ad8e1aa7553b46da31a915bb24b6047e50df91f6
CENTRIFUGO_TOKEN_HMAC_SECRET=a42d4e3a39cf21291238add34e27dd715d724b5096c443a3e2dcb7ea6dcb51a8
```

### Generar Token de Conexión

```php
use Firebase\JWT\JWT;

class CentrifugoController extends Controller
{
    public function getConnectionToken(Request $request)
    {
        $userId = auth()->id();
        
        $claims = [
            'sub' => (string)$userId,  // Subject (user ID)
            'exp' => time() + 3600,     // Expira en 1 hora
            'iat' => time(),            // Issued at
        ];
        
        $token = JWT::encode(
            $claims, 
            config('centrifugo.token_hmac_secret'),
            'HS256'
        );
        
        return response()->json([
            'success' => true,
            'data' => [
                'token' => $token,
                'user_id' => $userId,
            ],
        ]);
    }
}
```

### Generar Token de Suscripción

```php
public function getSubscriptionToken(Request $request)
{
    $userId = auth()->id();
    $channel = $request->input('channel');
    
    // Validar que el usuario tenga permiso para este canal
    if (!$this->canSubscribeToChannel($userId, $channel)) {
        return response()->json(['error' => 'Unauthorized'], 403);
    }
    
    $claims = [
        'sub' => (string)$userId,
        'channel' => $channel,
        'exp' => time() + 3600,
        'iat' => time(),
    ];
    
    $token = JWT::encode(
        $claims,
        config('centrifugo.token_hmac_secret'),
        'HS256'
    );
    
    return response()->json([
        'success' => true,
        'data' => [
            'token' => $token,
            'channel' => $channel,
        ],
    ]);
}

private function canSubscribeToChannel($userId, $channel)
{
    // Validar permisos según el tipo de canal
    if (str_starts_with($channel, 'app_chat_')) {
        // Verificar que el usuario sea parte de la conversación
        $conversationId = str_replace('app_chat_', '', $channel);
        return Conversation::where('id', $conversationId)
            ->where('user_id', $userId)
            ->exists();
    }
    
    if (str_starts_with($channel, 'conversations_')) {
        // Verificar que sea el canal del usuario
        $channelUserId = str_replace('conversations_', '', $channel);
        return $userId == $channelUserId;
    }
    
    return false;
}
```

### Publicar Mensajes

```php
use denis660\Centrifugo\Centrifugo;

class ChatService
{
    public function publishMessage($conversationId, $message)
    {
        $channel = "app_chat_{$conversationId}";
        
        $centrifugo = new Centrifugo();
        $centrifugo->publish($channel, [
            'id' => $message->id,
            'conversation_id' => $message->conversation_id,
            'text' => $message->text,
            'is_user' => $message->is_user,
            'created_at' => $message->created_at->toISOString(),
            // ... otros campos
        ]);
        
        // También publicar en el canal de conversaciones del usuario
        $userChannel = "conversations_{$message->conversation->user_id}";
        $centrifugo->publish($userChannel, [
            'type' => 'new_message',
            'conversation_id' => $conversationId,
            'message' => $message,
            'unread_count' => $this->getUnreadCount($message->conversation->user_id),
        ]);
    }
}
```

## 📱 Implementación en Flutter (Ya Hecho)

El código Flutter ya está implementado y hace lo siguiente:

### 1. Obtener Token de Conexión

```dart
Future<String> _getConnectionToken() async {
  final response = await http.get(
    Uri.parse('${ApiService.instance.baseUrl}/centrifugo/connection-token'),
    headers: {
      'Authorization': 'Bearer $_authToken',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['data']['token'];  // Token HMAC generado por el backend
  }
  
  throw Exception('Error al obtener token de conexión');
}
```

### 2. Conectar con Token HMAC

```dart
_client = createClient(
  'wss://ws.neek.mx/connection/websocket',
  ClientConfig(
    token: connectionToken,  // Token HMAC del backend
    timeout: const Duration(seconds: 10),
  ),
);

_client!.connect();
```

### 3. Obtener Token de Suscripción

```dart
Future<String> _getSubscriptionToken(String channel) async {
  final response = await http.post(
    Uri.parse('${ApiService.instance.baseUrl}/centrifugo/subscription-token'),
    headers: {
      'Authorization': 'Bearer $_authToken',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: json.encode({'channel': channel}),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['data']['token'];  // Token HMAC para suscripción
  }
  
  throw Exception('Error al obtener token de suscripción');
}
```

### 4. Suscribirse con Token HMAC

```dart
final subscription = _client!.newSubscription(
  channel,
  SubscriptionConfig(
    token: subscriptionToken,  // Token HMAC del backend
  ),
);

subscription.subscribe();
```

## ✅ Corrección del Error Actual

### Problema Identificado

El error ocurre porque:
1. El token almacenado en `flutter_secure_storage` no es un JWT
2. No se puede extraer el `user_id` del token directamente

### Solución Implementada

Ahora el código hace lo siguiente:

```dart
// 1. Intentar extraer user_id del token (si es JWT)
_userId = await _extractUserIdFromToken(_authToken!);

// 2. Si falla, obtener desde el API (FALLBACK)
if (_userId == null) {
  _userId = await _getUserIdFromApi(); // GET /api/user
}

// 3. Con el user_id, obtener token HMAC del backend
final connectionToken = await _getConnectionToken();

// 4. Conectar usando el token HMAC
_client = createClient(_centrifugoUrl, ClientConfig(token: connectionToken));
```

### Logs Esperados Después del Fix

```
flutter: 🚀 [ChatScreen] Inicializando Centrifugo...
flutter: 🔍 [Centrifugo] Extrayendo user_id del token JWT
flutter: ⚠️ [Centrifugo] Token no tiene formato JWT válido
flutter: 🔄 [Centrifugo] Intentando obtener user_id desde API...
flutter: 🔍 [Centrifugo] Obteniendo user_id desde /api/user
flutter: 📥 [Centrifugo] Respuesta /api/user: 200
flutter: 📋 [Centrifugo] Datos del usuario: {...}
flutter: ✅ [Centrifugo] User ID obtenido desde API: 1
flutter: 🔑 [Centrifugo] User ID: 1
flutter: 📥 [Centrifugo] Respuesta token conexión: 200
flutter: ✅ [Centrifugo] Token de conexión obtenido
flutter: 🔌 [Centrifugo] Conectando a: wss://ws.neek.mx/connection/websocket
flutter: 🚀 [Centrifugo] Iniciando conexión...
flutter: ⏳ [Centrifugo] Conectando...
flutter: ✅ [Centrifugo] Conectado exitosamente
flutter: ✅ [ChatScreen] Conectado a Centrifugo
```

## 🔒 Seguridad

### ¿Por qué HMAC?

1. **No se puede falsificar**: Solo el servidor con el `HMAC_SECRET` puede generar tokens válidos
2. **Expiran automáticamente**: Tokens tienen tiempo de vida limitado (1 hora)
3. **Específicos por canal**: Cada suscripción requiere su propio token
4. **Validación de permisos**: El backend valida permisos antes de generar tokens

### Buenas Prácticas

✅ **NUNCA** incluir el `HMAC_SECRET` en el código del cliente
✅ **SIEMPRE** generar tokens en el backend
✅ **VALIDAR** permisos antes de generar tokens de suscripción
✅ **USAR** tiempos de expiración cortos (1 hora máximo)
✅ **VERIFICAR** que el usuario tenga acceso al canal solicitado

## 🧪 Verificar Configuración

### 1. Verificar Endpoints del Backend

```bash
# Token de conexión
curl -X GET https://app.neek.mx/api/centrifugo/connection-token \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/json"

# Debería retornar:
# {"success": true, "data": {"token": "eyJhbGc...", "user_id": 1}}
```

```bash
# Token de suscripción
curl -X POST https://app.neek.mx/api/centrifugo/subscription-token \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"channel": "app_chat_test-uuid"}'

# Debería retornar:
# {"success": true, "data": {"token": "eyJhbGc...", "channel": "app_chat_test-uuid"}}
```

### 2. Verificar Servidor Centrifugo

```bash
# Verificar que Centrifugo esté corriendo
curl https://ws.neek.mx/health

# O verificar la API
curl -X POST https://ws.neek.mx/api \
  -H "Authorization: apikey YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"method": "info"}'
```

## 📚 Referencias

- [Centrifugo JWT Authentication](https://centrifugal.dev/docs/server/authentication)
- [Centrifugo Channel Permissions](https://centrifugal.dev/docs/server/channels)
- [PHP JWT Library](https://github.com/firebase/php-jwt)

---

**Última actualización:** Noviembre 2024

