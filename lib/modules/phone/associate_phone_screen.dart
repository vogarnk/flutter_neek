import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/phone_verification_api_service.dart';

class AssociatePhoneScreen extends StatefulWidget {
  const AssociatePhoneScreen({super.key});

  @override
  State<AssociatePhoneScreen> createState() => _AssociatePhoneScreenState();
}

class _AssociatePhoneScreenState extends State<AssociatePhoneScreen> {
  String countryCode = '+52'; // MXN
  final phoneController = TextEditingController(text: '');

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
                    child: 
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: AppColors.textGray900),
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: phoneController.text.isEmpty ? '123-456-7890' : null,
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
                  onPressed: () async {
                    final rawPhone = phoneController.text.replaceAll(RegExp(r'\D'), '');
                    if (rawPhone.length != 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('El número debe tener 10 dígitos')),
                      );
                      return;
                    }

                    final phoneWithCode = '$countryCode$rawPhone'; // Ej: +521234567890

                    final result = await PhoneVerificationApiService.instance.sendVerificationCode(phoneWithCode);

                    if (result['success']) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Código enviado, revisa tu celular')),
                      );
                      _showVerificationDialog(context, phoneWithCode); // 👈 aquí
                      // Aquí puedes navegar a la pantalla de ingreso de código
                      // Navigator.push(...);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result['message'])),
                      );
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Enviar código',
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

  void _showVerificationDialog(BuildContext context, String phoneWithCode) {
    final List<TextEditingController> codeControllers =
        List.generate(4, (_) => TextEditingController());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.all(24),
          child: Container(
            color: AppColors.textWhite,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Cambio de celular',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textGray900,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textGray500),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Código de seguridad',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.textGray900,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: 50,
                      child: TextField(
                        controller: codeControllers[index],
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20, color: AppColors.textGray900),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: AppColors.background50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.textGray300),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        onSubmitted: (_) {
                          if (index == 3) FocusScope.of(context).unfocus();
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tu código tomará unos minutos en llegar',
                  style: TextStyle(fontSize: 12, color: AppColors.textGray500),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final code = codeControllers.map((c) => c.text).join();

                      if (code.length != 4) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ingresa los 4 dígitos del código')),
                        );
                        return;
                      }

                      final result = await PhoneVerificationApiService.instance.confirmCode(phoneWithCode, code);

                      if (result['success']) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Número actualizado correctamente')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result['message'])),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text(
                      'Enviar',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }


}
