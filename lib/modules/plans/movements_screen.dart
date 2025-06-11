import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';

class MovementsScreen extends StatelessWidget {
  const MovementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.background50),
        title: const Text(
          'Movimientos',
          style: TextStyle(color: AppColors.background50),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 20),
            _buildStatusCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.account_balance_wallet, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Mis movimientos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.textGray900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Encuentra aquí el resumen actualizado de todos tus movimientos por periodos.',
            style: TextStyle(color: AppColors.textGray400),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Realizar siguiente aportación'),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: _buildStatusCardBody(),
    );
  }

  Widget _buildStatusCardBody() {
    return Column(
      children: [
        const Row(
          children: [
            Icon(Icons.compare_arrows_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text(
              'Estatus de movimientos',
              style: TextStyle(
                color: AppColors.textGray900,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 120,
          child: CustomPaint(
            painter: ArcPainter(),
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shield_outlined, color: AppColors.primary, size: 32),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('↑ Préstamos'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('↓ Ahorro'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildDisabledWithdrawButton(),
        const SizedBox(height: 20),
        _buildMovementData(),
      ],
    );
  }

  Widget _buildDisabledWithdrawButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.textGray300),
        borderRadius: BorderRadius.circular(32),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Retirar',
        style: TextStyle(color: AppColors.textGray400),
      ),
    );
  }

  Widget _buildMovementData() {
    return Column(
      children: const [
        _MovementRow(label: 'Total Ahorrado', value: '26,000.00 UDIS', dotColor: Colors.blue),
        _MovementRow(label: 'Total Préstamos', value: '1,300.00 UDIS', dotColor: Colors.lightBlue),
        _MovementRow(label: 'Total Ahorro Variable', value: '15,600.00 UDIS', dotColor: Colors.blue),
        _MovementRow(label: 'Recuperación', value: '70,666.00 UDIS'),
        _MovementRow(label: 'Aportaciones', value: '3/10'),
        _MovementRow(label: 'Retira en el 2033', value: '701,666.00 UDIS', link: true),
        _MovementRow(label: 'Retira en el 2073', value: '952,666.00 UDIS', link: true),
        _MovementRow(label: 'Suma Asegurada', value: '1,288,492.56 UDIS', bold: true),
        SizedBox(height: 12),
        Text(
          'Última actualización: 1/12/2023',
          style: TextStyle(color: AppColors.textGray400, fontSize: 12),
        ),
      ],
    );
  }
}

class _MovementRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? dotColor;
  final bool bold;
  final bool link;

  const _MovementRow({
    required this.label,
    required this.value,
    this.dotColor,
    this.bold = false,
    this.link = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (dotColor != null)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              Text(
                label,
                style: TextStyle(
                  color: link ? AppColors.primary : AppColors.textGray500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textGray900,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const startAngle = 3.14 * 0.75;
    const sweepAngle = 3.14 * 1.5;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    paint.color = const Color(0xFF2563EB);
    canvas.drawArc(
      Rect.fromCircle(center: size.center(Offset.zero), radius: 50),
      startAngle,
      sweepAngle * 0.33,
      false,
      paint,
    );

    paint.color = const Color(0xFFBFDBFE);
    canvas.drawArc(
      Rect.fromCircle(center: size.center(Offset.zero), radius: 50),
      startAngle + sweepAngle * 0.33,
      sweepAngle * 0.33,
      false,
      paint,
    );

    paint.color = const Color(0xFF1E40AF);
    canvas.drawArc(
      Rect.fromCircle(center: size.center(Offset.zero), radius: 50),
      startAngle + sweepAngle * 0.66,
      sweepAngle * 0.34,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}