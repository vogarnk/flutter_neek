import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/modules/register/change_password_screen.dart';

class PlanSuccessScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const PlanSuccessScreen({
    super.key,
    required this.userData,
  });

  @override
  State<PlanSuccessScreen> createState() => _PlanSuccessScreenState();
}

class _PlanSuccessScreenState extends State<PlanSuccessScreen> {
  bool isLoading = true;
  bool success = false;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _enviarDatos();
  }

  Map<String, dynamic> _prepareRegistrationData() {
    final userData = widget.userData;
    
    print('📋 Preparando datos de registro...');
    print('📋 UserData keys: ${userData.keys.toList()}');
    print('📋 Selected plan: ${userData['selected_plan']}');
    
    // Preparar datos según el formato esperado por Laravel
    final registrationData = {
      // Datos de contacto
      'email': userData['email'],
      'celular': userData['celular'],
      
      // Código de verificación
      'code_1': userData['code_1'],
      'code_2': userData['code_2'],
      'code_3': userData['code_3'],
      'code_4': userData['code_4'],
      
      // Datos personales
      'primer_nombre': userData['primer_nombre'],
      'segundo_nombre': userData['segundo_nombre'],
      'apellido_paterno': userData['apellido_paterno'],
      'apellido_materno': userData['apellido_materno'],
      'genero': userData['genero'],
      'estado_salud': userData['estado_salud'],
      'fumador': userData['fumador'],
      
      // Fecha de nacimiento
      'dia': userData['dia'],
      'mes': userData['mes'],
      'year': userData['year'],
      
      // Preferencias
      'recibir_mensajes': userData['recibir_mensajes'] ?? 0,
      'deseaLlamadas': userData['deseaLlamadas'] ?? false,
      if (userData['preferred_call_time'] != null) 'preferred_call_time': userData['preferred_call_time'],
      
      // Referencia
      'referenciaOrigen': userData['referenciaOrigen'],
      if (userData['referral_slug'] != null) 'referral_slug': userData['referral_slug'],
      
      // Plan seleccionado - CRÍTICO: Enviar el nombre del archivo CSV
      if (userData['selected_plan'] != null) 'plan_seleccionado': _getPlanSelectionString(userData['selected_plan']),
      
      // Datos de simulación
      if (userData['simulation_type'] != null) 'simulation_type': userData['simulation_type'],
      if (userData['simulation_token'] != null) 'simulation_token': userData['simulation_token'],
      if (userData['simulation_parameters'] != null) 'simulation_parameters': userData['simulation_parameters'],
    };
    
    // Logging para debug
    final planSeleccionado = registrationData['plan_seleccionado'];
    print('🎯 Plan seleccionado que se enviará: $planSeleccionado');
    print('📤 Datos completos que se enviarán: ${registrationData.keys.toList()}');
    
    return registrationData;
  }

  String _getPlanSelectionString(dynamic selectedPlan) {
    if (selectedPlan == null) return '';
    
    print('🔍 Analizando plan seleccionado: $selectedPlan');
    
    // Si es un Map (JSON), extraer el csv_file directamente
    if (selectedPlan is Map<String, dynamic>) {
      final plan = selectedPlan;
      print('🔍 Plan Map keys: ${plan.keys.toList()}');
      
      // Buscar el campo csv_file (que ahora debería estar presente)
      final csvFile = plan['csv_file'] ?? '';
      print('📄 CSV File encontrado: $csvFile');
      
      if (csvFile.isNotEmpty) {
        return csvFile;
      }
      
      // Si no se encuentra csv_file, intentar construir el nombre basado en los datos del plan
      final age = plan['age'] ?? '';
      final monthlySavings = plan['prima_mensual_mxn'] ?? '';
      final coverageType = plan['coverage_type'] ?? '';
      final planDuration = plan['plan_duration'] ?? '';
      
      print('🔍 Datos extraídos: age=$age, monthlySavings=$monthlySavings, coverageType=$coverageType, planDuration=$planDuration');
      
      if (age.isNotEmpty && monthlySavings.isNotEmpty && coverageType.isNotEmpty && planDuration.isNotEmpty) {
        // Construir el nombre del archivo CSV en el formato esperado
        final csvFileName = '${age}_${monthlySavings}_${coverageType}_${planDuration}.csv';
        print('🔧 CSV File construido: $csvFileName');
        return csvFileName;
      }
    }
    
    // Si es un objeto PlanOption (fallback), extraer el csvFile
    if (selectedPlan.toString().contains('PlanOption')) {
      try {
        final planMap = selectedPlan as dynamic;
        if (planMap.csvFile != null && planMap.csvFile.toString().isNotEmpty) {
          print('📄 CSV File encontrado en PlanOption: ${planMap.csvFile}');
          return planMap.csvFile.toString();
        }
      } catch (e) {
        print('❌ Error al extraer csvFile del plan: $e');
      }
    }
    
    print('⚠️ No se pudo extraer el nombre del archivo CSV del plan');
    return '';
  }

  Future<void> _enviarDatos() async {
    try {
      // Preparar los datos para el nuevo endpoint
      final body = _prepareRegistrationData();
      print('📤 Enviando datos a Neek (nuevo endpoint):');
      print(jsonEncode(body));

      final response = await http.post(
        Uri.parse('https://app.neek.mx/api/register/complete'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
        body: jsonEncode(body),
      );

      final responseBody = jsonDecode(response.body);
      final mensaje = responseBody['message'] ?? 'Error desconocido';

      if (response.statusCode == 200) {
        // Verificar si la respuesta incluye token y requiere cambio de contraseña
        final data = responseBody;
        
        if (data['success'] == true && data['token'] != null) {
          // Guardar el token inmediatamente
          await _secureStorage.write(key: 'auth_token', value: data['token']);
          
          // Verificar si necesita cambiar contraseña
          if (data['requires_password_change'] == true) {
            setState(() {
              success = true;
              isLoading = false;
            });
            
            // Redirigir a pantalla de cambio de contraseña
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangePasswordScreen(),
              ),
            );
            return;
          } else {
            // No requiere cambio de contraseña, ir directamente al home
            setState(() {
              success = true;
              isLoading = false;
            });
            
            // Redirigir a splash screen para que maneje la navegación
            Navigator.pushReplacementNamed(context, '/');
            return;
          }
        } else {
          // Respuesta exitosa pero sin token (flujo tradicional)
          setState(() {
            success = true;
            isLoading = false;
          });
        }
      } else if (response.statusCode == 400 && mensaje.contains('código')) {
        // Código incorrecto → regresar al paso de verificación
        Navigator.pop(context); // o Navigator.pushReplacement para pantalla específica
      } else if (response.statusCode == 409 || mensaje.contains('correo')) {
        // Email duplicado
        setState(() {
          success = false;
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensaje)),
        );
      } else {
        // Otro error
        setState(() {
          success = false;
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar datos: $mensaje')),
        );
      }
    } catch (e) {
      setState(() {
        success = false;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión con el servidor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Ícono de éxito
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFDDEAFE),
                        ),
                        child: Icon(
                          success
                              ? Icons.rocket_launch_rounded
                              : Icons.error_outline,
                          size: 48,
                          color: success
                              ? AppColors.primary
                              : Colors.redAccent,
                        ),
                      ),
                      const SizedBox(height: 32),

                      Text(
                        success
                            ? '¡Felicidades!\nTu plan va en camino al futuro'
                            : 'Ocurrió un error',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textWhite,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        success
                            ? 'Hemos recibido tu información para crear tu cotización personalizada. La recibirás en unos momentos.'
                            : 'No pudimos guardar tu información. Intenta nuevamente o contáctanos.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textGray300,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Botón
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
                          onPressed: () {
                            // Aquí rediriges al Dashboard o página principal
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                          child: Text(
                            success ? 'Ver mi cuenta Neek' : 'Reintentar',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}