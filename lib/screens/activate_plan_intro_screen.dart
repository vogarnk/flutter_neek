import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../screens/questionnaire_stepper_screen.dart';

class ActivatePlanIntroScreen extends StatelessWidget {
  const ActivatePlanIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Activar mi plan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icono en círculo azul claro
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFE6F4FF), // azul clarito
                  ),
                  child: const Icon(Icons.verified, size: 40, color: AppColors.primary),
                ),

                const SizedBox(height: 24),

                // Mensaje principal
                const Text(
                  '¡Felicidades por\ntomar esta decisión!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: AppColors.textGray900,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Antes de activar tu plan, nos gustaría conocerte un poco más. A continuación encontrarás una serie de cuestionarios que nos ayudarán a establecer tu estado de salud y realizar tu proceso de activación.\n\n¡Te tomará de 5 a 10 minutos y tu plan estará listo para activarse!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppColors.textGray500),
                ),

                const SizedBox(height: 24),

                // Botón Activar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuestionnaireStepperScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Activar mi plan',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Texto de privacidad
                Text.rich(
                  TextSpan(
                    text: 'Tu información está protegida, para más información\npuedes leer nuestro ',
                    style: const TextStyle(fontSize: 12, color: AppColors.textGray400),
                    children: [
                      TextSpan(
                        text: 'Aviso de Privacidad',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
