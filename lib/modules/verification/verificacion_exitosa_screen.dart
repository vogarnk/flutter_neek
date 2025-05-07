import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class VerificacionExitosaScreen extends StatelessWidget {
  const VerificacionExitosaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Verificación'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE8F0FE), // fondo azul claro
                ),
                child: const Icon(Icons.verified, size: 48, color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              const Text(
                'Felicidades, has\ncompletado tu verificación',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: AppColors.textGray900,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ahora puedes cotizar más de 2\nplanes y activar tus planes cotizados.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textGray500),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Entendido'),
                ),
              ),
              const SizedBox(height: 16),
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
    );
  }
}
