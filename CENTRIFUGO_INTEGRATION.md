# Integración de Centrifugo con Flutter - Chat en Tiempo Real

## 📋 Descripción

Este documento describe la integración de Centrifugo WebSocket en la aplicación Flutter para recibir mensajes de chat en tiempo real. La implementación permite que múltiples usuarios se conecten simultáneamente y reciban actualizaciones instantáneas.

## 🚀 Características Implementadas

- ✅ Conexión WebSocket con Centrifugo
- ✅ Servicio Singleton para compartir conexión entre múltiples vistas
- ✅ Suscripción dinámica a canales de conversación
- ✅ Manejo automático de reconexión
- ✅ Indicador visual del estado de conexión
- ✅ Detección de mensajes duplicados
- ✅ Soporte para múltiples usuarios simultáneos

## 📦 Dependencias Instaladas

```yaml
dependencies:
  centrifuge: ^0.11.0  # Cliente WebSocket de Centrifugo
  http: ^1.1.0         # Peticiones HTTP (ya existente)
```

## 🏗️ Arquitectura

### 1. CentrifugoService (Singleton)

**Ubicación:** `/lib/core/centrifugo_service.dart`

El servicio principal que maneja:
- Conexión única con el servidor Centrifugo
- Gestión de múltiples suscripciones a canales
- Callbacks para eventos de conexión/desconexión
- Extracción automática del user_id del token JWT

#### Métodos Principales:

```dart
// Conectar al servidor WebSocket
await CentrifugoService().connect(
  onConnected: () => print('Conectado'),
  onDisconnected: () => print('Desconectado'),
);

// Suscribirse a un canal de conversación
await CentrifugoService().subscribeToConversation(
  conversationId,
  onMessage: (message) => print('Mensaje: $message'),
);

// Suscribirse al canal de conversaciones del usuario
await CentrifugoService().subscribeToUserConversations(
  onUpdate: (update) => print('Actualización: $update'),
);

// Desuscribirse de un canal
await CentrifugoService().unsubscribe(channel);

// Desconectar completamente
await CentrifugoService().disconnect();
```

### 2. ChatScreen (Implementación)

**Ubicación:** `/lib/modules/chat/chat_screen.dart`

Integra el servicio de Centrifugo con:
- Inicialización automática de WebSocket al abrir el chat
- Suscripción automática al canal de la conversación actual
- Manejo de mensajes entrantes en tiempo real
- Indicador visual de conexión en el AppBar
- Prevención de mensajes duplicados

## 🔌 Configuración del Servidor

### Credenciales de Centrifugo

```
URL WebSocket: wss://ws.neek.mx/connection/websocket
API Base URL: https://app.neek.mx/api
```

### Endpoints del Backend Laravel

1. **Obtener Token de Conexión**
   ```
   GET /api/centrifugo/connection-token
   Authorization: Bearer {token}
   ```

2. **Obtener Token de Suscripción**
   ```
   POST /api/centrifugo/subscription-token
   Content-Type: application/json
   
   {
     "channel": "app_chat_{conversationId}"
   }
   ```

3. **Obtener Canales Disponibles**
   ```
   GET /api/centrifugo/channels
   Authorization: Bearer {token}
   ```

## 📺 Tipos de Canales

### 1. Canal de Conversación Específica
```
Formato: app_chat_{conversationId}
Ejemplo: app_chat_550e8400-e29b-41d4-a716-446655440000
```

Recibe mensajes nuevos en tiempo real para una conversación específica.

**Estructura del mensaje:**
```json
{
  "id": "uuid",
  "conversation_id": "uuid",
  "text": "Mensaje de texto",
  "is_user": true,
  "file_path": null,
  "file_name": null,
  "file_type": null,
  "file_url": null,
  "is_read": false,
  "agent_id": null,
  "agent_name": null,
  "metadata": {},
  "created_at": "2024-01-01T12:00:00.000000Z"
}
```

### 2. Canal de Conversaciones del Usuario
```
Formato: conversations_{userId}
Ejemplo: conversations_123
```

Recibe actualizaciones de todas las conversaciones del usuario.

**Estructura de actualización:**
```json
{
  "type": "new_message",
  "conversation_id": "uuid",
  "message": { /* objeto mensaje */ },
  "unread_count": 5
}
```

## 🔄 Flujo de Funcionamiento

### Inicialización del Chat

1. Usuario abre `ChatScreen`
2. Se ejecuta `_initializeChat()` para cargar mensajes del API
3. Simultáneamente se ejecuta `_initializeCentrifugo()`
4. El servicio se conecta al servidor WebSocket
5. Una vez conectado, se suscribe al canal de la conversación

### Envío de Mensaje

1. Usuario escribe y envía mensaje
2. Mensaje se envía al backend vía HTTP
3. Backend guarda el mensaje y lo publica en Centrifugo
4. WebSocket recibe el mensaje y lo muestra en tiempo real
5. Se marca la conversación como leída automáticamente

### Recepción de Mensaje

1. WebSocket recibe publicación en el canal
2. `_handleWebSocketMessage()` procesa el mensaje
3. Verifica que no sea duplicado
4. Agrega mensaje a la lista
5. Hace scroll automático al final
6. Marca como leído

## 🎨 UI/UX

### Indicador de Conexión

En el `AppBar` del chat se muestra:
- **Verde "En línea"**: Conectado al WebSocket
- **Gris "Offline"**: Sin conexión WebSocket

El chat funciona en modo offline usando solo HTTP si WebSocket falla.

### Prevención de Duplicados

El sistema verifica que no se agreguen mensajes duplicados:
- Al recibir por WebSocket
- Al enviar manualmente

## 🛠️ Instalación

1. **Instalar dependencias:**
   ```bash
   flutter pub get
   ```

2. **Verificar configuración del backend:**
   - Asegúrate que los endpoints de Centrifugo estén implementados
   - Verifica que el servidor Centrifugo esté corriendo en `ws.neek.mx`

3. **Probar la integración:**
   ```bash
   flutter run
   ```

## 🧪 Pruebas

### Escenarios a Probar

1. **Conexión Inicial**
   - [ ] Abrir chat y verificar indicador "En línea"
   - [ ] Ver logs de conexión exitosa

2. **Envío de Mensajes**
   - [ ] Enviar mensaje y verificar que aparezca
   - [ ] Verificar que no haya duplicados

3. **Recepción de Mensajes**
   - [ ] Recibir respuesta del bot en tiempo real
   - [ ] Verificar scroll automático

4. **Múltiples Usuarios**
   - [ ] Abrir chat con 2 usuarios diferentes
   - [ ] Enviar mensaje desde uno
   - [ ] Verificar que ambos lo reciban

5. **Reconexión**
   - [ ] Desconectar internet
   - [ ] Verificar indicador "Offline"
   - [ ] Reconectar internet
   - [ ] Verificar que vuelva a "En línea"

6. **Múltiples Conversaciones**
   - [ ] Abrir varias conversaciones
   - [ ] Verificar que cada una reciba solo sus mensajes

## 🐛 Solución de Problemas

### No se conecta a WebSocket

**Posibles causas:**
1. Token de autenticación inválido
2. Servidor Centrifugo no disponible
3. Error en endpoints del backend
4. No se puede extraer user_id del token

**Solución:**
```bash
# Verificar logs
flutter run
# Buscar líneas con [Centrifugo]
```

**Error: "No se pudo obtener el user ID del token"**

Este error ocurre cuando el token almacenado no es un JWT válido. La solución ya está implementada:

1. El sistema intenta extraer el `user_id` del token JWT
2. Si falla, obtiene el `user_id` desde el endpoint `/api/user` (fallback automático)
3. Con el `user_id`, solicita el token HMAC de conexión al backend
4. Se conecta usando el token HMAC generado por el servidor

**Logs correctos:**
```
🔍 [Centrifugo] Extrayendo user_id del token JWT
⚠️ [Centrifugo] Token no tiene formato JWT válido
🔄 [Centrifugo] Intentando obtener user_id desde API...
✅ [Centrifugo] User ID obtenido desde API: 1
📥 [Centrifugo] Respuesta token conexión: 200
✅ [Centrifugo] Token de conexión obtenido
✅ [Centrifugo] Conectado exitosamente
```

### Mensajes duplicados

**Posibles causas:**
1. Backend publica el mensaje dos veces
2. Lógica de deduplicación no funciona

**Solución:**
- Verificar que el backend publique solo una vez
- Revisar logs: "⚠️ [ChatScreen] Mensaje duplicado, ignorando"

### No recibe mensajes en tiempo real

**Posibles causas:**
1. No está suscrito al canal correcto
2. Formato del canal incorrecto
3. Token de suscripción inválido

**Solución:**
```dart
// Verificar formato del canal
print('Canal: app_chat_$conversationId');
// Debe usar guión bajo _, no dos puntos :
```

## 📝 Notas Importantes

1. **Singleton:** El `CentrifugoService` es un singleton, por lo que se comparte entre todas las vistas. No se desconecta al cerrar una vista individual.

2. **Formato de Canales:** Los canales usan guión bajo `_` (no dos puntos `:`)
   - ✅ Correcto: `app_chat_uuid`
   - ❌ Incorrecto: `app_chat:uuid`

3. **Tokens HMAC:** 
   - Los tokens de conexión y suscripción se generan en el **backend** usando HMAC
   - El cliente **NUNCA** genera tokens, solo los solicita al backend
   - Los tokens expiran después de 1 hora por seguridad
   - Lee `CENTRIFUGO_HMAC_FLOW.md` para más detalles

4. **User ID:** 
   - Se intenta extraer del token JWT primero
   - Si falla, se obtiene automáticamente desde `/api/user` (fallback)
   - Esto garantiza que siempre funcione independientemente del tipo de token

5. **Fallback:** Si WebSocket falla, el chat sigue funcionando con HTTP polling (botón refresh).

6. **Múltiples Vistas:** Puedes usar el mismo servicio en diferentes vistas suscribiéndote a diferentes canales.

## 🔮 Próximas Mejoras

- [ ] Implementar indicador de "escribiendo..."
- [ ] Agregar presencia de usuarios en línea
- [ ] Soporte para notificaciones push cuando llega mensaje
- [ ] Sincronización automática al volver de background
- [ ] Soporte para canales de WhatsApp (futuro)

## 📚 Referencias

- [Centrifugo Documentation](https://centrifugal.dev/)
- [Centrifuge Dart Package](https://pub.dev/packages/centrifuge)
- [WebSocket Protocol](https://datatracker.ietf.org/doc/html/rfc6455)

---

**Última actualización:** Noviembre 2024
**Versión de Centrifuge:** 0.11.0
**Autor:** Eduardo - Neek App

