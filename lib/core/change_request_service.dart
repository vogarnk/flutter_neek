import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ChangeRequestService {
  ChangeRequestService._internal();
  static final ChangeRequestService instance = ChangeRequestService._internal();

  final ApiService _apiService = ApiService.instance;

  /// Crea una nueva solicitud de cambio
  Future<Map<String, dynamic>> createChangeRequest({
    required String dataToModify,
    required String problemDescription,
    required String tipoSolicitud,
    File? file,
  }) async {
    try {
      if (file != null) {
        // Crear solicitud con archivo usando multipart
        final fields = {
          'data_to_modify': dataToModify,
          'problem_description': problemDescription,
          'tipo_solicitud': tipoSolicitud,
        };

        final multipartFile = await http.MultipartFile.fromPath(
          'file',
          file.path,
        );

        final response = await _apiService.postMultipart(
          path: '/change-requests',
          fields: fields,
          files: [multipartFile],
        );

        return _handleResponse(response);
      } else {
        // Crear solicitud sin archivo usando JSON
        final body = {
          'data_to_modify': dataToModify,
          'problem_description': problemDescription,
          'tipo_solicitud': tipoSolicitud,
        };

        final response = await _apiService.post('/change-requests', body: body);
        return _handleResponse(response);
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al crear la solicitud: ${e.toString()}',
      };
    }
  }

  /// Obtiene todas las solicitudes del usuario
  Future<Map<String, dynamic>> getUserChangeRequests() async {
    try {
      final response = await _apiService.get('/change-requests');
      return _handleResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al obtener las solicitudes: ${e.toString()}',
      };
    }
  }

  /// Obtiene una solicitud específica
  Future<Map<String, dynamic>> getChangeRequest(int id) async {
    try {
      final response = await _apiService.get('/change-requests/$id');
      return _handleResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al obtener la solicitud: ${e.toString()}',
      };
    }
  }

  /// Cancela una solicitud
  Future<Map<String, dynamic>> cancelChangeRequest(int id) async {
    try {
      final response = await _apiService.post('/change-requests/$id/cancel');
      return _handleResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al cancelar la solicitud: ${e.toString()}',
      };
    }
  }

  /// Maneja la respuesta de la API
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final data = response.body.isNotEmpty 
            ? Map<String, dynamic>.from(response.body as Map<String, dynamic>)
            : <String, dynamic>{};
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
        final errorData = Map<String, dynamic>.from(response.body as Map<String, dynamic>);
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
