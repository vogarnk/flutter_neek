import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../modules/savings/savings_type_selection_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Círculo decorativo (puedes reemplazar por SVG o animación)
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 3,
                    color: AppColors.primary.withOpacity(0.8),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Título
              const Text(
                '¡Bienvenido a Neek!',
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Subtítulo
              const Text(
                'Comencemos a crear un plan de ahorro y seguro de vida en UDIS que cumpla tus metas, es el primer paso a la tranquilidad que mereces.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textGray300,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Botón "Continuar"
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SavingsTypeSelectionScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Text(
                    'Continuar',
                    style: TextStyle(color: AppColors.textWhite),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Botón "Regresar"
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.textGray300),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Text(
                    'Regresar',
                    style: TextStyle(color: AppColors.textWhite),
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