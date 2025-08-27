import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import '../../core/theme/app_colors.dart';
import 'package:http/http.dart' as http;

class PdfxViewerScreen extends StatefulWidget {
  final String title;
  final String pdfUrl;

  const PdfxViewerScreen({
    super.key,
    required this.title,
    required this.pdfUrl,
  });

  @override
  State<PdfxViewerScreen> createState() => _PdfxViewerScreenState();
}

class _PdfxViewerScreenState extends State<PdfxViewerScreen> {
  PdfControllerPinch? _pdfController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Validar URL
      final uri = Uri.tryParse(widget.pdfUrl);
      if (uri == null || !uri.hasAbsolutePath) {
        throw Exception('URL inválida: ${widget.pdfUrl}');
      }

      // Descargar el PDF
      final response = await http.get(Uri.parse(widget.pdfUrl));
      
      if (response.statusCode != 200) {
        throw Exception('Error HTTP: ${response.statusCode}');
      }

      final pdfBytes = response.bodyBytes;
      
      if (pdfBytes.isEmpty) {
        throw Exception('El PDF está vacío');
      }

      // Crear el controlador del PDF usando openData directamente
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openData(pdfBytes),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar el PDF: $e';
      });
      debugPrint('❌ Error cargando PDF: $e');
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(widget.title),
        foregroundColor: AppColors.textWhite,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando PDF...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error al cargar el PDF',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPdf,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_pdfController == null) {
      return const Center(
        child: Text('No se pudo cargar el PDF'),
      );
    }

    return PdfViewPinch(
      controller: _pdfController!,
      scrollDirection: Axis.vertical,
    );
  }
}
