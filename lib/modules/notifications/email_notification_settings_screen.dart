import 'package:flutter/material.dart';

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
      body: Padding(
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
              // 🔘 Noticias Neek
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Noticias Neek',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                subtitle: const Text(
                  'Recibe anuncios, actualizaciones de la plataforma y noticias de Neek',
                  style: TextStyle(color: Colors.black54),
                ),
                trailing: Switch(
                  value: noticiasNeek,
                  onChanged: (val) {
                    setState(() {
                      noticiasNeek = val;
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF2B5FF3),
                ),
              ),
              const Divider(),

              // 🔘 Consejos Financieros
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Consejos Financieros',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                subtitle: const Text(
                  'Recibe consejos y recursos sobre planificación financiera, ahorro e inversión',
                  style: TextStyle(color: Colors.black54),
                ),
                trailing: Switch(
                  value: consejosFinancieros,
                  onChanged: (val) {
                    setState(() {
                      consejosFinancieros = val;
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF2B5FF3),
                ),
              ),
              const Divider(),

              // 🔘 Eventos y Seminarios Web
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Eventos y Seminarios Web',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                subtitle: const Text(
                  'Recibe correos sobre eventos web sobre temas financieros y de seguros',
                  style: TextStyle(color: Colors.black54),
                ),
                trailing: Switch(
                  value: eventosWeb,
                  onChanged: (val) {
                    setState(() {
                      eventosWeb = val;
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF2B5FF3),
                ),
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

              // 💾 Botón Guardar Cambios
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Guardar acción
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
