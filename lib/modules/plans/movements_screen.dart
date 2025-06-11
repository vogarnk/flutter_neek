import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../modules/plans/contributions/widgets/status_movimientos_card.dart';
import '../../modules/plans/widgets/movements_table_card.dart'; // 👈 nuevo import

class MovementsScreen extends StatelessWidget {
  const MovementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Movimientos',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            _HeaderCard(),
            SizedBox(height: 20),
            StatusMovimientosCard(),
            SizedBox(height: 20),
            MovementsTableCard(), // 👈 nuevo widget
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
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
}