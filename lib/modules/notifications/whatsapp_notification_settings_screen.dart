import 'package:flutter/material.dart';

class WhatsAppNotificationSettingsScreen extends StatefulWidget {
  const WhatsAppNotificationSettingsScreen({super.key});

  @override
  State<WhatsAppNotificationSettingsScreen> createState() =>
      _WhatsAppNotificationSettingsScreenState();
}

class _WhatsAppNotificationSettingsScreenState
    extends State<WhatsAppNotificationSettingsScreen> {
  bool accountActivity = true;
  bool investmentReturns = true;

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
      body: Padding(
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
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Actividad de la cuenta',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color:
                        Theme.of(context).textTheme.displaySmall?.color,
                  ),
                ),
                subtitle: Text(
                  'Recibe notificaciones sobre la actividad de tu cuenta',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                trailing: Switch(
                  value: accountActivity,
                  onChanged: (val) {
                    setState(() {
                      accountActivity = val;
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: Theme.of(context).primaryColor,
                ),
              ),
              const Divider(),

              // 🔘 Switch para Rendimiento de Inversiones
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Rendimiento de Inversiones',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color:
                        Theme.of(context).textTheme.displaySmall?.color,
                  ),
                ),
                subtitle: Text(
                  'Recibe notificaciones sobre la actualización de tu ahorro y por tipo de cambio de UDIs',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                trailing: Switch(
                  value: investmentReturns,
                  onChanged: (val) {
                    setState(() {
                      investmentReturns = val;
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: Theme.of(context).primaryColor,
                ),
              ),
              const Divider(),

              const SizedBox(height: 16),

              const Text(
                'Seguirás recibiendo notificaciones obligatorias acerca de la actividad de tu cuenta, proyectos, recordatorios de pago, tu rendimiento y aniversario de ahorro',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),

              const Spacer(),

              // 💾 Botón de guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Guardar cambios aquí
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B5FF3),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Guardar cambios',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}