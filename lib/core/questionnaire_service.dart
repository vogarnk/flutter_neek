import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Cache de preguntas para búsquedas rápidas
  List<QuestionModel>? _cachedQuestions;

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

    // Debug: mostrar algunos valores de legacy_index para verificar
    print('🔍 QuestionnaireService: Debug - primeros 5 preguntas:');
    for (int i = 0; i < 5 && i < questions.length; i++) {
      final q = questions[i];
      print('  Pregunta ${q.id}: legacy_index=${q.legacyIndex}, texto=${q.texto.substring(0, min(50, q.texto.length))}...');
    }

    // Ordenar por step luego por orden
    questions.sort((a, b) {
      final byStep = a.step.compareTo(b.step);
      if (byStep != 0) return byStep;
      return a.orden.compareTo(b.orden);
    });

    // Cachear preguntas para búsquedas rápidas
    _cachedQuestions = questions;

    return questions;
  }

  /// Envía las respuestas del cuestionario para un plan específico
  Future<Map<String, dynamic>> sendQuestionnaireAnswers({
    required int userPlanId,
    required Map<int, dynamic> answersByQuestionId,
    List<QuestionModel>? questions, // Preguntas para mapear legacy_index
  }) async {
    try {
      // Convertir respuestas al formato esperado por el backend
      // Solo incluir preguntas que tienen respuesta
      final List<Map<String, dynamic>> respuestas = [];

      answersByQuestionId.forEach((questionId, answer) {
        // Solo enviar respuestas válidas
        if (questionId > 0 && answer != null && answer.toString().trim().isNotEmpty) {
          // Buscar la pregunta correspondiente para obtener el legacy_index correcto
          QuestionModel? question;

          // Primero intentar con las preguntas pasadas como parámetro
          if (questions != null) {
            try {
              question = questions.firstWhere((q) => q.id == questionId);
            } catch (e) {
              print('🔍 QuestionnaireService: Pregunta con ID $questionId no encontrada en las preguntas proporcionadas');
            }
          } else {
            // Fallback al cache interno si no se pasaron preguntas
            question = _findQuestionById(questionId);
          }

          // Usar legacy_index si está disponible y es válido (<= 183), sino usar el id original
          final legacyIndex = question?.legacyIndex;
          final preguntaIdToSend = (legacyIndex != null && legacyIndex >= 0 && legacyIndex <= 183) ? legacyIndex : questionId;

          print('🔍 QuestionnaireService: Debug - questionId: $questionId, legacyIndex: $legacyIndex, preguntaIdToSend: $preguntaIdToSend');

          // Verificación estricta: solo enviar respuestas con pregunta_id válido (<= 183)
          if (preguntaIdToSend <= 183) {
            respuestas.add({
              'pregunta_id': preguntaIdToSend,
              'respuesta': answer.toString().trim(),
            });
          } else {
            print('⚠️ QuestionnaireService: SKIPPING respuesta con pregunta_id $preguntaIdToSend > 183');
          }
        }
      });

      print('🔍 QuestionnaireService: Enviando respuestas para userPlanId = $userPlanId');
      print('🔍 QuestionnaireService: Número de respuestas = ${respuestas.length}');

      // Debug: mostrar el mapeo de IDs
      print('🔍 QuestionnaireService: Mapeo de IDs:');
      answersByQuestionId.forEach((questionId, answer) {
        if (answer != null && answer.toString().trim().isNotEmpty) {
          final question = questions?.firstWhere((q) => q.id == questionId);
          final legacyIndex = question?.legacyIndex ?? questionId;
          print('  ID interno: $questionId -> legacy_index: $legacyIndex');
        }
      });

      print('🔍 QuestionnaireService: Respuestas finales = $respuestas');

      if (respuestas.isEmpty) {
        return {
          'success': false,
          'message': 'No hay respuestas para enviar',
        };
      }

      final response = await ApiService.instance.post(
        '/cuestionario/user-plans/$userPlanId/respuestas',
        body: {
          'respuestas': respuestas,
        },
      );

      print('🔍 QuestionnaireService: Status code = ${response.statusCode}');
      print('🔍 QuestionnaireService: Response body = ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'message': 'Respuestas enviadas correctamente',
        };
      } else {
        try {
          final errorData = jsonDecode(response.body);
          return {
            'success': false,
            'message': errorData['message'] ?? 'Error al enviar respuestas',
            'errors': errorData['errors'],
          };
        } catch (e) {
          return {
            'success': false,
            'message': 'Error ${response.statusCode}: ${response.body}',
          };
        }
      }
    } catch (e) {
      print('🔍 QuestionnaireService: Excepción capturada: $e');
      return {
        'success': false,
        'message': 'Error al enviar respuestas: ${e.toString()}',
      };
    }
  }

  /// Guarda las respuestas del cuestionario localmente en el dispositivo
  Future<void> saveQuestionnaireLocally({
    required int userPlanId,
    required Map<int, dynamic> answersByQuestionId,
    List<QuestionModel>? questions, // Opcional, para mantener consistencia con la interfaz
  }) async {
    try {
      // Crear una versión serializable de las respuestas
      final Map<String, dynamic> serializableAnswers = {};

      answersByQuestionId.forEach((questionId, answer) {
        try {
          // Convertir diferentes tipos de respuestas a valores JSON-serializables
          if (answer is TextEditingController) {
            serializableAnswers[questionId.toString()] = answer.text;
          } else if (answer is String) {
            serializableAnswers[questionId.toString()] = answer;
          } else if (answer is int) {
            serializableAnswers[questionId.toString()] = answer;
          } else if (answer is double) {
            serializableAnswers[questionId.toString()] = answer;
          } else if (answer is bool) {
            serializableAnswers[questionId.toString()] = answer;
          } else if (answer != null) {
            // Para otros tipos, convertir a string
            serializableAnswers[questionId.toString()] = answer.toString();
          } else {
            // Si es null, no incluirlo (solo si realmente es null)
            if (answer == null) {
              serializableAnswers[questionId.toString()] = null;
            }
          }
        } catch (e) {
          print('🔍 QuestionnaireService: Error al procesar respuesta para pregunta $questionId: $e');
          // Si hay error al procesar una respuesta específica, convertir a string como fallback
          serializableAnswers[questionId.toString()] = answer?.toString() ?? '';
        }
      });

      final Map<String, dynamic> dataToSave = {
        'userPlanId': userPlanId,
        'answers': serializableAnswers,
        'timestamp': DateTime.now().toIso8601String(),
      };

      final String jsonData = jsonEncode(dataToSave);
      await _storage.write(key: 'questionnaire_draft', value: jsonData);

      print('🔍 QuestionnaireService: Respuestas guardadas localmente para userPlanId = $userPlanId');
      print('🔍 QuestionnaireService: Número de respuestas guardadas = ${serializableAnswers.length}');
    } catch (e) {
      print('🔍 QuestionnaireService: Error al guardar respuestas localmente: $e');
      throw Exception('Error al guardar respuestas localmente');
    }
  }

  /// Carga las respuestas del cuestionario guardadas localmente
  Future<Map<String, dynamic>?> loadQuestionnaireLocally() async {
    try {
      final String? jsonData = await _storage.read(key: 'questionnaire_draft');

      if (jsonData == null) {
        print('🔍 QuestionnaireService: No hay respuestas guardadas localmente');
        return null;
      }

      final Map<String, dynamic> data = jsonDecode(jsonData);

      // Verificar si los datos son recientes (menos de 7 días)
      final DateTime timestamp = DateTime.parse(data['timestamp']);
      final Duration difference = DateTime.now().difference(timestamp);

      if (difference.inDays > 7) {
        print('🔍 QuestionnaireService: Datos guardados expiraron (más de 7 días)');
        await clearLocalQuestionnaire();
        return null;
      }

      print('🔍 QuestionnaireService: Respuestas cargadas localmente para userPlanId = ${data['userPlanId']}');

      // Convertir las claves de vuelta de String a int y manejar tipos de datos
      final Map<int, dynamic> convertedAnswers = {};
      final answers = data['answers'] as Map<String, dynamic>;

      answers.forEach((key, value) {
        final intKey = int.tryParse(key);
        if (intKey != null) {
          // Mantener el tipo original del valor cuando sea posible
          if (value is String || value is int || value is double || value is bool || value == null) {
            convertedAnswers[intKey] = value;
          } else {
            // Para otros tipos, convertir a string como fallback
            convertedAnswers[intKey] = value?.toString() ?? '';
          }
        }
      });

      return {
        'userPlanId': data['userPlanId'],
        'answers': convertedAnswers,
      };
    } catch (e) {
      print('🔍 QuestionnaireService: Error al cargar respuestas localmente: $e');
      // Si hay error, limpiar los datos corruptos
      await clearLocalQuestionnaire();
      return null;
    }
  }

  /// Limpia las respuestas guardadas localmente
  Future<void> clearLocalQuestionnaire() async {
    try {
      await _storage.delete(key: 'questionnaire_draft');
      print('🔍 QuestionnaireService: Respuestas locales eliminadas');
    } catch (e) {
      print('🔍 QuestionnaireService: Error al eliminar respuestas locales: $e');
    }
  }

  /// Verifica si hay respuestas guardadas localmente
  Future<bool> hasLocalQuestionnaire() async {
    try {
      final data = await loadQuestionnaireLocally();
      return data != null;
    } catch (e) {
      return false;
    }
  }

  /// Busca una pregunta por su ID interno
  QuestionModel? _findQuestionById(int id) {
    return _cachedQuestions?.firstWhere((question) => question.id == id);
  }

  /// Obtiene todas las preguntas cacheadas
  List<QuestionModel>? getCachedQuestions() {
    return _cachedQuestions;
  }
}


