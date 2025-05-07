import 'package:flutter/material.dart';
import '../../shared/settings_tile.dart';
import 'package:neek/modules/notifications/whatsapp_notification_settings_screen.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1320), // fondo oscuro
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1320),
        elevation: 0,
        title: const Text('Notificaciones'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20), // Margen alrededor del card
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              SettingsTile(
                title: 'Notificaciones de la App',
                subtitle: 'Actividad de tu cuenta',
                titleStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                subtitleStyle: Theme.of(context).textTheme.bodySmall,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WhatsAppNotificationSettingsScreen(),
                    ),
                  );
                },
              ),
              const Divider(height: 0),
              SettingsTile(
                title: 'Notificaciones via Correo',
                subtitle: 'Configuración y alertas de correo',
                titleStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                subtitleStyle: Theme.of(context).textTheme.bodySmall,
              ),
              const Divider(height: 0),
              SettingsTile(
                title: 'Notificaciones via WhatsApp',
                subtitle: 'Configuración y alertas de correo',
                titleStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                subtitleStyle: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}