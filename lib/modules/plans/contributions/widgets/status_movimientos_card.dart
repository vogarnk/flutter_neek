import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class StatusMovimientosCard extends StatelessWidget {
  const StatusMovimientosCard({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: Column(
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
          TextField(
            enabled: false,
            decoration: InputDecoration(
              hintText: 'Retirar',
              hintStyle: const TextStyle(color: AppColors.textGray500),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 20),
          _item('Total Ahorrado', '26,000.00 UDIS', dotColor: Colors.blue),
          _item('Total Préstamos', '1,300.00 UDIS', dotColor: Colors.lightBlueAccent),
          _item('Total Ahorro Variable', '15,600.00 UDIS', dotColor: Colors.blue),
          _item('Recuperación', '70,666.00 UDIS'),
          _item('Aportaciones', '3/10'),
          _item('Retira en el 2033', '701,666.00 UDIS', link: true),
          _item('Retira en el 2073', '952,666.00 UDIS', link: true),
          _item('Suma Asegurada', '1,288,492.56 UDIS', bold: true),
          const SizedBox(height: 12),
          const Text(
            'Última actualización: 1/12/2023',
            style: TextStyle(color: AppColors.textGray400, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _item(String label, String value,
      {Color? dotColor, bool bold = false, bool link = false}) {
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
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              Text(
                label,
                style: const TextStyle(color: AppColors.textGray500),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: link
                  ? AppColors.primary
                  : AppColors.textGray900,
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