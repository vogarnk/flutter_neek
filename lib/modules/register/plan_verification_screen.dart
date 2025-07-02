import 'package:flutter/material.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/modules/register/plan_referral_screen.dart';

class PlanVerificationScreen extends StatefulWidget {
  final Map<String, dynamic> selectedPlan;
  final Map<String, dynamic> userData;

  const PlanVerificationScreen({
    super.key,
    required this.selectedPlan,
    required this.userData,
  });

  @override
  State<PlanVerificationScreen> createState() => _PlanVerificationScreenState();
}

class _PlanVerificationScreenState extends State<PlanVerificationScreen> {
  final List<TextEditingController> _codeControllers =
      List.generate(4, (_) => TextEditingController());

  bool deseaLlamadas = false;
  bool deseaMensajes = false;
  String horario = '5:00 pm - 8:00 pm';

  void _continuar() {
    final code = _codeControllers.map((c) => c.text.trim()).join();
    if (code.length < 4 || code.contains(RegExp(r'\D'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa el código completo de 4 dígitos')),
      );
      return;
    }

    final dataCompleta = {
      ...widget.userData,
      'codigoVerificacion': code,
      'deseaLlamadas': deseaLlamadas,
      'deseaMensajes': deseaMensajes,
      'horarioLlamada': deseaLlamadas ? horario : null,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlanReferralScreen(
          selectedPlan: widget.selectedPlan,
          userData: dataCompleta,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ayúdanos a verificar tu cuenta',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textGray900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '¡Estás a un solo paso de recibir tu cotización!',
                    style: TextStyle(color: AppColors.textGray500),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Por tu tranquilidad, ayudamos a verificar tu cuenta ingresando tu número de celular.',
                    style: TextStyle(color: AppColors.textGray500),
                  ),
                  const SizedBox(height: 24),

                  const Text('Código de seguridad', style: _labelStyle),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: 60,
                        child: TextField(
                          controller: _codeControllers[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: const TextStyle(fontSize: 24, color: AppColors.textGray900),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < _codeControllers.length - 1) {
                              FocusScope.of(context).nextFocus();
                            } else if (value.isNotEmpty && index == _codeControllers.length - 1) {
                              FocusScope.of(context).unfocus();
                            }
                          },
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: AppColors.background50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.textGray300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.textGray300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  const Text('Tu código tomará unos minutos en llegar',
                      style: TextStyle(color: AppColors.textGray500)),
                  const SizedBox(height: 24),

                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: deseaLlamadas,
                    onChanged: (val) => setState(() => deseaLlamadas = val!),
                    title: const Text(
                      'Deseo recibir llamadas referentes a mi Plan',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: AppColors.textGray900),
                    ),
                    subtitle: const Text(
                      'Recibirás llamadas por parte de tu agente acerca de tu plan de ahorro',
                      style: TextStyle(color: AppColors.textGray500),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.primary,
                  ),
                  if (deseaLlamadas)
                    Column(
                      children: [
                        _radioOption('10:00 am - 12:00 pm'),
                        _radioOption('1:00 pm - 4:00 pm'),
                        _radioOption('5:00 pm - 8:00 pm'),
                      ],
                    ),

                  const SizedBox(height: 16),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: deseaMensajes,
                    onChanged: (val) => setState(() => deseaMensajes = val!),
                    title: const Text(
                      'Deseo recibir mensajes referentes a mi Plan',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textGray900,
                      ),
                    ),
                    subtitle: const Text(
                      'Recibirás solamente mensajes de whatsapp y correos',
                      style: TextStyle(color: AppColors.textGray500),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.primary,
                  ),

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _continuar,
                      child: const Text('Continuar', style: TextStyle(fontSize: 16)),
                    ),
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textGray900,
                        side: const BorderSide(color: AppColors.textGray900),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Regresar', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static const _labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textGray900,
  );

  Widget _radioOption(String label) {
    return RadioListTile<String>(
      title: Text(label, style: const TextStyle(color: AppColors.textGray900)),
      value: label,
      groupValue: horario,
      onChanged: (val) => setState(() => horario = val!),
      activeColor: AppColors.primary,
      contentPadding: EdgeInsets.zero,
    );
  }
}