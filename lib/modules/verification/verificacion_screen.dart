import 'package:flutter/material.dart';
import 'package:neek/screens/personal_data_screen.dart'; // Ajusta el path si es necesario

class VerificacionScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const VerificacionScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1221),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1221),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Verificación', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 16),
                  Icon(Icons.verified, size: 60, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 20),
                  Text(
                    'Bienvenido a\nverifica tu cuenta',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.displaySmall?.color),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Queremos conocerte mejor, verifica tu identidad para continuar haciendo trámites dentro de tu cuenta Neek.\n\n¡Te tomará de 5 a 10 minutos! Recuerda guardar tu proceso completado.\n\nAl verificar tu cuenta podrás tener todo listo para la activación de tu plan, cotizar más de dos planes y acceder a todos los beneficios de tu cuenta.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodySmall?.color),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PersonalDataScreen(user: user)),
                        );
                      },
                      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                      child: const Text('Comenzar'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tu información está protegida, para más información puedes leer nuestro ',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Redirigir al aviso de privacidad
                    },
                    child: const Text(
                      'Aviso de Privacidad',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}