import 'package:flutter/material.dart';
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
      final data = await SecurityApiService.instance.getSessions();
      setState(() {
        _sessions = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar sesiones')),
      );
    }
  }

  Future<void> _closeSession(String sessionId) async {
    final success = await SecurityApiService.instance.closeSession(sessionId);
    if (success) {
      _loadSessions(); // recarga la lista actualizada
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo cerrar la sesión')),
      );
    }
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Eliminar mi cuenta',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textGray900,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text.rich(
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
        leading: const Icon(
          Icons.computer_outlined,
          size: 28,
          color: AppColors.textGray900,
        ),
        title: Text(
          session.ipAddress,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textGray900,
          ),
        ),
        subtitle: Text(
          session.userAgent,
          style: const TextStyle(color: AppColors.textGray500),
        ),
        trailing: session.isCurrent
            ? const Text(
                'Actual',
                style: TextStyle(color: AppColors.primary),
              )
            : TextButton(
                onPressed: () => _closeSession(session.id),
                child: const Text('Cerrar'),
              ),
      ),
    );
  }
}
