# Implementación del Backend del Chat en Laravel

## Descripción
Este documento describe cómo implementar el backend del chat en Laravel para la aplicación Flutter Neek. El sistema permite conversaciones entre usuarios y un bot inicialmente, con la posibilidad de que un agente humano tome el control.

## Endpoints de la API

### 1. Crear Conversación
```
POST /api/chat/conversation
```

**Body:**
```json
{
  "session_id": "string",
  "initial_message": "string (opcional)"
}
```

**Response (201):**
```json
{
  "conversation_id": "uuid",
  "status": "created",
  "message": "Conversación creada exitosamente"
}
```

### 2. Enviar Mensaje de Texto
```
POST /api/chat/message
```

**Body:**
```json
{
  "message": "string",
  "session_id": "string",
  "conversation_id": "string",
  "type": "text"
}
```

**Response (200):**
```json
{
  "message_id": "uuid",
  "conversation_id": "uuid",
  "response": "Respuesta del bot o agente",
  "is_bot": true,
  "timestamp": "2024-01-01T12:00:00Z",
  "agent_id": "uuid (opcional)",
  "agent_name": "Nombre del Agente (opcional)"
}
```

### 3. Enviar Archivo
```
POST /api/chat/file
```

**Form Data:**
- `file`: Archivo (jpg, jpeg, png, pdf)
- `session_id`: string
- `conversation_id`: string
- `message`: string (opcional)
- `type`: "file"

**Response (200):**
```json
{
  "message_id": "uuid",
  "conversation_id": "uuid",
  "response": "Archivo recibido correctamente",
  "is_bot": true,
  "timestamp": "2024-01-01T12:00:00Z"
}
```

### 4. Obtener Historial
```
GET /api/chat/history?conversation_id={id}&limit={limit}&offset={offset}
```

**Response (200):**
```json
{
  "messages": [
    {
      "id": "uuid",
      "text": "string",
      "is_user": true,
      "timestamp": "2024-01-01T12:00:00Z",
      "file_path": "string (opcional)",
      "file_name": "string (opcional)",
      "file_type": "string (opcional)",
      "conversation_id": "uuid",
      "is_read": false,
      "agent_id": "uuid (opcional)",
      "agent_name": "string (opcional)"
    }
  ]
}
```

### 5. Marcar Mensaje como Leído
```
PUT /api/chat/message/read
```

**Body:**
```json
{
  "message_id": "uuid",
  "conversation_id": "uuid"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Mensaje marcado como leído"
}
```

### 6. Obtener Estado de Conversación
```
GET /api/chat/conversation/{id}/status
```

**Response (200):**
```json
{
  "conversation_id": "uuid",
  "is_active": true,
  "is_bot_responding": false,
  "current_agent_id": "uuid",
  "current_agent_name": "Nombre del Agente",
  "last_activity": "2024-01-01T12:00:00Z",
  "unread_messages": 5
}
```

## Estructura de la Base de Datos

### Tabla: conversations
```sql
CREATE TABLE conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id VARCHAR(255) NOT NULL,
    status ENUM('active', 'closed', 'pending') DEFAULT 'active',
    current_agent_id UUID NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Tabla: chat_messages
```sql
CREATE TABLE chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL,
    text TEXT NOT NULL,
    is_user BOOLEAN NOT NULL DEFAULT false,
    file_path VARCHAR(500) NULL,
    file_name VARCHAR(255) NULL,
    file_type VARCHAR(50) NULL,
    agent_id UUID NULL,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conversation_id) REFERENCES conversations(id),
    FOREIGN KEY (agent_id) REFERENCES users(id)
);
```

### Tabla: agents
```sql
CREATE TABLE agents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    status ENUM('online', 'offline', 'busy') DEFAULT 'offline',
    max_conversations INT DEFAULT 5,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Lógica del Bot

### 1. Respuestas Automáticas
El bot debe responder automáticamente a mensajes comunes:

- **Saludos**: "¡Hola! ¿En qué puedo ayudarte?"
- **Despedidas**: "¡Que tengas un buen día!"
- **Agradecimientos**: "De nada, estoy aquí para ayudarte"
- **Preguntas frecuentes**: Respuestas predefinidas para temas comunes

### 2. Escalación a Agente Humano
El bot debe escalar a un agente humano cuando:

- El usuario solicita específicamente hablar con alguien
- Se detecta frustración en el usuario
- El bot no puede responder adecuadamente
- Han pasado más de 5 mensajes en la conversación

### 3. Asignación de Agentes
```php
public function assignAgentToConversation($conversationId)
{
    $availableAgent = Agent::where('status', 'online')
        ->where('current_conversations', '<', 'max_conversations')
        ->orderBy('current_conversations', 'asc')
        ->first();
    
    if ($availableAgent) {
        Conversation::where('id', $conversationId)
            ->update(['current_agent_id' => $availableAgent->id]);
        
        $availableAgent->increment('current_conversations');
        
        return $availableAgent;
    }
    
    return null;
}
```

## Implementación en Laravel

### 1. Modelos

**Conversation.php:**
```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Conversation extends Model
{
    protected $fillable = [
        'session_id',
        'status',
        'current_agent_id'
    ];

    public function messages(): HasMany
    {
        return $this->hasMany(ChatMessage::class);
    }

    public function agent()
    {
        return $this->belongsTo(Agent::class, 'current_agent_id');
    }
}
```

**ChatMessage.php:**
```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ChatMessage extends Model
{
    protected $fillable = [
        'conversation_id',
        'text',
        'is_user',
        'file_path',
        'file_name',
        'file_type',
        'agent_id',
        'is_read'
    ];

    protected $casts = [
        'is_user' => 'boolean',
        'is_read' => 'boolean'
    ];

    public function conversation(): BelongsTo
    {
        return $this->belongsTo(Conversation::class);
    }

    public function agent(): BelongsTo
    {
        return $this->belongsTo(Agent::class);
    }
}
```

### 2. Controlador

**ChatController.php:**
```php
<?php

namespace App\Http\Controllers;

use App\Models\Conversation;
use App\Models\ChatMessage;
use App\Services\ChatBotService;
use App\Services\FileUploadService;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class ChatController extends Controller
{
    public function __construct(
        private ChatBotService $chatBotService,
        private FileUploadService $fileUploadService
    ) {}

    public function createConversation(Request $request): JsonResponse
    {
        $request->validate([
            'session_id' => 'required|string',
            'initial_message' => 'nullable|string'
        ]);

        $conversation = Conversation::create([
            'session_id' => $request->session_id,
            'status' => 'active'
        ]);

        if ($request->initial_message) {
            $this->chatBotService->processMessage(
                $request->initial_message,
                $conversation->id
            );
        }

        return response()->json([
            'conversation_id' => $conversation->id,
            'status' => 'created'
        ], 201);
    }

    public function sendMessage(Request $request): JsonResponse
    {
        $request->validate([
            'message' => 'required|string',
            'session_id' => 'required|string',
            'conversation_id' => 'required|string',
            'type' => 'required|in:text'
        ]);

        $conversation = Conversation::findOrFail($request->conversation_id);
        
        // Guardar mensaje del usuario
        $userMessage = ChatMessage::create([
            'conversation_id' => $conversation->id,
            'text' => $request->message,
            'is_user' => true
        ]);

        // Procesar con bot o agente
        $response = $this->chatBotService->processMessage(
            $request->message,
            $conversation->id
        );

        return response()->json($response);
    }

    public function sendFile(Request $request): JsonResponse
    {
        $request->validate([
            'file' => 'required|file|mimes:jpg,jpeg,png,pdf|max:10240',
            'session_id' => 'required|string',
            'conversation_id' => 'required|string',
            'message' => 'nullable|string'
        ]);

        $conversation = Conversation::findOrFail($request->conversation_id);
        
        // Subir archivo
        $filePath = $this->fileUploadService->uploadFile($request->file, 'chat');
        
        // Guardar mensaje con archivo
        $fileMessage = ChatMessage::create([
            'conversation_id' => $conversation->id,
            'text' => $request->message ?? 'Archivo enviado',
            'is_user' => true,
            'file_path' => $filePath,
            'file_name' => $request->file->getClientOriginalName(),
            'file_type' => $request->file->getClientOriginalExtension()
        ]);

        // Procesar respuesta
        $response = $this->chatBotService->processFileMessage($fileMessage);

        return response()->json($response);
    }

    public function getHistory(Request $request): JsonResponse
    {
        $request->validate([
            'conversation_id' => 'required|string',
            'limit' => 'nullable|integer|min:1|max:100',
            'offset' => 'nullable|integer|min:0'
        ]);

        $query = ChatMessage::where('conversation_id', $request->conversation_id)
            ->orderBy('created_at', 'asc');

        if ($request->limit) {
            $query->limit($request->limit);
        }

        if ($request->offset) {
            $query->offset($request->offset);
        }

        $messages = $query->get();

        return response()->json(['messages' => $messages]);
    }

    public function markAsRead(Request $request): JsonResponse
    {
        $request->validate([
            'message_id' => 'required|string',
            'conversation_id' => 'required|string'
        ]);

        ChatMessage::where('id', $request->message_id)
            ->where('conversation_id', $request->conversation_id)
            ->update(['is_read' => true]);

        return response()->json(['success' => true]);
    }

    public function getStatus(string $conversationId): JsonResponse
    {
        $conversation = Conversation::with('agent')->findOrFail($conversationId);
        
        $unreadCount = ChatMessage::where('conversation_id', $conversationId)
            ->where('is_user', true)
            ->where('is_read', false)
            ->count();

        return response()->json([
            'conversation_id' => $conversation->id,
            'is_active' => $conversation->status === 'active',
            'is_bot_responding' => $conversation->current_agent_id === null,
            'current_agent_id' => $conversation->current_agent_id,
            'current_agent_name' => $conversation->agent?->name,
            'last_activity' => $conversation->updated_at,
            'unread_messages' => $unreadCount
        ]);
    }
}
```

### 3. Servicio del Bot

**ChatBotService.php:**
```php
<?php

namespace App\Services;

use App\Models\Conversation;
use App\Models\ChatMessage;
use App\Models\Agent;

class ChatBotService
{
    public function processMessage(string $message, string $conversationId): array
    {
        $conversation = Conversation::find($conversationId);
        
        // Verificar si necesita escalación
        if ($this->shouldEscalateToHuman($message, $conversation)) {
            $agent = $this->assignAgentToConversation($conversationId);
            
            $response = $this->escalateToHuman($conversationId, $agent);
        } else {
            $response = $this->generateBotResponse($message);
        }

        // Guardar respuesta del bot
        ChatMessage::create([
            'conversation_id' => $conversationId,
            'text' => $response['text'],
            'is_user' => false,
            'agent_id' => $response['agent_id'] ?? null
        ]);

        return $response;
    }

    private function shouldEscalateToHuman(string $message, Conversation $conversation): bool
    {
        // Lógica para determinar si escalar
        $escalationKeywords = ['agente', 'humano', 'persona', 'ayuda'];
        $hasEscalationKeyword = collect($escalationKeywords)->contains(function($keyword) use ($message) {
            return stripos($message, $keyword) !== false;
        });

        $messageCount = $conversation->messages()->count();
        
        return $hasEscalationKeyword || $messageCount >= 5;
    }

    private function generateBotResponse(string $message): array
    {
        // Respuestas predefinidas del bot
        $responses = [
            'hola' => '¡Hola! ¿En qué puedo ayudarte hoy?',
            'gracias' => '¡De nada! Estoy aquí para ayudarte.',
            'adiós' => '¡Que tengas un buen día!',
            'ayuda' => 'Puedo ayudarte con información sobre seguros, cotizaciones y más. ¿Qué necesitas?'
        ];

        $messageLower = strtolower($message);
        
        foreach ($responses as $keyword => $response) {
            if (strpos($messageLower, $keyword) !== false) {
                return [
                    'text' => $response,
                    'is_bot' => true
                ];
            }
        }

        return [
            'text' => 'Entiendo tu consulta. Déjame buscar la información más adecuada para ti.',
            'is_bot' => true
        ];
    }

    private function escalateToHuman(string $conversationId, ?Agent $agent): array
    {
        if ($agent) {
            return [
                'text' => "Te he conectado con {$agent->name}, un agente especializado que te ayudará personalmente.",
                'is_bot' => false,
                'agent_id' => $agent->id,
                'agent_name' => $agent->name
            ];
        } else {
            return [
                'text' => 'Todos nuestros agentes están ocupados en este momento. Te pondremos en cola y te contactaremos pronto.',
                'is_bot' => true
            ];
        }
    }

    private function assignAgentToConversation(string $conversationId): ?Agent
    {
        $availableAgent = Agent::where('status', 'online')
            ->where('current_conversations', '<', 'max_conversations')
            ->orderBy('current_conversations', 'asc')
            ->first();
        
        if ($availableAgent) {
            Conversation::where('id', $conversationId)
                ->update(['current_agent_id' => $availableAgent->id]);
            
            $availableAgent->increment('current_conversations');
            
            return $availableAgent;
        }
        
        return null;
    }
}
```

## Configuración de Rutas

**routes/api.php:**
```php
Route::prefix('chat')->group(function () {
    Route::post('/conversation', [ChatController::class, 'createConversation']);
    Route::post('/message', [ChatController::class, 'sendMessage']);
    Route::post('/file', [ChatController::class, 'sendFile']);
    Route::get('/history', [ChatController::class, 'getHistory']);
    Route::put('/message/read', [ChatController::class, 'markAsRead']);
    Route::get('/conversation/{id}/status', [ChatController::class, 'getStatus']);
});
```

## Consideraciones de Seguridad

1. **Autenticación**: Usar middleware de autenticación para proteger las rutas
2. **Validación**: Validar todos los inputs del usuario
3. **Rate Limiting**: Implementar límites de velocidad para evitar spam
4. **Sanitización**: Sanitizar mensajes antes de almacenarlos
5. **Logs**: Registrar todas las conversaciones para auditoría

## Monitoreo y Analytics

1. **Métricas del Bot**: Tiempo de respuesta, tasa de resolución
2. **Escalaciones**: Frecuencia y causas de escalación a agentes humanos
3. **Satisfacción**: Encuestas de satisfacción del usuario
4. **Performance**: Tiempo de respuesta de la API

## Próximos Pasos

1. Implementar WebSockets para chat en tiempo real
2. Agregar notificaciones push para mensajes nuevos
3. Implementar sistema de tickets para seguimiento
4. Agregar análisis de sentimientos para mejor escalación
5. Integrar con sistemas de CRM existentes
