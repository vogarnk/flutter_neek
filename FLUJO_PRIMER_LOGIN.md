# Flujo de Primer Login - Implementación en Flutter

## Descripción General

Este documento describe la implementación del flujo de primer login en la aplicación Flutter de Neek, que incluye:

1. **Registro con inicio de sesión automático**
2. **Cambio de contraseña obligatorio**
3. **Validación de seguridad en tiempo real**

## Arquitectura Implementada

### 1. Servicios

#### `FirstLoginService` (`lib/core/first_login_service.dart`)
- **`checkFirstLoginStatus()`**: Verifica si el usuario necesita cambiar su contraseña
- **`changeFirstPassword()`**: Cambia la contraseña inicial del usuario
- **`validatePassword()`**: Valida que la contraseña cumpla con los requisitos de seguridad
- **`getPasswordValidationDetails()`**: Obtiene detalles específicos de validación

### 2. Pantallas

#### `ChangePasswordScreen` (`lib/modules/register/change_password_screen.dart`)
- Pantalla dedicada para el cambio de contraseña inicial
- Validación en tiempo real de requisitos de seguridad
- Interfaz intuitiva con feedback visual
- Manejo de errores y estados de carga

### 3. Flujo de Registro Modificado

#### `PlanSuccessScreen` (`lib/modules/register/plan_success_screen.dart`)
- Detecta si la respuesta del registro incluye un token
- Guarda automáticamente el token de autenticación
- Redirige a la pantalla de cambio de contraseña si es necesario

#### `LoginScreen` (`lib/auth/login_screen.dart`)
- Verifica si el login requiere cambio de contraseña
- Redirige apropiadamente según el estado del usuario

## Flujo de Usuario

### Escenario 1: Registro Nuevo (Recomendado)

1. **Usuario completa el registro**
   - Llena todos los formularios de registro
   - Envía datos al endpoint `/api/register`

2. **Respuesta del servidor incluye token**
   ```json
   {
     "token": "1|abc123...",
     "user": {
       "id": 1,
       "name": "Juan",
       "email": "juan@ejemplo.com",
       "first_login": 1
     },
     "requires_password_change": true
   }
   ```

3. **Aplicación guarda token automáticamente**
   - Token se almacena en `FlutterSecureStorage`
   - Usuario queda autenticado inmediatamente

4. **Redirección a cambio de contraseña**
   - Si `requires_password_change: true`
   - Usuario ve `ChangePasswordScreen`

5. **Usuario cambia contraseña**
   - Valida requisitos en tiempo real
   - Envía nueva contraseña al endpoint `/api/change-first-password`
   - `first_login` se establece en `0`

6. **Redirección a aplicación principal**
   - Usuario accede a `HomeScreen`
   - Flujo completo sin interrupciones

### Escenario 2: Login Tradicional

1. **Usuario hace login**
   - Usa credenciales temporales del email
   - Endpoint `/api/login` responde con estado

2. **Verificación de primer login**
   ```json
   {
     "token": "1|abc123...",
     "user": { ... },
     "requires_password_change": true
   }
   ```

3. **Redirección condicional**
   - Si requiere cambio: `ChangePasswordScreen`
   - Si no requiere: `HomeScreen` directamente

## Requisitos de Seguridad

### Validación de Contraseña

La contraseña debe cumplir con:

- ✅ **Mínimo 10 caracteres**
- ✅ **Al menos una letra mayúscula**
- ✅ **Al menos una letra minúscula**
- ✅ **Al menos un número**
- ✅ **Al menos un carácter especial (!@#?$)**

### Validación en Tiempo Real

La aplicación muestra feedback visual en tiempo real:

```dart
Widget _buildRequirement(String text, bool isValid) {
  return Row(
    children: [
      Icon(
        isValid ? Icons.check_circle : Icons.circle_outlined,
        color: isValid ? Colors.green : AppColors.textGray400,
      ),
      Text(text, style: TextStyle(color: isValid ? Colors.green : AppColors.textGray500)),
    ],
  );
}
```

## Endpoints Utilizados

### 1. Registro con Token
```
POST /api/register
```

**Respuesta esperada:**
```json
{
  "token": "1|abc123...",
  "user": { ... },
  "requires_password_change": true
}
```

### 2. Verificación de Estado
```
GET /api/check-first-login-status
```

**Headers requeridos:**
```
Authorization: Bearer {token}
```

### 3. Cambio de Contraseña
```
POST /api/change-first-password
```

**Headers requeridos:**
```
Authorization: Bearer {token}
```

**Body:**
```json
{
  "password": "NuevaContraseña123!",
  "password_confirmation": "NuevaContraseña123!"
}
```

## Manejo de Errores

### Errores de Validación
- **Contraseña débil**: Muestra requisitos específicos
- **Contraseñas no coinciden**: Feedback inmediato
- **Token inválido**: Redirección a login

### Errores de Red
- **Timeout**: Reintento automático
- **Sin conexión**: Mensaje informativo
- **Servidor no disponible**: Opción de reintentar

## Estados de la Aplicación

### 1. Estado de Carga
```dart
bool _isLoading = true;
// Muestra CircularProgressIndicator
```

### 2. Estado de Error
```dart
String? _errorMessage;
// Muestra SnackBar o AlertDialog
```

### 3. Estado de Validación
```dart
bool _hasMinLength = false;
bool _hasUpperCase = false;
// ... otros estados de validación
```

## Consideraciones de UX

### 1. Feedback Visual
- **Iconos de validación**: ✅ para cumplido, ⭕ para pendiente
- **Colores**: Verde para éxito, gris para pendiente
- **Animaciones**: Transiciones suaves entre estados

### 2. Accesibilidad
- **Labels descriptivos**: "Nueva contraseña", "Confirmar contraseña"
- **Mensajes claros**: Explicación de requisitos
- **Navegación intuitiva**: Flujo lineal sin saltos

### 3. Seguridad
- **Ocultar contraseña**: Toggle de visibilidad
- **Validación inmediata**: Sin esperar submit
- **Token seguro**: Almacenamiento en FlutterSecureStorage

## Pruebas Recomendadas

### 1. Flujo Completo
- [ ] Registro nuevo → Token → Cambio contraseña → Home
- [ ] Login existente → Cambio contraseña → Home
- [ ] Login normal → Home directo

### 2. Validaciones
- [ ] Contraseña débil (menos de 10 caracteres)
- [ ] Sin mayúsculas
- [ ] Sin números
- [ ] Sin caracteres especiales
- [ ] Contraseñas no coinciden

### 3. Errores
- [ ] Sin conexión a internet
- [ ] Token inválido
- [ ] Servidor no disponible
- [ ] Código de verificación incorrecto

## Configuración del Backend

Para que este flujo funcione correctamente, el backend debe:

1. **Generar contraseña temporal** durante el registro
2. **Establecer `first_login = 1`** para usuarios nuevos
3. **Devolver token inmediatamente** en el registro
4. **Incluir `requires_password_change`** en las respuestas
5. **Validar requisitos** en el endpoint de cambio de contraseña

## Archivos Modificados

- ✅ `lib/modules/register/change_password_screen.dart` (NUEVO)
- ✅ `lib/modules/register/plan_success_screen.dart` (MODIFICADO)
- ✅ `lib/auth/login_screen.dart` (MODIFICADO)
- ✅ `lib/core/first_login_service.dart` (NUEVO)

## Próximos Pasos

1. **Testing exhaustivo** del flujo completo
2. **Optimización de UX** basada en feedback
3. **Implementación de analytics** para medir conversión
4. **Consideración de flujos alternativos** para casos edge 