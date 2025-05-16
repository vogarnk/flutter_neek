import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter/services.dart';

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
  late PdfControllerPinch _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfControllerPinch(
      document: PdfDocument.openData(
        NetworkAssetBundle(Uri.parse(widget.pdfUrl)).load(widget.pdfUrl).then((bd) => bd.buffer.asUint8List()),
      ),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
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
      body: PdfViewPinch(
        controller: _pdfController,
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
