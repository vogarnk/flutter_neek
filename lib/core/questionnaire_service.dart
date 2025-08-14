import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';

class QuestionOption {
  final int id;
  final int questionId;
  final String etiqueta;
  final String valor;
  final int orden;

  QuestionOption({
    required this.id,
    required this.questionId,
    required this.etiqueta,
    required this.valor,
    required this.orden,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      questionId: json['cuestionario_pregunta_id'] is int
          ? json['cuestionario_pregunta_id']
          : int.tryParse('${json['cuestionario_pregunta_id']}') ?? 0,
      etiqueta: json['etiqueta']?.toString() ?? '',
      valor: json['valor']?.toString() ?? '',
      orden: json['orden'] is int ? json['orden'] : int.tryParse('${json['orden']}') ?? 0,
    );
  }
}

class QuestionModel {
  final int id;
  final int? legacyIndex;
  final String? codigo;
  final String texto;
  final String tipo; // 'radio' | 'text' | otros futuros
  final int step;
  final String? genero;
  final bool required;
  final int? dependsOnId;
  final String? dependsOnValue;
  final int orden;
  final List<QuestionOption> opciones;

  QuestionModel({
    required this.id,
    required this.legacyIndex,
    required this.codigo,
    required this.texto,
    required this.tipo,
    required this.step,
    required this.genero,
    required this.required,
    required this.dependsOnId,
    required this.dependsOnValue,
    required this.orden,
    required this.opciones,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      legacyIndex: json['legacy_index'] == null
          ? null
          : (json['legacy_index'] is int
              ? json['legacy_index']
              : int.tryParse('${json['legacy_index']}')),
      codigo: json['codigo'],
      texto: json['texto'] ?? '',
      tipo: (json['tipo'] ?? 'text').toString(),
      step: json['step'] is int ? json['step'] : int.tryParse('${json['step']}') ?? 1,
      genero: json['genero'],
      required: (json['required'] is int)
          ? (json['required'] == 1)
          : (json['required'] is bool ? json['required'] : false),
      dependsOnId: json['depends_on_id'] == null
          ? null
          : (json['depends_on_id'] is int
              ? json['depends_on_id']
              : int.tryParse('${json['depends_on_id']}')),
      dependsOnValue: json['depends_on_value']?.toString(),
      orden: json['orden'] is int ? json['orden'] : int.tryParse('${json['orden']}') ?? 0,
      opciones: (json['opciones'] is List)
          ? (json['opciones'] as List)
              .map((e) => QuestionOption.fromJson(e as Map<String, dynamic>))
              .toList()
          : <QuestionOption>[],
    );
  }
}

class QuestionnaireService {
  QuestionnaireService._internal();
  static final QuestionnaireService instance = QuestionnaireService._internal();

  Future<List<QuestionModel>> fetchQuestions() async {
    final http.Response resp = await ApiService.instance.get('/cuestionario/preguntas');
    if (resp.statusCode != 200) {
      throw Exception('Error al cargar preguntas (${resp.statusCode})');
    }
    final dynamic jsonBody = jsonDecode(resp.body);

    // Soportar respuesta con o sin "data"
    final List<dynamic> items;
    if (jsonBody is Map<String, dynamic> && jsonBody['data'] is List) {
      items = jsonBody['data'] as List;
    } else if (jsonBody is List) {
      items = jsonBody;
    } else {
      throw Exception('Formato de respuesta inesperado');
    }

    final List<QuestionModel> questions = items
        .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // Ordenar por step luego por orden
    questions.sort((a, b) {
      final byStep = a.step.compareTo(b.step);
      if (byStep != 0) return byStep;
      return a.orden.compareTo(b.orden);
    });
    return questions;
  }
}


