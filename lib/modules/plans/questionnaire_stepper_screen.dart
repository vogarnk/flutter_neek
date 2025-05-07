import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class QuestionnaireStepperScreen extends StatefulWidget {
  const QuestionnaireStepperScreen({super.key});

  @override
  State<QuestionnaireStepperScreen> createState() => _QuestionnaireStepperScreenState();
}

class _QuestionnaireStepperScreenState extends State<QuestionnaireStepperScreen> {
  final PageController _pageController = PageController();
  int currentStep = 0;

  final TextEditingController pesoController = TextEditingController();
  final TextEditingController estaturaController = TextEditingController();

  // Preguntas tipo Sí/No
  String? perdidaPeso;
  String? enfermedad;
  String? deformidad;
  Map<String, String?> _form = {
    'corazon': null,
    'ojos_oidos': null,
    'respiratorio': null,
    'digestivo': null,
    'genitourinario': null,
    'endocrino': null,
    'nervioso': null,
    'musculo': null,
    'cancer': null,
    'autoinmune': null,
    'cronica': null,
    'vih': null,
    'tratamiento': null,
    'atencion': null,

    'ovarios': null,
    'mamas': null,
    'matriz': null,
    'ginecologia': null,
    'embarazo': null,
    'complicaciones_embarazo': null,

  };

  void nextStep() {
    setState(() => currentStep++);
    _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }




  @override
  Widget build(BuildContext context) {
    final steps = [
      'Cuestionario Médico',
      'Hábitos',
      'Diagnóstico',
      'Salud',
      'Tratamiento y atención médica'
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Row(
          children: [
            Text('${currentStep + 1} ${steps[currentStep]}'),
            const Spacer(),
            const Text('10:00', style: TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _stepPesoYEstatura(),
            _stepEnfermedadesYpadecimientos(),
            _stepDiagnosticosGenerales(),
            _stepSaludFemenina(),
          ],
        ),
      ),
    );
  }

  Widget _stepPesoYEstatura() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Empecemos por tu peso\ny estatura',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black, // ✅ texto negro
                  ),
                ),
                const SizedBox(height: 16),

                _textField('Peso', 'Ingresa un aproximado de tu peso (kg)', pesoController),
                const SizedBox(height: 12),
                _textField('Estatura', 'Ingresa un aproximado de tu estatura (cm)', estaturaController),
                const SizedBox(height: 16),

                _questionRadio('¿Ha disminuido o bajado de peso de manera repentina?', (value) {
                  setState(() => perdidaPeso = value);
                }, perdidaPeso),

                _questionRadio('¿Padece actualmente alguna enfermedad, afección o lesión?', (value) {
                  setState(() => enfermedad = value);
                }, enfermedad),

                _questionRadio('¿Le falta algún miembro, parte de él o alguna deformidad?', (value) {
                  setState(() => deformidad = value);
                }, deformidad),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Continuar'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              // TODO: lógica para guardar local y salir
            },
            child: const Text('Guardar y Continuar más tarde'),
          )
        ],
      ),
    );
  }

  Widget _stepEnfermedadesYpadecimientos() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enfermedades y padecimientos',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),

                _questionRadio('¿Del corazón y circulación?', (v) => setState(() => _form['corazon'] = v), _form['corazon']),
                _questionRadio('¿Tiene alguna enfermedad en ojos u oídos?', (v) => setState(() => _form['ojos_oidos'] = v), _form['ojos_oidos']),
                _questionRadio('¿Del aparato respiratorio?', (v) => setState(() => _form['respiratorio'] = v), _form['respiratorio']),
                _questionRadio('¿Del aparato digestivo?', (v) => setState(() => _form['digestivo'] = v), _form['digestivo']),
                _questionRadio('¿Del aparato genitourinario?', (v) => setState(() => _form['genitourinario'] = v), _form['genitourinario']),
                _questionRadio('¿Del aparato endocrino?', (v) => setState(() => _form['endocrino'] = v), _form['endocrino']),
                _questionRadio('¿Del sistema nervioso?', (v) => setState(() => _form['nervioso'] = v), _form['nervioso']),
                _questionRadio('¿Del aparato músculo esquelético?', (v) => setState(() => _form['musculo'] = v), _form['musculo']),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: nextStep, // Ir al siguiente step
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Continuar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepDiagnosticosGenerales() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Diagnósticos y tratamiento',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),

                _questionRadio('¿Ha sido diagnosticado con algún tipo de Cáncer?', (v) => setState(() => _form['cancer'] = v), _form['cancer']),
                _questionRadio('¿Enfermedades autoinmunes?', (v) => setState(() => _form['autoinmune'] = v), _form['autoinmune']),
                _questionRadio('¿Cualquier otra que se haya manifestado por más de ocho días?', (v) => setState(() => _form['cronica'] = v), _form['cronica']),
                _questionRadio('¿Se ha practicado pruebas de diagnóstico VIH?', (v) => setState(() => _form['vih'] = v), _form['vih']),
                _questionRadio('¿Está en tratamiento médico, terapia o rehabilitación?', (v) => setState(() => _form['tratamiento'] = v), _form['tratamiento']),
                _questionRadio('¿Los últimos 3 años ha requerido atención médica?', (v) => setState(() => _form['atencion'] = v), _form['atencion']),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Continuar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepSaludFemenina() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Salud femenina',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),

                _questionRadio('¿Los Ovarios?', (v) => setState(() => _form['ovarios'] = v), _form['ovarios']),
                _questionRadio('¿Glándulas mamarias?', (v) => setState(() => _form['mamas'] = v), _form['mamas']),
                _questionRadio('¿De la matriz?', (v) => setState(() => _form['matriz'] = v), _form['matriz']),
                _questionRadio('¿El último año ha acudido a valoración ginecológica?', (v) => setState(() => _form['ginecologia'] = v), _form['ginecologia']),
                _questionRadio('¿Está o ha estado embarazada?', (v) => setState(() => _form['embarazo'] = v), _form['embarazo']),
                _questionRadio('¿Ha presentado complicaciones en el embarazo?', (v) => setState(() => _form['complicaciones_embarazo'] = v), _form['complicaciones_embarazo']),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Continuar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _textField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black)), // Texto del label negro
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.black), // Texto del input negro
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black54), // Opcional: hint en gris
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFD6DADF), // ✅ Stroke personalizado
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFD6DADF),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFD6DADF),
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _questionRadio(String question, void Function(String?) onChanged, String? selectedValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          question,
          style: const TextStyle(color: Colors.black), // ✅ Texto de la pregunta en negro
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text(
                  'Sí',
                  style: TextStyle(color: Colors.black), // ✅ Texto del radio en negro
                ),
                value: 'si',
                groupValue: selectedValue,
                onChanged: onChanged,
                activeColor: AppColors.primary, // opcional: color del radio activo
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text(
                  'No',
                  style: TextStyle(color: Colors.black), // ✅ Texto del radio en negro
                ),
                value: 'no',
                groupValue: selectedValue,
                onChanged: onChanged,
                activeColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

}
