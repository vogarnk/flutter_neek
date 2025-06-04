import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'notification_detail_screen.dart';
import 'package:neek/core/notification/notification_service.dart';
import 'package:neek/models/notifications_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<NotificationModel>> _futureNotifications;

  @override
  void initState() {
    super.initState();
    _futureNotifications = NotificationApiService.instance.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<List<NotificationModel>>(
        future: _futureNotifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar notificaciones',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No tienes notificaciones todavía', style: TextStyle(color: Colors.white)),
            );
          }

          final notifications = snapshot.data!;

          return Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.black12),
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    leading: item.isNew
                        ? const Icon(Icons.notifications_active, color: Colors.blue)
                        : const Icon(Icons.visibility, color: Colors.black26),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: item.isNew ? FontWeight.bold : FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          item.message,
                          style: const TextStyle(color: Colors.black54, fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.date != null
                              ? DateFormat('dd/MM/yyyy').format(item.date!)
                              : 'Reciente',
                          style: TextStyle(
                            color: item.isNew ? Colors.blue : Colors.black38,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.black26),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotificationDetailScreen(
                            title: item.title,
                            subtitle: item.isNew
                                ? '¡Tu nueva notificación ha llegado!'
                                : 'Consulta el detalle de esta notificación',
                            message: item.message,
                            date: item.date != null
                                ? DateFormat('dd/MM/yyyy').format(item.date!)
                                : 'Reciente',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}