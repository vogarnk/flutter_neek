import 'package:flutter/material.dart';
import '../../shared/widgets/notification_switch_tile.dart';
import '../../core/notification_api_service.dart';
import '../../models/notification_settings_model.dart'; 

class EmailNotificationSettingsScreen extends StatefulWidget {
  const EmailNotificationSettingsScreen({super.key});

  @override
  State<EmailNotificationSettingsScreen> createState() =>
      _EmailNotificationSettingsScreenState();
}

class _EmailNotificationSettingsScreenState
    extends State<EmailNotificationSettingsScreen> {
  bool noticiasNeek = true;
  bool consejosFinancieros = true;
  bool eventosWeb = true;
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
        title: const Text('Notificaciones Correo'),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                      title: 'Noticias Neek',
                      subtitle:
                          'Recibe anuncios, actualizaciones de la plataforma y noticias de Neek',
                      fieldKey: 'email_news',
                      initialValue: _settings.emailNews,
                    ),
                    const Divider(),
                    NotificationSwitchTile(
                      title: 'Consejos Financieros',
                      subtitle:
                          'Recibe consejos y recursos sobre planificación financiera, ahorro e inversión',
                      fieldKey: 'email_financial_advice',
                      initialValue: _settings.emailFinancialAdvice,
                    ),
                    const Divider(),
                    NotificationSwitchTile(
                      title: 'Eventos Web',
                      subtitle:
                          'Recibe correos sobre eventos web sobre temas financieros y de seguros',
                      fieldKey: 'email_events',
                      initialValue: _settings.emailEvents,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Seguirás recibiendo notificaciones obligatorias como cambios en los datos de tu cuenta, recordatorios de pago, actualizaciones de póliza y estado anual de tu ahorro.',
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
