import 'package:flutter/material.dart';
import 'edit_request_screen.dart';

/// Ejemplo de cómo usar la pantalla de solicitud de cambio
class ChangeRequestExample extends StatelessWidget {
  const ChangeRequestExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejemplo de Solicitud'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditRequestScreen(),
              ),
            );
          },
          child: const Text('Abrir Solicitud de Cambio'),
        ),
      ),
    );
  }
}
