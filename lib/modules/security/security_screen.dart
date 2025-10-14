import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/theme/app_colors.dart';
import '../security/change_password_screen.dart';
import '../security/biometric_setup_screen.dart';
import '../../core/security_api_service.dart';
import '../../models/user_session_model.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  List<UserSession> _sessions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    try {
      print('🔍 [SecurityScreen] Cargando sesiones...');
      final data = await SecurityApiService.instance.getSessions();
      print('✅ [SecurityScreen] Sesiones cargadas: ${data.length}');
      setState(() {
        _sessions = data;
        _loading = false;
      });
    } catch (e) {
      print('❌ [SecurityScreen] Error al cargar sesiones: $e');
      setState(() => _loading = false);
      
      String errorMessage = 'Error al cargar sesiones';
      if (e.toString().contains('Token de autenticación')) {
        errorMessage = 'Sesión expirada. Por favor, inicia sesión nuevamente.';
      } else if (e.toString().contains('No se encontró el token')) {
        errorMessage = 'No se encontró el token de autenticación.';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _closeSession(String sessionId) async {
    try {
      print('🔍 [SecurityScreen] Cerrando sesión: $sessionId');
      final success = await SecurityApiService.instance.closeSession(sessionId);
      if (success) {
        print('✅ [SecurityScreen] Sesión cerrada exitosamente');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesión cerrada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        _loadSessions(); // recarga la lista actualizada
      } else {
        print('❌ [SecurityScreen] No se pudo cerrar la sesión');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo cerrar la sesión'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ [SecurityScreen] Error al cerrar sesión: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cerrar sesión: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showDeactivateAccountDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Desactivar cuenta',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¿Estás seguro de que quieres desactivar tu cuenta?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Esta acción es IRREVERSIBLE y tendrá las siguientes consecuencias:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Tu cuenta será desactivada permanentemente\n'
                '• Todos tus tokens de acceso serán revocados\n'
                '• Perderás acceso a todos tus datos\n'
                '• No podrás recuperar tu cuenta',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Si necesitas ayuda, contacta al área de Clientes.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deactivateAccount();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Desactivar cuenta',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deactivateAccount() async {
    try {
      print('🔍 [SecurityScreen] Desactivando cuenta...');
      
      // Mostrar indicador de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final result = await SecurityApiService.instance.deactivateAccount();
      
      // Cerrar indicador de carga
      Navigator.of(context).pop();
      
      if (result['success']) {
        print('✅ [SecurityScreen] Cuenta desactivada exitosamente');
        
        // Mostrar mensaje de éxito y cerrar sesión
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        
        // Limpiar datos locales y redirigir al login
        await _clearUserData();
        _redirectToLogin();
      } else {
        print('❌ [SecurityScreen] No se pudo desactivar la cuenta');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ [SecurityScreen] Error al desactivar cuenta: $e');
      
      // Cerrar indicador de carga si está abierto
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      String errorMessage = 'Error al desactivar la cuenta';
      if (e.toString().contains('Token de autenticación')) {
        errorMessage = 'Sesión expirada. Por favor, inicia sesión nuevamente.';
      } else if (e.toString().contains('No se encontró el token')) {
        errorMessage = 'No se encontró el token de autenticación.';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _clearUserData() async {
    try {
      const storage = FlutterSecureStorage();
      await storage.deleteAll();
      print('✅ [SecurityScreen] Datos del usuario eliminados');
    } catch (e) {
      print('❌ [SecurityScreen] Error al limpiar datos: $e');
    }
  }

  void _redirectToLogin() {
    // Navegar a la pantalla de login y limpiar el stack
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Seguridad'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🔐 Dispositivos conectados
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.textWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dispositivos conectados',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textGray900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_sessions.length}/5 Dispositivos activos',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_loading)
                    const Center(child: CircularProgressIndicator())
                  else if (_sessions.isEmpty)
                    Column(
                      children: [
                        const Icon(
                          Icons.devices_other,
                          size: 48,
                          color: AppColors.textGray400,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No hay sesiones activas',
                          style: TextStyle(
                            color: AppColors.textGray500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _loadSessions,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Recargar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: _sessions.map(_buildDeviceTile).toList(),
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    'Por tu seguridad tu cuenta puede estar conectada a máximo 5 dispositivos',
                    style: TextStyle(color: AppColors.textGray500, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 🔐 Autenticación biométrica
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.textWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Autenticación biométrica',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textGray900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Face ID o huella dactilar',
                    style: TextStyle(
                      color: AppColors.textGray400,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BiometricSetupScreen(),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Configurar biometría',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.textGray900,
                          ),
                        ),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 🔒 Contraseña
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.textWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contraseña',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textGray900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Cambia o configura tu contraseña',
                    style: TextStyle(
                      color: AppColors.textGray400,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Contraseña actual',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textGray900,
                        ),
                      ),
                      Text(
                        '••••••••',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textGray500,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cambiar contraseña',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.textGray900,
                          ),
                        ),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ❌ Eliminar mi cuenta
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.textWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Eliminar mi cuenta',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textGray900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text.rich(
                    TextSpan(
                      text:
                          'Para eliminar tu cuenta, necesitas contactar al área de ',
                      children: [
                        TextSpan(
                          text: 'Clientes',
                          style: TextStyle(color: AppColors.primary),
                        ),
                        TextSpan(text: ' y tramitar tu solicitud.'),
                      ],
                    ),
                    style: TextStyle(
                      color: AppColors.textGray500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _showDeactivateAccountDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Desactivar mi cuenta',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.red,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceTile(UserSession session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          _getDeviceIcon(session.deviceType),
          size: 28,
          color: AppColors.textGray900,
        ),
        title: Text(
          _getDeviceTitle(session.deviceType),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textGray900,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session.userAgent,
              style: const TextStyle(color: AppColors.textGray500),
            ),
            const SizedBox(height: 4),
            Text(
              session.timeAgo,
              style: const TextStyle(
                color: AppColors.textGray400,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: session.isExpired
            ? const Text(
                'Expirada',
                style: TextStyle(color: Colors.red),
              )
            : TextButton(
                onPressed: () => _closeSession(session.id),
                child: const Text('Cerrar'),
              ),
      ),
    );
  }

  IconData _getDeviceIcon(String deviceType) {
    switch (deviceType.toLowerCase()) {
      case 'mobile_app':
        return Icons.phone_android;
      case 'web':
        return Icons.computer;
      case 'desktop':
        return Icons.desktop_windows;
      default:
        return Icons.device_unknown;
    }
  }

  String _getDeviceTitle(String deviceType) {
    switch (deviceType.toLowerCase()) {
      case 'mobile_app':
        return 'Aplicación móvil';
      case 'web':
        return 'Navegador web';
      case 'desktop':
        return 'Escritorio';
      default:
        return 'Dispositivo desconocido';
    }
  }
}
