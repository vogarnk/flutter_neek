import 'package:flutter/material.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/shared/cards/card_neek.dart';

class NextContributionScreen extends StatefulWidget {
  const NextContributionScreen({super.key});

  @override
  State<NextContributionScreen> createState() => _NextContributionScreenState();
}

class _NextContributionScreenState extends State<NextContributionScreen> {
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Realizar siguiente aportación'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/seguros_atlas.png', height: 40),
                const SizedBox(width: 12),
                Image.asset('assets/images/logo_neek.png', height: 40),
              ],
            ),

            const SizedBox(height: 16),

            // Tarjeta
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // sombra muy suave
                    blurRadius: 4,
                    offset: const Offset(0, 2), // sombra hacia abajo sutil
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardNeek(nombrePlan: 'Mi plan', mostrarBoton: false),
                  infoRow('PÓLIZA', 'NEEK-TEST-POLIZA-CLV-1234'),
                  infoRow('CONTRATANTE', 'LUIS ANTONIO MONTANA SANCHEZ'),
                  infoRow('RECIBO', '1 / 12'),
                  infoRow('MONEDA', 'UDI'),
                  infoRow('IMPORTE', '3,792.00'),
                  infoRow('TC', '7.85'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Checkbox y mensaje
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // sombra muy suave
                    blurRadius: 4,
                    offset: const Offset(0, 2), // sombra hacia abajo sutil
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() => isChecked = value!);
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'He leído la información que se me ha proporcionado acerca de mi plan de ahorro en este módulo.',
                          style: TextStyle(fontSize: 13, color: AppColors.textGray900),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Importe Total: \$ 3,792.00',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textGray900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isChecked
                          ? () {
                              debugPrint('✅ Enviar instrucciones de pago');
                            }
                          : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Enviar instrucciones de pago'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.textGray300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: AppColors.textGray900, fontWeight: FontWeight.w600)),
          Text(value,
              style: const TextStyle(fontSize: 13, color: AppColors.textGray500, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}