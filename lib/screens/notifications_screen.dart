import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Tu nueva cotización ha sido enviada',
        'message': 'Has solicitado una nueva cotización con el nombre “2025” enviamos una...',
        'time': 'Hace un momento',
        'isNew': true,
      },
      {
        'title': 'Agenda una asesoría',
        'message': 'Estamos aquí para aclarar tus dudas, si necesitas ayuda contactanos!...',
        'time': 'Hace una hora',
        'isNew': true,
      },
      {
        'title': 'Configura tu cuenta',
        'message': 'Continua tu proceso verificando tu cuenta en Mi Cuenta, esto te ayudará a...',
        'date': DateTime(2024, 12, 10),
        'isNew': false,
      },
      {
        'title': 'Cambia tu contraseña',
        'message': 'Te invitamos a cambiar tu contraseña de Neek, tu seguridad es importante...',
        'date': DateTime(2024, 12, 8),
        'isNew': false,
      },
      {
        'title': 'Bienvenido a tu cuenta Neek',
        'message': 'Te damos la bienvenida a tu cuenta Neek, tu primera mejor inversión...',
        'date': DateTime(2024, 11, 29),
        'isNew': false,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0E1621),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Notificaciones', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.black12),
            itemBuilder: (context, index) {
              final item = notifications[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                leading: item['isNew']
                    ? const Icon(Icons.notifications_active, color: Colors.blue)
                    : const Icon(Icons.visibility, color: Colors.black26),
                title: Text(
                  item['title'],
                  style: TextStyle(
                    fontWeight: item['isNew'] ? FontWeight.bold : FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      item['message'],
                      style: const TextStyle(color: Colors.black54, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['isNew']
                          ? item['time']
                          : DateFormat('dd/MM/yyyy').format(item['date']),
                      style: TextStyle(
                        color: item['isNew'] ? Colors.blue : Colors.black38,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.black26),
                onTap: () {
                  // Acción al presionar la notificación
                },
              );
            },
          ),
        ),
      ),
    );
  }
}