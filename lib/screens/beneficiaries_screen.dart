import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../screens/activate_plan_intro_screen.dart';
import '../widgets/cards/card_neek.dart';
import '../screens/create_beneficiary_screen.dart';

class BeneficiariesScreen extends StatelessWidget {
  final Map<String, dynamic> user;
  final List<dynamic> beneficiarios; // 👈 nuevo

  const BeneficiariesScreen({
    super.key,
    required this.user,
    required this.beneficiarios,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Beneficiarios'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Alerta superior
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.person_add_alt, color: AppColors.primary),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Añade a tus beneficiarios\nPara poder activar tu plan debes añadir a tus beneficiarios, una vez que los agregues podrás continuar',
                      style: TextStyle(color: AppColors.textGray900, fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tarjeta del plan
            const CardNeek(nombrePlan: "Mi plan"),

            const SizedBox(height: 16),

            // Botón Activar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ActivatePlanIntroScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Activar mi plan'),
              ),
            ),
            const SizedBox(height: 24),

            // Tabla de beneficiarios
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mis beneficiarios',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16 , color: AppColors.textGray900),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Administra tus beneficiarios',
                    style: TextStyle(fontSize: 12, color: AppColors.textGray400),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),

                  // 🔁 Recorremos los beneficiarios reales
                  for (var b in beneficiarios)
                    _beneficiarioRow(
                      avatarPath: b['avatar_url'] ?? 'assets/avatars/default.png',
                      nombre: b['nombre'] ?? 'Desconocido',
                      tipo: b['tipo'] ?? 'Tipo no definido',
                      acceso: b['acceso'] ?? 'N/A',
                      porcentaje: int.tryParse(b['porcentaje'].toString()) ?? 0,
                    ),
                ],
              ),
            ),


            const SizedBox(height: 16),

            // Botón añadir beneficiarios
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateBeneficiaryScreen()),
                  );
                  // Navegar a pantalla de añadir beneficiarios
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Añadir beneficiarios'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _beneficiarioRow({
    required String avatarPath,
    required String nombre,
    required String tipo,
    required String acceso,
    required int porcentaje,
  }) {
    final bool esBasico = acceso == 'Básico';
    final Color bgColor = esBasico ? const Color(0xFFE8F0FF) : const Color(0xFFE0FFF5);
    final Color textColor = esBasico ? const Color(0xFF2563EB) : const Color(0xFF10B981);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage(avatarPath),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nombre, style: const TextStyle(fontWeight: FontWeight.w500 , color: AppColors.textGray900)),
                Text(tipo, style: const TextStyle(fontSize: 12, color: AppColors.textGray900)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              acceso,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textColor),
            ),
          ),
          const SizedBox(width: 12),
          Text('$porcentaje%', style: const TextStyle(fontWeight: FontWeight.bold , color: AppColors.textGray900)),
        ],
      ),
    );
  }
  
}
