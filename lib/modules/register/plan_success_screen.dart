import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neek/core/theme/app_colors.dart';

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

  @override
  void initState() {
    super.initState();
    _enviarDatos();
  }

  Future<void> _enviarDatos() async {
    try {
      final body = {...widget.userData};
      print('📤 Enviando datos a Neek:');
      print(jsonEncode(body));

      final response = await http.post(
        Uri.parse('https://app.neek.mx/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final responseBody = jsonDecode(response.body);
      final mensaje = responseBody['message'] ?? 'Error desconocido';

      if (response.statusCode == 200) {
        setState(() {
          success = true;
          isLoading = false;
        });
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