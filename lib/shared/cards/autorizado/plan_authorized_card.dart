import 'package:flutter/material.dart';
import '../../../pdfx_viewer_screen.dart';

class PlanAuthorizedCard extends StatelessWidget {
  final String? polizaUrl;
  
  const PlanAuthorizedCard({
    super.key,
    this.polizaUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4), // verde muy claro
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 20), // verde
              SizedBox(width: 8),
              Text(
                'Todo listo para iniciar tu plan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF16A34A),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Tu plan está autorizado, para acceder y tener control de tu ahorro completo, debes revisar tu póliza y pagar la primera aportación.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF4B5563),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (polizaUrl != null && polizaUrl!.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PdfxViewerScreen(
                      title: 'Mi Póliza',
                      pdfUrl: polizaUrl!,
                    ),
                  ),
                );
              } else {
                // Mostrar mensaje de que la póliza no está disponible
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('La póliza no está disponible en este momento'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Ver mi póliza',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
