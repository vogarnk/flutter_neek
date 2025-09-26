import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class UserPlanService {
  UserPlanService._internal();
  static final UserPlanService instance = UserPlanService._internal();

  final ApiService _apiService = ApiService.instance;

  /// Actualiza el nombre de un plan de usuario
  Future<Map<String, dynamic>> updatePlanName({
    required int userPlanId,
    required String nombrePlan,
  }) async {
    print('🔍 UserPlanService: Iniciando updatePlanName');
    print('🔍 UserPlanService: userPlanId = $userPlanId');
    print('🔍 UserPlanService: nombrePlan = $nombrePlan');
    
    try {
      final body = {
        'user_plan_id': userPlanId,
        'nombrePlan': nombrePlan,
      };

      print('🔍 UserPlanService: Body = $body');
      print('🔍 UserPlanService: Llamando a la API...');
      
      final response = await _apiService.post('/user-plans/update-name', body: body);
      
      print('🔍 UserPlanService: Status code = ${response.statusCode}');
      print('🔍 UserPlanService: Response body = ${response.body}');
      
      final result = _handleResponse(response);
      print('🔍 UserPlanService: Resultado procesado = $result');
      
      return result;
    } catch (e) {
      print('🔍 UserPlanService: Excepción capturada: $e');
      return {
        'success': false,
        'message': 'Error al actualizar el nombre del plan: ${e.toString()}',
      };
    }
  }

  /// Obtiene los planes del usuario
  Future<Map<String, dynamic>> getUserPlans() async {
    try {
      final response = await _apiService.get('/user-plans');
      return _handleResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al obtener los planes: ${e.toString()}',
      };
    }
  }

  /// Maneja la respuesta de la API
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } catch (e) {
        return {
          'success': true,
          'data': response.body,
        };
      }
    } else {
      try {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Error en la petición',
          'errors': errorData['errors'],
        };
      } catch (e) {
        return {
          'success': false,
          'message': 'Error ${response.statusCode}: ${response.body}',
        };
      }
    }
  }
}
