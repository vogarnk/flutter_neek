# Implementación Backend Chat - Laravel

## Descripción General
Este documento describe la implementación del backend para el sistema de chat de la aplicación Neek, incluyendo las tablas de base de datos, modelos, controladores y endpoints necesarios.

## Estructura de Base de Datos

### 1. Tabla: `conversations`
```sql
CREATE TABLE conversations (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    session_id VARCHAR(255) NOT NULL,
    status ENUM('active', 'closed', 'waiting_agent') DEFAULT 'active',
    agent_id VARCHAR(36) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    closed_at TIMESTAMP NULL,
    
    INDEX idx_user_id (user_id),
    INDEX idx_session_id (session_id),
    INDEX idx_agent_id (agent_id),
    INDEX idx_status (status)
);
```

### 2. Tabla: `chat_messages`
```sql
CREATE TABLE chat_messages (
    id VARCHAR(36) PRIMARY KEY,
    conversation_id VARCHAR(36) NOT NULL,
    text TEXT NOT NULL,
    is_user BOOLEAN NOT NULL DEFAULT FALSE,
    file_path VARCHAR(500) NULL,
    file_name VARCHAR(255) NULL,
    file_type VARCHAR(50) NULL,
    is_read BOOLEAN DEFAULT FALSE,
    agent_id VARCHAR(36) NULL,
    agent_name VARCHAR(255) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE,
    INDEX idx_conversation_id (conversation_id),
    INDEX idx_is_user (is_user),
    INDEX idx_created_at (created_at),
    INDEX idx_agent_id (agent_id)
);
```

### 3. Tabla: `chat_agents` (Opcional - para gestión de agentes)
```sql
CREATE TABLE chat_agents (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    is_online BOOLEAN DEFAULT FALSE,
    is_available BOOLEAN DEFAULT TRUE,
    current_conversations_count INT DEFAULT 0,
    max_conversations INT DEFAULT 5,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_is_online (is_online),
    INDEX idx_is_available (is_available)
);
```

## Modelos Laravel

### 1. Modelo: `Conversation.php`
```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Conversation extends Model
{
    use HasFactory;

    protected $fillable = [
        'id',
        'user_id',
        'session_id',
        'status',
        'agent_id',
        'closed_at'
    ];

    protected $casts = [
        'closed_at' => 'datetime',
    ];

    public function messages(): HasMany
    {
        return $this->hasMany(ChatMessage::class);
    }

    public function agent(): BelongsTo
    {
        return $this->belongsTo(ChatAgent::class, 'agent_id');
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function getUnreadMessagesCountAttribute(): int
    {
        return $this->messages()->where('is_user', true)->where('is_read', false)->count();
    }
}
```

### 2. Modelo: `ChatMessage.php`
```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ChatMessage extends Model
{
    use HasFactory;

    protected $fillable = [
        'id',
        'conversation_id',
        'text',
        'is_user',
        'file_path',
        'file_name',
        'file_type',
        'is_read',
        'agent_id',
        'agent_name'
    ];

    protected $casts = [
        'is_user' => 'boolean',
        'is_read' => 'boolean',
    ];

    public function conversation(): BelongsTo
    {
        return $this->belongsTo(Conversation::class);
    }

    public function agent(): BelongsTo
    {
        return $this->belongsTo(ChatAgent::class, 'agent_id');
    }
}
```

### 3. Modelo: `ChatAgent.php`
```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class ChatAgent extends Model
{
    use HasFactory;

    protected $fillable = [
        'id',
        'name',
        'email',
        'is_online',
        'is_available',
        'current_conversations_count',
        'max_conversations'
    ];

    protected $casts = [
        'is_online' => 'boolean',
        'is_available' => 'boolean',
    ];

    public function conversations(): HasMany
    {
        return $this->hasMany(Conversation::class);
    }

    public function messages(): HasMany
    {
        return $this->hasMany(ChatMessage::class);
    }

    public function canTakeNewConversation(): bool
    {
        return $this->is_online && 
               $this->is_available && 
               $this->current_conversations_count < $this->max_conversations;
    }
}
```

## Controladores

### 1. Controlador: `ChatController.php`
```php
<?php

namespace App\Http\Controllers;

use App\Models\Conversation;
use App\Models\ChatMessage;
use App\Models\ChatAgent;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class ChatController extends Controller
{
    /**
     * Inicializar chat - crear conversación
     */
    public function initializeChat(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|string',
            'session_id' => 'nullable|string'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Datos de entrada inválidos',
                'errors' => $validator->errors()
            ], 400);
        }

        try {
            $sessionId = $request->session_id ?? 'session_' . time();
            
            $conversation = Conversation::create([
                'id' => Str::uuid(),
                'user_id' => $request->user_id,
                'session_id' => $sessionId,
                'status' => 'active'
            ]);

            // Mensaje de bienvenida
            $welcomeMessage = ChatMessage::create([
                'id' => Str::uuid(),
                'conversation_id' => $conversation->id,
                'text' => '¡Hola! Soy tu asistente virtual. ¿En qué puedo ayudarte hoy?',
                'is_user' => false,
                'is_read' => true
            ]);

            return response()->json([
                'success' => true,
                'conversation_id' => $conversation->id,
                'session_id' => $sessionId,
                'welcome_message' => $welcomeMessage
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al inicializar chat: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Obtener mensajes de una conversación
     */
    public function getMessages(Request $request, string $conversationId): JsonResponse
    {
        try {
            $conversation = Conversation::findOrFail($conversationId);
            
            $messages = $conversation->messages()
                ->orderBy('created_at', 'asc')
                ->get();

            return response()->json([
                'success' => true,
                'messages' => $messages
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener mensajes: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Enviar mensaje
     */
    public function sendMessage(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'conversation_id' => 'required|string',
            'text' => 'required|string|max:2000',
            'file' => 'nullable|file|mimes:jpg,jpeg,png,pdf|max:10240'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Datos de entrada inválidos',
                'errors' => $validator->errors()
            ], 400);
        }

        try {
            $conversation = Conversation::findOrFail($request->conversation_id);
            
            $filePath = null;
            $fileName = null;
            $fileType = null;

            // Manejar archivo adjunto
            if ($request->hasFile('file')) {
                $file = $request->file('file');
                $fileName = $file->getClientOriginalName();
                $fileType = $file->getClientOriginalExtension();
                $filePath = $file->store('chat_files', 'public');
            }

            // Crear mensaje del usuario
            $userMessage = ChatMessage::create([
                'id' => Str::uuid(),
                'conversation_id' => $conversation->id,
                'text' => $request->text,
                'is_user' => true,
                'file_path' => $filePath,
                'file_name' => $fileName,
                'file_type' => $fileType
            ]);

            // Simular respuesta del bot (aquí puedes integrar con IA o asignar a agente)
            $this->processBotResponse($conversation);

            return response()->json([
                'success' => true,
                'message' => $userMessage
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al enviar mensaje: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Marcar mensajes como leídos
     */
    public function markAsRead(Request $request, string $conversationId): JsonResponse
    {
        try {
            $conversation = Conversation::findOrFail($conversationId);
            
            $conversation->messages()
                ->where('is_user', true)
                ->where('is_read', false)
                ->update(['is_read' => true]);

            return response()->json([
                'success' => true,
                'message' => 'Mensajes marcados como leídos'
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al marcar mensajes: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Cerrar conversación
     */
    public function closeConversation(Request $request, string $conversationId): JsonResponse
    {
        try {
            $conversation = Conversation::findOrFail($conversationId);
            
            $conversation->update([
                'status' => 'closed',
                'closed_at' => now()
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Conversación cerrada'
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al cerrar conversación: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Procesar respuesta del bot
     */
    private function processBotResponse(Conversation $conversation): void
    {
        // Aquí puedes implementar lógica para:
        // 1. Asignar a un agente disponible
        // 2. Usar IA para respuesta automática
        // 3. Enviar notificación push
        
        $botMessage = ChatMessage::create([
            'id' => Str::uuid(),
            'conversation_id' => $conversation->id,
            'text' => 'Gracias por tu mensaje. Un agente humano se pondrá en contacto contigo pronto.',
            'is_user' => false,
            'is_read' => true
        ]);

        // Aquí puedes agregar lógica para asignar agente
        $this->assignAgentToConversation($conversation);
    }

    /**
     * Asignar agente a conversación
     */
    private function assignAgentToConversation(Conversation $conversation): void
    {
        $availableAgent = ChatAgent::where('is_online', true)
            ->where('is_available', true)
            ->where('current_conversations_count', '<', 'max_conversations')
            ->first();

        if ($availableAgent) {
            $conversation->update([
                'agent_id' => $availableAgent->id,
                'status' => 'waiting_agent'
            ]);

            $availableAgent->increment('current_conversations_count');
        }
    }
}
```

## Rutas API

### `routes/api.php`
```php
<?php

use App\Http\Controllers\ChatController;
use Illuminate\Support\Facades\Route;

// Rutas del chat
Route::prefix('chat')->group(function () {
    Route::post('/initialize', [ChatController::class, 'initializeChat']);
    Route::get('/conversations/{conversationId}/messages', [ChatController::class, 'getMessages']);
    Route::post('/send-message', [ChatController::class, 'sendMessage']);
    Route::put('/conversations/{conversationId}/mark-read', [ChatController::class, 'markAsRead']);
    Route::put('/conversations/{conversationId}/close', [ChatController::class, 'closeConversation']);
});
```

## Webhook para N8N

### Endpoint para recibir mensajes desde N8N
```php
// En ChatController.php
public function webhookMessage(Request $request): JsonResponse
{
    $validator = Validator::make($request->all(), [
        'conversation_id' => 'required|string',
        'message' => 'required|string',
        'agent_id' => 'nullable|string',
        'agent_name' => 'nullable|string'
    ]);

    if ($validator->fails()) {
        return response()->json([
            'success' => false,
            'message' => 'Datos de entrada inválidos',
            'errors' => $validator->errors()
        ], 400);
    }

    try {
        $conversation = Conversation::findOrFail($request->conversation_id);
        
        $message = ChatMessage::create([
            'id' => Str::uuid(),
            'conversation_id' => $conversation->id,
            'text' => $request->message,
            'is_user' => false,
            'agent_id' => $request->agent_id,
            'agent_name' => $request->agent_name,
            'is_read' => true
        ]);

        // Aquí puedes enviar notificación push al usuario
        $this->sendPushNotification($conversation, $message);

        return response()->json([
            'success' => true,
            'message' => 'Mensaje enviado correctamente'
        ]);

    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'message' => 'Error al procesar mensaje: ' . $e->getMessage()
        ], 500);
    }
}

private function sendPushNotification(Conversation $conversation, ChatMessage $message): void
{
    // Implementar envío de notificación push
    // Usar Firebase Cloud Messaging o similar
}
```

### Ruta para webhook
```php
// En routes/api.php
Route::post('/webhook/chat-message', [ChatController::class, 'webhookMessage']);
```

## Configuración de Archivos

### Configuración de Storage
```php
// En config/filesystems.php
'disks' => [
    'public' => [
        'driver' => 'local',
        'root' => storage_path('app/public'),
        'url' => env('APP_URL').'/storage',
        'visibility' => 'public',
    ],
],
```

### Migración para crear tablas
```bash
php artisan make:migration create_chat_tables
```

## Variables de Entorno

```env
# Chat Configuration
CHAT_MAX_FILE_SIZE=10240
CHAT_ALLOWED_FILE_TYPES=jpg,jpeg,png,pdf
CHAT_STORAGE_DISK=public

# N8N Webhook
N8N_WEBHOOK_URL=https://neek-n8n-n8n.qklkcq.easypanel.host/webhook-test/5a0a7e7e-7d94-4cae-8d97-611b6bf1918e
```

## Endpoints del Frontend Flutter

### URLs que debe usar el Flutter:
1. **Inicializar chat**: `POST /api/chat/initialize`
2. **Obtener mensajes**: `GET /api/chat/conversations/{id}/messages`
3. **Enviar mensaje**: `POST /api/chat/send-message`
4. **Marcar como leído**: `PUT /api/chat/conversations/{id}/mark-read`
5. **Cerrar conversación**: `PUT /api/chat/conversations/{id}/close`

### Webhook para N8N:
- **URL**: `POST /api/webhook/chat-message`

## Notas de Implementación

1. **Autenticación**: Agregar middleware de autenticación según tu sistema
2. **Rate Limiting**: Implementar límites de velocidad para evitar spam
3. **Validación**: Validar todos los inputs del usuario
4. **Logs**: Implementar logging para debugging
5. **Testing**: Crear tests unitarios y de integración
6. **WebSockets**: Considerar implementar WebSockets para mensajes en tiempo real
7. **Notificaciones Push**: Integrar con Firebase Cloud Messaging
8. **Backup**: Implementar backup automático de conversaciones

## Próximos Pasos

1. Crear las migraciones de base de datos
2. Implementar los modelos
3. Crear los controladores
4. Configurar las rutas
5. Implementar autenticación
6. Configurar el webhook con N8N
7. Implementar notificaciones push
8. Crear tests
9. Desplegar en producción
