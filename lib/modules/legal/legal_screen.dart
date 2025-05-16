import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../pdfx_viewer_screen.dart';
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Legal'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.textWhite,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildLegalItem(
                title: 'Condiciones Generales: Seguro de Vida',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PdfxViewerScreen(
                        title: 'Condiciones Generales',
                        pdfUrl: 'https://app.neek.mx/CNSF-S0023-0577-2010%20de%20fecha%2022%20de%20Julio%20de%202016%20Condiciones%20Generales%20Tradicional%20en%20UDIS%20Maxipro.pdf',
                      ),
                    ),
                  );
                },
              ),
              const Divider(height: 0),
              _buildLegalItem(
                title: 'Terminos y condiciones: Neek',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PdfxViewerScreen(
                        title: 'Terminos y condiciones: Neek',
                        pdfUrl: 'https://app.neek.mx/Terrminos%20y%20Condiciones%20-%20neek.mx%201%20Enero%202024.pdf',
                      ),
                    ),
                  );
                },
              ),
              const Divider(height: 0),
              _buildLegalItem(
                title: 'Certificaciones',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PdfxViewerScreen(
                        title: 'Certificaciones',
                        pdfUrl: 'https://app.neek.mx/Certificaciones%20neek.pdf',
                      ),
                    ),
                  );
                },
              ),
              const Divider(height: 0),
              _buildLegalItem(
                title: 'Aviso de Privacidad',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PdfxViewerScreen(
                        title: 'Aviso de Privacidad',
                        pdfUrl: 'https://app.neek.mx/Aviso%20de%20Privacidad%20-%20neek.mx%201%20Enero%202024.pdf',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegalItem({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textGray900,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textGray400),
          ],
        ),
      ),
    );
  }
}
