import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import '../../core/theme/app_colors.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PlanQuoteDetailsScreen extends StatefulWidget {
  const PlanQuoteDetailsScreen({super.key});

  @override
  State<PlanQuoteDetailsScreen> createState() => _PlanQuoteDetailsScreenState();
}

class _PlanQuoteDetailsScreenState extends State<PlanQuoteDetailsScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  late AndroidDeviceInfo? androidInfo;

  @override
  void initState() {
    super.initState();
    initDeviceInfo();
  }

  Future<void> initDeviceInfo() async {
    final info = await DeviceInfoPlugin().androidInfo;
    setState(() {
      androidInfo = info;
    });
  }
  Future<void> _captureAndShare() async {
    // Detecta si es Android 13+
    if (Platform.isAndroid && androidInfo?.version.sdkInt != null && androidInfo!.version.sdkInt >= 33) {
      final photos = await Permission.photos.request();
      if (!photos.isGranted) {
        debugPrint('❌ Permiso de fotos no concedido (Android 13+)');
        return;
      }
    } else {
      final storage = await Permission.storage.request();
      if (!storage.isGranted) {
        debugPrint('❌ Permiso de almacenamiento no concedido');
        return;
      }
    }

    try {
      final Uint8List? imageBytes = await _screenshotController.capture();
      if (imageBytes == null) {
        debugPrint('❌ Falló la captura');
        return;
      }

      final directory = await getExternalStorageDirectory();
      final imagePath = '${directory!.path}/plan_quote_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(imagePath)..writeAsBytesSync(imageBytes);

      debugPrint('✅ Imagen guardada: $imagePath');

      await Share.shareXFiles(
        [XFile(imagePath)],
        text: 'Mira los detalles de mi plan de ahorro.',
      );
    } catch (e) {
      debugPrint('❌ Error al guardar o compartir: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Coberturas de mi plan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              debugPrint('Botón presionado');
              _captureAndShare();
            },
          )
        ],
      ),
      body: Screenshot(
        controller: _screenshotController,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tu plan de ahorro cuenta con coberturas que te ayudarán a estar protegido.\nEncuentra aquí las coberturas incluidas en tu plan y las adicionales seleccionadas.',
                style: TextStyle(color: AppColors.textGray300),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Resumen de Aportaciones'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildContributionTable(),
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('Coberturas Incluidas'),
              _buildCoverageCard(
                title: 'Cobertura por Fallecimiento',
                description: 'La cobertura básica del seguro de vida y ahorro pagará la suma asegurada a los beneficiarios designados en la póliza al ocurrir el fallecimiento del Asegurado.',
              ),
              _buildCoverageCard(
                title: 'Eliminación de aportaciones en caso de invalidez total y permanente (BIT)',
                description: 'Si durante el plazo de seguro el asegurado contratante sufriera invalidez total y permanente, la compañía lo eximirá del pago de primas futuras después de un periodo de espera de 6 meses.',
              ),
              _buildCoverageCard(
                title: 'Adelanto de Suma Asegurada por enfermedad terminal',
                description: 'Se pagará el 25% de la suma asegurada de la cobertura básica con un límite máximo de 500.',
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Coberturas Extra'),
              _buildCoverageCard(
                title: 'BIPA - Pago de Suma por Invalidez Total y Permanente',
                description: 'Si el asegurado sufre invalidez total y permanente, se pagará la suma asegurada en una sola exhibición tras comprobarse la invalidez y pasar 6 meses de espera.',
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Coberturas D Seleccionada'),
              _buildCoverageCard(
                title: 'DI2 - Indemnización por muerte accidental o pérdida de miembros',
                description: 'DI1 + Pago de suma asegurada por pérdida de miembros. Las lesiones se pagarán conforme a la escala A o B indicada en la tabla de indemnización.',
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Plan de Ahorro Cotizado'),
              _buildAnnualPlanTable(),
            ],
          ),
        ),
      ),
    );
  }

  // Títulos de sección
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textWhite,
      ),
    );
  }

  // Tarjetas de cobertura
  Widget _buildCoverageCard({required String title, required String description}) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textGray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(color: AppColors.textGray500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Tabla de aportaciones
  Widget _buildContributionTable() {
    const cellPadding = EdgeInsets.symmetric(vertical: 12, horizontal: 8);
    const headerStyle = TextStyle(fontWeight: FontWeight.bold, color: Colors.white);
    const cellStyle = TextStyle(color: AppColors.textGray900, fontSize: 14);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(80),
          1: FixedColumnWidth(80),
          2: FixedColumnWidth(95),
          3: FixedColumnWidth(110),
          4: FixedColumnWidth(110),
          5: FixedColumnWidth(100),
        },
        border: TableBorder.symmetric(
          inside: BorderSide(color: AppColors.textGray200, width: 0.5),
        ),
        children: [
          TableRow(
            decoration: BoxDecoration(color: AppColors.primary),
            children: const [
              Padding(padding: cellPadding, child: Text('MONEDA', style: headerStyle, textAlign: TextAlign.center)),
              Padding(padding: cellPadding, child: Text('PLAZO', style: headerStyle, textAlign: TextAlign.center)),
              Padding(padding: cellPadding, child: Text('ANUAL', style: headerStyle, textAlign: TextAlign.center)),
              Padding(padding: cellPadding, child: Text('SEMESTRAL', style: headerStyle, textAlign: TextAlign.center)),
              Padding(padding: cellPadding, child: Text('TRIMESTRAL', style: headerStyle, textAlign: TextAlign.center)),
              Padding(padding: cellPadding, child: Text('MENSUAL', style: headerStyle, textAlign: TextAlign.center)),
            ],
          ),
          TableRow(
            children: const [
              Padding(padding: cellPadding, child: Text('UDIS', style: cellStyle, textAlign: TextAlign.center)),
              Padding(padding: cellPadding, child: Text('10 años', style: cellStyle, textAlign: TextAlign.center)),
              Padding(padding: cellPadding, child: Text('2,181', style: cellStyle, textAlign: TextAlign.center)),
              Padding(padding: cellPadding, child: Text('1,091', style: cellStyle, textAlign: TextAlign.center)),
              Padding(padding: cellPadding, child: Text('545', style: cellStyle, textAlign: TextAlign.center)),
              Padding(padding: cellPadding, child: Text('182', style: cellStyle, textAlign: TextAlign.center)),
            ],
          ),
          TableRow(
            children: const [
              Padding(padding: cellPadding, child: Text('MXN', style: cellStyle, textAlign: TextAlign.center)),
              Padding(padding: cellPadding, child: Text('10 años', style: cellStyle, textAlign: TextAlign.center)),
              Padding(padding: cellPadding, child: Text('\$18,473.07', style: cellStyle, textAlign: TextAlign.center)),
              Padding(padding: cellPadding, child: Text('\$9,240.77', style: cellStyle, textAlign: TextAlign.center)),
              Padding(padding: cellPadding, child: Text('\$4,616.15', style: cellStyle, textAlign: TextAlign.center)),
              Padding(padding: cellPadding, child: Text('\$1,541.54', style: cellStyle, textAlign: TextAlign.center)),
            ],
          ),
        ],
      ),
    );
  }

  // Tabla anual de proyecciones
  Widget _buildAnnualPlanTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FixedColumnWidth(60),
            1: FixedColumnWidth(50),
            2: FixedColumnWidth(70),
            3: FixedColumnWidth(120),
            4: FixedColumnWidth(120),
            5: FixedColumnWidth(140),
            6: FixedColumnWidth(120),
          },
          border: TableBorder.symmetric(
            inside: BorderSide(color: AppColors.textGray200, width: 0.5),
          ),
          children: [
            TableRow(
              decoration: BoxDecoration(color: AppColors.primary),
              children: [
                _annualHeader('AÑO'),
                _annualHeader('EDAD'),
                _annualHeader('VALOR UDI'),
                _annualHeader('SUMA ASEGURADA'),
                _annualHeader('APORTACIÓN'),
                _annualHeader('TOTAL AHORRADO'),
                _annualHeader('RECUPERACIÓN'),
              ],
            ),
            _buildRow('2025', '28', '8.47', '\$93,093', '2,181', '2,181', '-'),
            _buildRow('', '', '', '788,498', '\$18,473.07', '\$18,473.07', '-'),
            _buildRow('2026', '29', '8.81', '\$93,093', '2,181', '4,362', '-'),
            _buildRow('', '', '', '820,038', '\$19,211.99', '\$37,685.06', '-'),
            _buildRow('2027', '30', '9.16', '\$93,093', '2,181', '6,543', '1,682'),
            _buildRow('', '', '', '852,839', '\$19,980.47', '\$57,665.54', '\$15,409.06'),
            _buildRow('2028', '31', '9.53', '\$93,093', '2,181', '8,724', '3,588'),
            _buildRow('', '', '', '886,953', '\$20,779.69', '\$78,445.23', '\$34,185.02'),
          ],
        ),
      ),
    );
  }

  static Widget _annualHeader(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center),
      );

  TableRow _buildRow(String year, String age, String udi, String suma, String aporte, String ahorro, String recuperacion) {
    const style = TextStyle(color: AppColors.textGray900, fontSize: 13);
    const pad = EdgeInsets.symmetric(vertical: 10, horizontal: 6);

    return TableRow(
      children: [
        Padding(padding: pad, child: Text(year, style: style, textAlign: TextAlign.center)),
        Padding(padding: pad, child: Text(age, style: style, textAlign: TextAlign.center)),
        Padding(padding: pad, child: Text(udi, style: style, textAlign: TextAlign.center)),
        Padding(padding: pad, child: Text(suma, style: style, textAlign: TextAlign.center)),
        Padding(padding: pad, child: Text(aporte, style: style, textAlign: TextAlign.center)),
        Padding(padding: pad, child: Text(ahorro, style: style, textAlign: TextAlign.center)),
        Padding(padding: pad, child: Text(recuperacion, style: style, textAlign: TextAlign.center)),
      ],
    );
  }
}