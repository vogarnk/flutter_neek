import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class EditRequestScreen extends StatelessWidget {
  const EditRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1320),
      appBar: AppBar(
        title: const Text('Solicitud de Cambio'),
        backgroundColor: const Color(0xFF0E1320),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Solicitud de cambio de datos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,                  
                  fontSize: 18,
                  color: Theme.of(context).textTheme.displaySmall?.color,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '¿Qué te gustaría cambiar?',
                style: TextStyle(
                  color: Theme.of(context).textTheme.displaySmall?.color,
                )
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                items: const [
                  DropdownMenuItem(value: 'correo', child: Text('Correo')),
                  DropdownMenuItem(value: 'nombre', child: Text('Nombre')),
                  DropdownMenuItem(value: 'telefono', child: Text('Teléfono')),
                ],
                onChanged: (value) {
                  // lógica para manejar selección
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                hint: const Text(
                  'Correo',
                  style: TextStyle(
                    color: Colors.black54, // 👈 Así te aseguras de que no sea blanco
                    fontSize: 16,
                  ),
                ),// 👈 Esto muestra el placeholder
              ),
              const SizedBox(height: 16),
              Text(
                'Describe aquí que te gustaria cambiar',
                style: TextStyle(
                  color: Theme.of(context).textTheme.displaySmall?.color,
                )
              ),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Escribe aquí...',
                  hintStyle: Theme.of(context).textTheme.bodySmall, // 👈 Aquí se usa bodySmall
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.upload),
                label: const Text('Subir imagen o archivo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B5FF3),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                  children: [
                    const TextSpan(
                      text: 'Tu información está protegida, para más información puedes leer nuestro ',
                    ),
                    TextSpan(
                      text: 'Aviso de Privacidad',
                      style: const TextStyle(
                        color: Color(0xFF2B5FF3),
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Abrir enlace de privacidad
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B5FF3),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Enviar solicitud'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}