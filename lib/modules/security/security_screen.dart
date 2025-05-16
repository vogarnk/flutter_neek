import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../security/change_password_screen.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Seguridad'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🔐 Dispositivos conectados
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.textWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dispositivos conectados',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16 , color: AppColors.textGray900,),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '2/5 Dispositivos activos',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDeviceTile('MTY 24.456.355.98', 'Safari en iPhone'),
                  const SizedBox(height: 8),
                  _buildDeviceTile('MTY 123.123.123.123', 'Safari en iPad'),
                  const SizedBox(height: 16),
                  const Text(
                    'Por tu seguridad tu cuenta puede estar conectada a máximo 5 dispositivos',
                    style: TextStyle(color: AppColors.textGray500, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 🔒 Contraseña
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.textWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contraseña',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textGray900,),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Cambia o configura tu contraseña',
                    style: TextStyle(color: AppColors.textGray400, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Contraseña actual',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textGray900,
                        ),
                      ),
                      Text(
                        '••••••••',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textGray500,),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cambiar contraseña',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.textGray900,
                          ),
                        ),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ❌ Eliminar mi cuenta
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.textWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Eliminar mi cuenta',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textGray900,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      text: 'Para eliminar tu cuenta, necesitas contactar al área de ',
                      children: [
                        TextSpan(
                          text: 'Clientes',
                          style: TextStyle(color: AppColors.primary),
                        ),
                        TextSpan(text: ' y tramitar tu solicitud.'),
                      ],
                    ),
                    style: TextStyle(
                      color: AppColors.textGray500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30), // espacio final
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceTile(String ip, String device) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.computer_outlined,
          size: 28,
          color: AppColors.textGray900,
        ),
        title: Text(ip, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textGray900,)),
        subtitle: Text(
          device,
          style: TextStyle(
            color: AppColors.textGray500,
          ),
        ),

        trailing: TextButton(
          onPressed: () {
            // cerrar sesión de ese dispositivo
          },
          child: const Text('Cerrar'),
        ),
      ),
    );
  }
}
