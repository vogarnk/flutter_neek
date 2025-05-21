import 'package:flutter/material.dart';
import '../../shared/widgets/notification_switch_tile.dart';
import '../../core/notification_api_service.dart';
import '../../models/notification_settings_model.dart'; 

class AppNotificationSettingsScreen extends StatefulWidget {
  const AppNotificationSettingsScreen({super.key});

  @override
  State<AppNotificationSettingsScreen> createState() =>
      sAppNotificationSettingsScreenState();
}

class sAppNotificationSettingsScreenState
    extends State<AppNotificationSettingsScreen> {
  bool accountActivity = true;
  bool investmentReturns = true;
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
      backgroundColor: const Color(0xFF0E1320), // Fondo oscuro
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1320),
        elevation: 0,
        title: const Text('Notificaciones de la App'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20), // 📦 Margen externo del "card"
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
              // 🔘 Switch para Actividad de la cuenta
              NotificationSwitchTile(
                title: 'Actividad de la cuenta',
                subtitle:
                    'Recibe notificaciones sobre la actividad de tu cuenta',
                fieldKey: 'app_account_activity',
                initialValue: _settings.appAccountActivity,
              ),
              const Divider(),

              // 🔘 Switch para Rendimiento de Inversiones
              NotificationSwitchTile(
                title: 'Rendimiento de Inversiones',
                subtitle:
                    'Recibe notificaciones sobre la actualización de tu ahorro y por tipo de cambio de UDIs',
                fieldKey: 'app_investment_performance',
                initialValue: _settings.appInvestmentPerformance,
              ),
              const Divider(),

              const SizedBox(height: 16),

              const Text(
                'Seguirás recibiendo notificaciones obligatorias acerca de la actividad de tu cuenta, proyectos, recordatorios de pago, tu rendimiento y aniversario de ahorro',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}