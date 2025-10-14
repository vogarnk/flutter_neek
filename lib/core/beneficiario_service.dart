import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class BeneficiarioService {
  static const _baseUrl = 'https://app.neek.mx/api';
  static const _storage = FlutterSecureStorage();

  // Método para verificar la configuración
  static Future<void> verificarConfiguracion() async {
    print('🔧 [BeneficiarioService] Verificando configuración...');
    print('🌐 [BeneficiarioService] Base URL: $_baseUrl');
    
    final authToken = await _storage.read(key: 'auth_token');
    print('🔑 [BeneficiarioService] Token: ${authToken != null ? 'Presente (${authToken.length} caracteres)' : 'No encontrado'}');
    
    if (authToken != null) {
      print('🔑 [BeneficiarioService] Token preview: ${authToken.substring(0, authToken.length > 20 ? 20 : authToken.length)}...');
    }
  }

  // Método para obtener el user_plan_id del usuario actual
  static Future<int?> obtenerUserPlanId() async {
    try {
      final authToken = await _storage.read(key: 'auth_token');
      if (authToken == null) {
        print('❌ [BeneficiarioService] No hay token para obtener user_plan_id');
        return null;
      }

      print('🔍 [BeneficiarioService] Intentando obtener user_plan_id de /api/user');

      // Intentar obtener información del usuario desde el token o hacer una llamada a la API
      final response = await http.get(
        Uri.parse('$_baseUrl/user'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Accept': 'application/json',
        },
      );

      print('📥 [BeneficiarioService] Respuesta de /api/user: ${response.statusCode}');
      print('📥 [BeneficiarioService] Cuerpo de respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('📋 [BeneficiarioService] Datos del usuario: $data');
        
        // Buscar user_plan_id en diferentes ubicaciones
        int? userPlanId = data['data']['user_plan_id'] ?? data['data']['plan_id'];
        
        // Si no se encuentra directamente, buscar en user_plans
        if (userPlanId == null && data['data']['user_plans'] != null) {
          // Manejar user_plans como Map o List
          List<dynamic> userPlans = [];
          
          if (data['data']['user_plans'] is Map) {
            print('👥 BeneficiarioService - user_plans es Map, convirtiendo a lista');
            final Map<String, dynamic> userPlansMap = data['data']['user_plans'];
            userPlans = userPlansMap.values.toList();
          } else if (data['data']['user_plans'] is List) {
            print('👥 BeneficiarioService - user_plans es List, usando directamente');
            userPlans = data['data']['user_plans'] ?? [];
          } else {
            print('👥 BeneficiarioService - user_plans es de tipo inesperado: ${data['data']['user_plans'].runtimeType}');
            userPlans = [];
          }
          print('📋 [BeneficiarioService] User plans encontrados: ${userPlans.length}');
          
          if (userPlans.isNotEmpty) {
            // Tomar el primer plan activo o el primero disponible
            final firstPlan = userPlans.first;
            userPlanId = firstPlan['id'];
            print('📋 [BeneficiarioService] Usando plan ID: $userPlanId (${firstPlan['nombre_plan']})');
          }
        }
        
        print('📋 [BeneficiarioService] User Plan ID obtenido: $userPlanId');
        return userPlanId;
      } else {
        print('❌ [BeneficiarioService] Error al obtener user_plan_id: ${response.statusCode}');
        print('❌ [BeneficiarioService] Cuerpo del error: ${response.body}');
        
        // Intentar obtener del token JWT como fallback
        final tokenUserPlanId = _obtenerUserPlanIdDelToken(authToken);
        if (tokenUserPlanId != null) {
          return tokenUserPlanId;
        }
        
        // Probar diferentes endpoints
        final endpointUserPlanId = await _probarEndpointsUsuario(authToken);
        if (endpointUserPlanId != null) {
          return endpointUserPlanId;
        }
        
        // TEMPORAL: Usar un valor hardcodeado para pruebas
        print('⚠️ [BeneficiarioService] Usando user_plan_id temporal para pruebas: 1');
        return 1;
      }
    } catch (e) {
      print('💥 [BeneficiarioService] Error al obtener user_plan_id: $e');
      
      // Intentar obtener del token JWT como fallback
      final authToken = await _storage.read(key: 'auth_token');
      if (authToken != null) {
        final tokenUserPlanId = _obtenerUserPlanIdDelToken(authToken);
        if (tokenUserPlanId != null) {
          return tokenUserPlanId;
        }
        
        // Probar diferentes endpoints
        final endpointUserPlanId = await _probarEndpointsUsuario(authToken);
        if (endpointUserPlanId != null) {
          return endpointUserPlanId;
        }
      }
      
      // TEMPORAL: Usar un valor hardcodeado para pruebas
      print('⚠️ [BeneficiarioService] Usando user_plan_id temporal para pruebas: 1');
      return 1;
    }
  }

  // Método auxiliar para intentar obtener user_plan_id del token JWT
  static int? _obtenerUserPlanIdDelToken(String token) {
    try {
      print('🔍 [BeneficiarioService] Intentando extraer user_plan_id del token JWT');
      
      // Los tokens JWT tienen formato: header.payload.signature
      final parts = token.split('.');
      if (parts.length != 3) {
        print('❌ [BeneficiarioService] Token no tiene formato JWT válido');
        return null;
      }

      // Decodificar el payload (segunda parte)
      final payload = parts[1];
      
      // Agregar padding si es necesario para base64
      String paddedPayload = payload;
      while (paddedPayload.length % 4 != 0) {
        paddedPayload += '=';
      }
      
      // Decodificar base64
      final decodedBytes = base64Url.decode(paddedPayload);
      final decodedString = utf8.decode(decodedBytes);
      
      print('📋 [BeneficiarioService] Payload del token: $decodedString');
      
      final payloadData = jsonDecode(decodedString);
      final userPlanId = payloadData['user_plan_id'] ?? payloadData['plan_id'];
      
      print('📋 [BeneficiarioService] User Plan ID del token: $userPlanId');
      return userPlanId;
      
    } catch (e) {
      print('💥 [BeneficiarioService] Error al decodificar token JWT: $e');
      return null;
    }
  }

  // Método para probar diferentes endpoints que podrían tener información del usuario
  static Future<int?> _probarEndpointsUsuario(String authToken) async {
    final endpoints = [
      '/api/user',
      '/api/profile',
      '/api/me',
      '/api/auth/user',
      '/api/auth/profile',
    ];

    for (final endpoint in endpoints) {
      try {
        print('🔍 [BeneficiarioService] Probando endpoint: $endpoint');
        
        final response = await http.get(
          Uri.parse('$_baseUrl$endpoint'),
          headers: {
            'Authorization': 'Bearer $authToken',
            'Accept': 'application/json',
          },
        );

        print('📥 [BeneficiarioService] Respuesta de $endpoint: ${response.statusCode}');
        
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          print('📋 [BeneficiarioService] Datos de $endpoint: $data');
          
          // Buscar user_plan_id en diferentes ubicaciones posibles
          final userPlanId = data['user_plan_id'] ?? 
                           data['plan_id'] ?? 
                           data['data']['user_plan_id'] ?? 
                           data['data']['plan_id'] ??
                           data['user']['user_plan_id'] ??
                           data['user']['plan_id'];
          
          if (userPlanId != null) {
            print('✅ [BeneficiarioService] User Plan ID encontrado en $endpoint: $userPlanId');
            return userPlanId;
          }
        }
      } catch (e) {
        print('💥 [BeneficiarioService] Error probando $endpoint: $e');
      }
    }
    
    return null;
  }

  // Obtener beneficiarios del usuario
  static Future<List<Map<String, dynamic>>> getBeneficiarios({int? userPlanId}) async {
    try {
      final authToken = await _storage.read(key: 'auth_token');
      
      print('🔍 [BeneficiarioService] Iniciando getBeneficiarios');
      print('🔑 [BeneficiarioService] Token encontrado: ${authToken != null ? 'SÍ' : 'NO'}');
      print('📋 [BeneficiarioService] User Plan ID: $userPlanId');
      
      if (authToken == null) {
        throw Exception('No se encontró el token de autenticación');
      }

      // Construir URL con parámetros si es necesario
      String url = '$_baseUrl/beneficiarios';
      if (userPlanId != null) {
        url += '?user_plan_id=$userPlanId';
      }

      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      print('🌐 [BeneficiarioService] URL: $url');
      print('📤 [BeneficiarioService] Headers: $headers');

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('📥 [BeneficiarioService] Status Code: ${response.statusCode}');
      print('📥 [BeneficiarioService] Response Headers: ${response.headers}');
      print('📥 [BeneficiarioService] Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final beneficiarios = List<Map<String, dynamic>>.from(data['data'] ?? []);
        print('✅ [BeneficiarioService] Beneficiarios obtenidos: ${beneficiarios.length}');
        return beneficiarios;
      } else {
        print('❌ [BeneficiarioService] Error ${response.statusCode}: ${response.body}');
        throw Exception('Error al obtener beneficiarios: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('💥 [BeneficiarioService] Excepción: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  // Crear un nuevo beneficiario
  static Future<Map<String, dynamic>> createBeneficiario({
    required String nombres,
    String? segundoNombre,
    required String apellidoPaterno,
    String? apellidoMaterno,
    required DateTime fechaNacimiento,
    required String parentesco,
    String? email,
    String? ocupacion,
    required double porcentaje,
    required String tipo, // 'basico', 'intermedio', 'avanzado'
    required bool mismoDomicilio,
    Map<String, dynamic>? domicilio,
    String? ineFile, // Base64 del archivo
    Map<String, dynamic>? tutor, // Datos del tutor si es menor de edad
    int? userPlanId, // ID del plan del usuario
  }) async {
    try {
      final authToken = await _storage.read(key: 'auth_token');
      
      print('🔍 [BeneficiarioService] Iniciando createBeneficiario');
      print('🔑 [BeneficiarioService] Token encontrado: ${authToken != null ? 'SÍ' : 'NO'}');
      
      if (authToken == null) {
        throw Exception('No se encontró el token de autenticación');
      }

      final body = {
        'name': nombres, // Primer nombre
        'sName': segundoNombre, // Segundo nombre (opcional)
        'lName': apellidoPaterno, // Apellido paterno
        'lName2': apellidoMaterno, // Apellido materno (opcional)
        'dateBirth': fechaNacimiento.toIso8601String().split('T')[0], // Solo la fecha sin tiempo
        'parentesco': parentesco,
        'email': email,
        'ocupacion': ocupacion,
        'porcentaje': porcentaje,
        'tipo': tipo,
        'mismo_domicilio': mismoDomicilio,
        'domicilio': domicilio,
        'ine_file': ineFile,
        'tutor': tutor,
        if (userPlanId != null) 'user_plan_id': userPlanId,
      };

      final url = '$_baseUrl/beneficiarios';
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      print('🌐 [BeneficiarioService] URL: $url');
      print('📤 [BeneficiarioService] Headers: $headers');
      print('📤 [BeneficiarioService] Body: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      print('📥 [BeneficiarioService] Status Code: ${response.statusCode}');
      print('📥 [BeneficiarioService] Response Headers: ${response.headers}');
      print('📥 [BeneficiarioService] Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('✅ [BeneficiarioService] Beneficiario creado exitosamente');
        return data['data'];
      } else {
        print('❌ [BeneficiarioService] Error ${response.statusCode}: ${response.body}');
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Error al crear beneficiario');
      }
    } catch (e) {
      print('💥 [BeneficiarioService] Excepción: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  // Actualizar un beneficiario existente
  static Future<Map<String, dynamic>> updateBeneficiario({
    required int beneficiarioId,
    String? nombres,
    String? segundoNombre,
    String? apellidoPaterno,
    String? apellidoMaterno,
    DateTime? fechaNacimiento,
    String? parentesco,
    String? ocupacion,
    double? porcentaje,
    String? tipo,
    bool? mismoDomicilio,
    Map<String, dynamic>? domicilio,
    String? ineFile,
    Map<String, dynamic>? tutor,
  }) async {
    try {
      final authToken = await _storage.read(key: 'auth_token');
      
      if (authToken == null) {
        throw Exception('No se encontró el token de autenticación');
      }

      final body = <String, dynamic>{};
      if (nombres != null) body['nombres'] = nombres;
      if (segundoNombre != null) body['segundo_nombre'] = segundoNombre;
      if (apellidoPaterno != null) body['apellido_paterno'] = apellidoPaterno;
      if (apellidoMaterno != null) body['apellido_materno'] = apellidoMaterno;
      if (fechaNacimiento != null) body['fecha_nacimiento'] = fechaNacimiento.toIso8601String();
      if (parentesco != null) body['parentesco'] = parentesco;
      if (ocupacion != null) body['ocupacion'] = ocupacion;
      if (porcentaje != null) body['porcentaje'] = porcentaje;
      if (tipo != null) body['tipo'] = tipo;
      if (mismoDomicilio != null) body['mismo_domicilio'] = mismoDomicilio;
      if (domicilio != null) body['domicilio'] = domicilio;
      if (ineFile != null) body['ine_file'] = ineFile;
      if (tutor != null) body['tutor'] = tutor;

      final response = await http.put(
        Uri.parse('$_baseUrl/beneficiarios/$beneficiarioId'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Error al actualizar beneficiario');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Eliminar un beneficiario
  static Future<bool> deleteBeneficiario(int beneficiarioId) async {
    try {
      final authToken = await _storage.read(key: 'auth_token');
      
      if (authToken == null) {
        throw Exception('No se encontró el token de autenticación');
      }

      final response = await http.delete(
        Uri.parse('$_baseUrl/beneficiarios/$beneficiarioId'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Activar/desactivar un beneficiario
  static Future<bool> toggleBeneficiarioStatus(int beneficiarioId, bool activo) async {
    try {
      final authToken = await _storage.read(key: 'auth_token');
      
      if (authToken == null) {
        throw Exception('No se encontró el token de autenticación');
      }

      final response = await http.patch(
        Uri.parse('$_baseUrl/beneficiarios/$beneficiarioId/status'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'activo': activo}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Validar que la suma de porcentajes no exceda 100%
  static bool validatePorcentajes(List<Map<String, dynamic>> beneficiarios, double nuevoPorcentaje) {
    final sumaActual = beneficiarios.fold<double>(
      0, 
      (sum, b) => sum + (b['porcentaje'] ?? 0)
    );
    return (sumaActual + nuevoPorcentaje) <= 100;
  }

  // Calcular edad a partir de fecha de nacimiento
  static int calcularEdad(DateTime fechaNacimiento) {
    final ahora = DateTime.now();
    int edad = ahora.year - fechaNacimiento.year;
    if (ahora.month < fechaNacimiento.month || 
        (ahora.month == fechaNacimiento.month && ahora.day < fechaNacimiento.day)) {
      edad--;
    }
    return edad;
  }

  // Verificar si es menor de edad
  static bool esMenorDeEdad(DateTime fechaNacimiento) {
    return calcularEdad(fechaNacimiento) < 18;
  }

  // Método para probar la conexión a la API
  static Future<bool> probarConexion({int? userPlanId}) async {
    try {
      print('🧪 [BeneficiarioService] Probando conexión a la API...');
      
      final authToken = await _storage.read(key: 'auth_token');
      if (authToken == null) {
        print('❌ [BeneficiarioService] No hay token de autenticación');
        return false;
      }

      // Construir URL con parámetros si es necesario
      String url = '$_baseUrl/beneficiarios';
      if (userPlanId != null) {
        url += '?user_plan_id=$userPlanId';
      }

      final headers = {
        'Authorization': 'Bearer $authToken',
        'Accept': 'application/json',
      };

      print('🌐 [BeneficiarioService] Probando URL: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('📥 [BeneficiarioService] Respuesta de prueba: ${response.statusCode}');
      print('📥 [BeneficiarioService] Cuerpo de respuesta: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ [BeneficiarioService] Conexión exitosa');
        return true;
      } else {
        print('❌ [BeneficiarioService] Error en conexión: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('💥 [BeneficiarioService] Error en prueba de conexión: $e');
      return false;
    }
  }
}
