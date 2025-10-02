import 'package:flutter/material.dart';
import '../../shared/widgets/notification_switch_tile.dart';
import '../../core/notification_api_service.dart';
import '../../models/notification_settings_model.dart'; 

class WhatsappNotificationSettingsScreen extends StatefulWidget {
  const WhatsappNotificationSettingsScreen({super.key});

  @override
  State<WhatsappNotificationSettingsScreen> createState() =>
      _WhatsappNotificationSettingsScreenState();
}

class _WhatsappNotificationSettingsScreenState
    extends State<WhatsappNotificationSettingsScreen> {
  bool _loading = true;
  late NotificationSettings _settings;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final data = await NotificationApiService.instance.getNotifications();
    if (data != null) {
      setState(() {
        _settings = NotificationSettings.fromJson(data);
        _loading = false;
      });
    } else {
      // Evitar que se use _settings sin datos válidos
      setState(() {
        _settings = NotificationSettings.empty(); // <- aquí usamos valores default
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudieron cargar las preferencias')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1320),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1320),
        elevation: 0,
        title: const Text('Notificaciones Whatsapp'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NotificationSwitchTile(
                      title: 'Marketing WhatsApp',
                      subtitle:
                          'Recibe notificaciones sobre marketing en tu cuenta',
                      fieldKey: 'whatsapp_marketing',
                      initialValue: _settings.whatsappMarketing,
                    ),
                    const Divider(),                    
                    NotificationSwitchTile(
                      title: 'Notificaciones de Emergencia',
                      subtitle:
                          'Recibe notificaciones sobre eventos inesperados en tu cuenta',
                      fieldKey: 'whatsapp_emergency',
                      initialValue: _settings.whatsappEmergency,
                    ),
                    const Divider(),

                    NotificationSwitchTile(
                      title: 'Encuestas de Satisfacción',
                      subtitle:
                          'Recopilar retroalimentación y opiniones de los clientes para mejorar los servicios',
                      fieldKey: 'whatsapp_surveys',
                      initialValue: _settings.whatsappSurveys,
                    ),
                    const Divider(),

                    NotificationSwitchTile(
                      title: 'Promociones y Descuentos',
                      subtitle:
                          'Recibe notificaciones sobre promociones especiales o descuentos exclusivos',
                      fieldKey: 'whatsapp_promotions',
                      initialValue: _settings.whatsappPromotions,
                    ),
                    const Divider(),

                    const SizedBox(height: 16),
                    const Text(
                      'Seguirás recibiendo notificaciones obligatorias como actualizaciones de tu cuenta.',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
    );
  }
}
