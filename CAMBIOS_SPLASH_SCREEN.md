# Cambios en SplashScreen - Verificación de Primer Login

## Descripción

Se ha modificado el `SplashScreen` para verificar automáticamente si el usuario ya cambió su contraseña inicial y redirigir apropiadamente.

## Funcionalidad Implementada

### Flujo de Verificación

1. **Verificar token existente**
   - Si no hay token → Redirigir a Login
   - Si hay token → Continuar verificación

2. **Verificar estado del primer login**
   - Llamada a `FirstLoginService.checkFirstLoginStatus()`
   - Verifica si `requires_password_change = true`

3. **Redirección condicional**
   - Si requiere cambio de contraseña → `ChangePasswordScreen`
   - Si no requiere cambio → Verificar datos del usuario
   - Si datos válidos → `HomeScreen`
   - Si datos inválidos → `LoginScreen`

## Código Implementado

### Importaciones Agregadas
```dart
import 'core/first_login_service.dart';
import 'modules/register/change_password_screen.dart';
```

### Método `_checkToken()` Modificado
```dart
Future<void> _checkToken() async {
  await Future.delayed(const Duration(seconds: 3));

  final token = await _secureStorage.read(key: 'auth_token');

  if (token == null) {
    _goToLogin();
    return;
  }

  try {
    // Primero verificar el estado del primer login
    final firstLoginStatus = await FirstLoginService.instance.checkFirstLoginStatus();
    
    if (firstLoginStatus['success']) {
      final requiresPasswordChange = firstLoginStatus['requires_password_change'] ?? false;
      
      if (requiresPasswordChange) {
        // Usuario necesita cambiar su contraseña
        _goToChangePassword();
        return;
      } else {
        // Usuario ya cambió su contraseña, verificar datos del usuario
        final response = await ApiService.instance.get('/user');

        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          final userData = decoded['data'];
          _goToHome(userData);
        } else {
          await _secureStorage.delete(key: 'auth_token');
          _goToLogin();
        }
      }
    } else {
      // Error al verificar estado del primer login, intentar obtener datos del usuario
      final response = await ApiService.instance.get('/user');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final userData = decoded['data'];
        _goToHome(userData);
      } else {
        await _secureStorage.delete(key: 'auth_token');
        _goToLogin();
      }
    }
  } catch (e) {
    await _secureStorage.delete(key: 'auth_token');
    _goToLogin();
  }
}
```

### Método `_goToChangePassword()` Agregado
```dart
void _goToChangePassword() {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
  );
}
```

## Flujo Completo

### Escenario 1: Usuario Nuevo (Primer Login)
1. App inicia → SplashScreen
2. Verifica token → Existe
3. Verifica primer login → `requires_password_change = true`
4. Redirige a → `ChangePasswordScreen`
5. Usuario cambia contraseña → `SplashScreen` (nuevamente)
6. Verifica primer login → `requires_password_change = false`
7. Verifica datos usuario → Válidos
8. Redirige a → `HomeScreen`

### Escenario 2: Usuario Existente
1. App inicia → SplashScreen
2. Verifica token → Existe
3. Verifica primer login → `requires_password_change = false`
4. Verifica datos usuario → Válidos
5. Redirige a → `HomeScreen`

### Escenario 3: Token Inválido
1. App inicia → SplashScreen
2. Verifica token → No existe o inválido
3. Redirige a → `LoginScreen`

## Beneficios

### 1. **Seguridad Mejorada**
- Verificación automática del estado de contraseña
- Prevención de acceso sin cambio de contraseña inicial

### 2. **Experiencia de Usuario**
- Flujo automático sin interrupciones manuales
- Redirección inteligente según el estado del usuario

### 3. **Manejo de Errores**
- Fallback a verificación de datos de usuario si falla la verificación de primer login
- Limpieza automática de tokens inválidos

## Consideraciones

### 1. **Performance**
- Una llamada adicional al endpoint `/check-first-login-status`
- Fallback a verificación tradicional si falla

### 2. **Manejo de Errores**
- Si falla la verificación de primer login, intenta obtener datos del usuario
- Si falla todo, redirige a login y limpia token

### 3. **Compatibilidad**
- Mantiene compatibilidad con usuarios existentes
- No afecta el flujo tradicional de login

## Pruebas Recomendadas

- [ ] Usuario nuevo con token válido → Debe ir a cambio de contraseña
- [ ] Usuario existente con contraseña cambiada → Debe ir a home
- [ ] Token inválido → Debe ir a login
- [ ] Error de red → Debe manejar apropiadamente
- [ ] Usuario sin planes → Debe mostrar modal de planes

## Archivos Modificados

- ✅ `lib/splash_screen.dart` - Verificación de primer login agregada 