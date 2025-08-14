import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/questionnaire_service.dart';

class QuestionnaireStepperScreen extends StatefulWidget {
  const QuestionnaireStepperScreen({super.key});

  @override
  State<QuestionnaireStepperScreen> createState() => _QuestionnaireStepperScreenState();
}

class _QuestionnaireStepperScreenState extends State<QuestionnaireStepperScreen> {
  final PageController _pageController = PageController();
  int currentStep = 0;

  bool _loading = true;
  String? _error;
  List<QuestionModel> _questions = [];
  List<int> _steps = [];
  final Map<int, dynamic> _answersByQuestionId = {};
  final Map<int, TextEditingController> _textControllers = {};

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final c in _textControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final allItems = await QuestionnaireService.instance.fetchQuestions();
      const excludedSteps = {11};
      final items = allItems.where((q) => !excludedSteps.contains(q.step)).toList();
      final steps = items.map((e) => e.step).toSet().toList()..sort();
      setState(() {
        _questions = items;
        _steps = steps;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'No se pudieron cargar las preguntas';
        _loading = false;
      });
    }
  }

  void _nextStep() {
    if (!_validateCurrentStep()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Responde las preguntas requeridas para continuar.')),
      );
      return;
    }
    if (currentStep < _steps.length - 1) {
      setState(() => currentStep++);
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      // Último paso; aquí podrías enviar respuestas si aplica
      Navigator.of(context).maybePop();
    }
  }

  void _prevStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  bool _validateCurrentStep() {
    if (_steps.isEmpty) return true;
    final int stepNumber = _steps[currentStep];
    final visibleQuestions = _questions
        .where((q) => q.step == stepNumber)
        .where(_isQuestionVisible)
        .toList();

    for (final q in visibleQuestions) {
      if (!q.required) continue;
      final value = _answersByQuestionId[q.id];
      if (q.tipo == 'radio') {
        if (value == null || value.toString().isEmpty) return false;
      } else if (q.tipo == 'text' || q.tipo == 'date' || q.tipo == 'number' || q.tipo == 'float' || q.tipo == 'decimal') {
        if (value == null || (value is String && value.trim().isEmpty)) return false;
      } else {
        if (value == null) return false;
      }
    }
    return true;
  }

  bool _isQuestionVisible(QuestionModel q) {
    if (q.dependsOnId == null) return true;
    final parentValue = _answersByQuestionId[q.dependsOnId];
    return parentValue?.toString() == q.dependsOnValue?.toString();
  }

  @override
  Widget build(BuildContext context) {
    final String stepTitle = _steps.isEmpty ? '' : 'Paso ${currentStep + 1} de ${_steps.length}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _prevStep,
              )
            : null,
        title: Row(
          children: [
            Text(stepTitle),
            const Spacer(),
            const Text('10:00', style: TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!, style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadQuestions,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: _steps.map(_buildStep).toList(),
                  ),
                ),
    );
  }

  Widget _buildStep(int stepNumber) {
    final items = _questions.where((q) => q.step == stepNumber).toList();
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
                  'Cuestionario Médico',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                ...items.where(_isQuestionVisible).map(_buildQuestion).toList(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    if (currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _prevStep,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text('Atrás'),
                        ),
                      ),
                    if (currentStep > 0) const SizedBox(width: 12),
                    Expanded(
                      flex: currentStep > 0 ? 1 : 2,
                      child: ElevatedButton(
                        onPressed: _nextStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(currentStep < _steps.length - 1 ? 'Continuar' : 'Finalizar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              // TODO: Guardar local y salir
            },
            child: const Text('Guardar y Continuar más tarde'),
          )
        ],
      ),
    );
  }

  Widget _buildQuestion(QuestionModel q) {
    if (q.tipo == 'radio') {
      final String? selected = _answersByQuestionId[q.id];
      final options = [...q.opciones]..sort((a, b) => a.orden.compareTo(b.orden));
      if (options.isEmpty) {
        // Fallback Sí/No si API no trae opciones
        return _questionRadio(
          q.texto,
          (String? v) {
            setState(() {
              _answersByQuestionId[q.id] = v;
            });
          },
          selected,
        );
      }
      return _questionRadioOptions(
        question: q.texto,
        options: options.map((o) => _RadioOption(label: o.etiqueta, value: o.valor)).toList(),
        selectedValue: selected,
        onChanged: (String? v) {
          setState(() {
            _answersByQuestionId[q.id] = v;
          });
        },
      );
    }
    if (q.tipo == 'number' || q.tipo == 'float' || q.tipo == 'decimal') {
      final controller = _textControllers.putIfAbsent(q.id, () {
        final initial = (_answersByQuestionId[q.id] ?? '').toString();
        final c = TextEditingController(text: initial);
        c.addListener(() {
          _answersByQuestionId[q.id] = c.text;
        });
        return c;
      });
      return _numberField(q.texto, 'Ingresa un número', controller);
    }
    if (q.tipo == 'date') {
      final controller = _textControllers.putIfAbsent(q.id, () {
        final initial = (_answersByQuestionId[q.id] ?? '').toString();
        return TextEditingController(text: initial);
      });
      return _dateField(
        q.texto,
        controller,
        onPick: () async {
          final now = DateTime.now();
          DateTime? initialDate;
          try {
            if (controller.text.isNotEmpty) {
              initialDate = DateTime.parse(controller.text);
            }
          } catch (_) {}
          final picked = await showDatePicker(
            context: context,
            initialDate: initialDate ?? now,
            firstDate: DateTime(1900),
            lastDate: DateTime(now.year + 5, 12, 31),
          );
          if (picked != null) {
            final value = picked.toIso8601String().split('T')[0];
            setState(() {
              controller.text = value;
              _answersByQuestionId[q.id] = value;
            });
          }
        },
      );
    }
    // text por defecto
    final controller = _textControllers.putIfAbsent(q.id, () {
      final c = TextEditingController(text: _answersByQuestionId[q.id] ?? '');
      c.addListener(() {
        _answersByQuestionId[q.id] = c.text;
      });
      return c;
    });
    return _textField(q.texto, 'Escribe aquí...', controller);
  }

  Widget _textField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black54),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFD6DADF),
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

  Widget _dateField(String label, TextEditingController controller, {required VoidCallback onPick}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: true,
          style: const TextStyle(color: Colors.black),
          onTap: onPick,
          decoration: InputDecoration(
            hintText: 'Selecciona una fecha',
            hintStyle: const TextStyle(color: Colors.black54),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.black54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFD6DADF),
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

  Widget _numberField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]')),
          ],
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black54),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFD6DADF),
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
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 4),
        RadioListTile<String>(
          title: const Text('Sí', style: TextStyle(color: Colors.black)),
          value: 'si',
          groupValue: selectedValue,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
        RadioListTile<String>(
          title: const Text('No', style: TextStyle(color: Colors.black)),
          value: 'no',
          groupValue: selectedValue,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _questionRadioOptions({
    required String question,
    required List<_RadioOption> options,
    required String? selectedValue,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          question,
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 4),
        ...options.map((opt) => RadioListTile<String>(
              title: Text(opt.label, style: const TextStyle(color: Colors.black)),
              value: opt.value,
              groupValue: selectedValue,
              onChanged: onChanged,
              activeColor: AppColors.primary,
            )),
      ],
    );
  }

}

class _RadioOption {
  final String label;
  final String value;
  _RadioOption({required this.label, required this.value});
}

