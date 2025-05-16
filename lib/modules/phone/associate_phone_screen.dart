import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssociatePhoneScreen extends StatefulWidget {
  const AssociatePhoneScreen({super.key});

  @override
  State<AssociatePhoneScreen> createState() => _AssociatePhoneScreenState();
}

class _AssociatePhoneScreenState extends State<AssociatePhoneScreen> {
  String countryCode = '+52'; // MXN
  final phoneController = TextEditingController(text: '123-456-7890');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Asociar número de celular'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
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
                'Al asociar tu número de celular podrás ajustar tus preferencias de contacto y recibir notificaciones sobre el estado de tus planes.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textGray500,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Número de celular a 10 dígitos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textGray900,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.background50,
                      border: Border.all(color: AppColors.textGray300),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icon/flags/mx.svg',
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 8),
                        Text('MXN', style: TextStyle(color: AppColors.textGray900)),
                        Icon(Icons.keyboard_arrow_down, color: AppColors.textGray400),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: AppColors.textGray900), // << AÑADIDO
                      decoration: InputDecoration(
                        hintText: '123-456-7890',
                        hintStyle: const TextStyle(color: AppColors.textGray500),
                        filled: true,
                        fillColor: AppColors.background50,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textGray300),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textGray300),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textGray300),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 12),
              const Text(
                'Al cambiar tu número recibirás un código de seguridad para confirmar tu número.',
                style: TextStyle(fontSize: 13, color: AppColors.textGray500),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Acción para guardar/cambiar número
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Guardar y Enviar código',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
