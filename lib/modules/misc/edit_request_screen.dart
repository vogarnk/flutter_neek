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
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '¿Qué te gustaría cambiar?',
                style: TextStyle(
                  color: Colors.black87,
                )
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                style: TextStyle(
                  color: Colors.grey.shade800,
                ),
                dropdownColor: Theme.of(context).colorScheme.surface,
                items: const [
                  DropdownMenuItem(value: 'correo', child: Text('Correo')),
                  DropdownMenuItem(value: 'nombre', child: Text('Nombre')),
                  DropdownMenuItem(value: 'telefono', child: Text('Teléfono')),
                  DropdownMenuItem(value: 'direccion', child: Text('Dirección')),
                  DropdownMenuItem(value: 'fecha_nacimiento', child: Text('Fecha de nacimiento')),
                  DropdownMenuItem(value: 'rfc', child: Text('RFC')),
                  DropdownMenuItem(value: 'curp', child: Text('CURP')),
                  DropdownMenuItem(value: 'estado_civil', child: Text('Estado civil')),
                  DropdownMenuItem(value: 'beneficiarios', child: Text('Beneficiarios')),
                  DropdownMenuItem(value: 'otro', child: Text('Otro')),
                ],
                onChanged: (value) {
                  // lógica para manejar selección
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                hint: Text(
                  'Selecciona un dato',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),// 👈 Esto muestra el placeholder
              ),
              const SizedBox(height: 16),
              Text(
                'Describe aquí que te gustaria cambiar',
                style: TextStyle(
                  color: Colors.black87,
                )
              ),
              const SizedBox(height: 8),
              TextFormField(
                style: TextStyle(
                  color: Colors.grey.shade800,
                ),
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Escribe aquí...',
                  hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ), // 👈 Aquí se usa bodySmall
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 1.5,
                    ),
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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
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