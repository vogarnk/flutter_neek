import 'package:flutter/material.dart';
import 'account_detail_screen.dart'; // 👈 Asegúrate de importar esta vista
import '../notifications/notification_settings_screen.dart';
import 'package:neek/modules/verification/verificacion_screen.dart';
import '../verification/verificacion_completada_screen.dart';
import '../verification/verificacion_exitosa_screen.dart';
import '../../splash_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../security/security_screen.dart';
import '../phone/associate_phone_screen.dart';
import '../legal/legal_screen.dart';
class AccountScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const AccountScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1320),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mi Cuenta',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                AccountTile(
                  title: 'Mi cuenta',
                  subtitle:
                      'Configura tu cuenta, información personal y conecta con tu agente Neek',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AccountDetailScreen(user: user), // ✅ ya tienes 'user' como parámetro
                      ),
                    );
                  },
                ),
                const Divider(),
                AccountTile(
                  title: 'Notificaciones',
                  subtitle: 'Recibe notificaciones de la actividad de tu cuenta y cambios en la plataforma',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationSettingsScreen(),
                      ),
                    );
                  },
                ),
                const Divider(),
                AccountTile(
                  title: 'Seguridad',
                  subtitle: 'Ajustes de privacidad, información de tu cuenta y acceso',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SecurityScreen(),
                      ),
                    );
                  },                  
                ),
                const Divider(),
                AccountTile(
                  title: 'Verificación',
                  subtitle: 'Verifica tu cuenta y carga tu información para verificar tu identidad',
                  onTap: () {
                    final verificacion = user['verificacion'];
                    final perfilCompleto = user['perfil_completo'] == 1;

                    if (perfilCompleto) {
                      // Perfil ya validado por el equipo Neek
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VerificacionExitosaScreen()),
                      );
                    } else if (verificacion['completed'] == true) {
                      // Documentación cargada, falta revisión
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VerificacionCompletadaScreen()),
                      );
                    } else {
                      // Aún falta completar información
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => VerificacionScreen(user: user)),
                      );
                    }
                  },
                ),

                const Divider(),
                AccountTile(
                  title: 'Asociación de celular',
                  subtitle: 'Agrega tu número de celular a tu cuenta Neek',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AssociatePhoneScreen(),
                      ),
                    );
                  },      
                ),
                const Divider(),
                AccountTile(
                  title: 'Legal',
                  subtitle: 'Consulta los aspectos legales de Neek aquí',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LegalScreen(),
                      ),
                    );
                  },      
                ),
                const Divider(),

                // 🔴 Botón de cerrar sesión
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar sesión'),
                    onPressed: () async {
                      final storage = FlutterSecureStorage();
                      await storage.delete(key: 'auth_token');

                      // Redirige al SplashScreen o Login
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const SplashScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ),                
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccountTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const AccountTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  State<AccountTile> createState() => _AccountTileState();
}

class _AccountTileState extends State<AccountTile>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _animateTap(Function() onTap) async {
    setState(() => _scale = 0.97);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _scale = 1.0);
    await Future.delayed(const Duration(milliseconds: 100));
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap != null
          ? () => _animateTap(widget.onTap!)
          : null,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        ),
      ),
    );
  }
}