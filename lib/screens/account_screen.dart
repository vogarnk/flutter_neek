import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

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
              children: const [
                AccountTile(
                  title: 'Mi cuenta',
                  subtitle:
                      'Configura tu cuenta, información personal y conecta con tu agente Neek',
                ),
                Divider(),
                AccountTile(
                  title: 'Notificaciones',
                  subtitle:
                      'Recibe notificaciones de la actividad de tu cuenta y cambios en la plataforma',
                ),
                Divider(),
                AccountTile(
                  title: 'Seguridad',
                  subtitle: 'Ajustes de privacidad, información de tu cuenta y acceso',
                ),
                Divider(),
                AccountTile(
                  title: 'Verificación',
                  subtitle:
                      'Verifica tu cuenta y carga tu información para verificar tu identidad',
                ),
                Divider(),
                AccountTile(
                  title: 'Asociación de celular',
                  subtitle: 'Agrega tu número de celular a tu cuenta Neek',
                ),
                Divider(),
                AccountTile(
                  title: 'Legal',
                  subtitle: 'Consulta los aspectos legales de Neek aquí',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccountTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const AccountTile({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}