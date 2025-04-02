import 'package:flutter/material.dart';

class EstadoActivoChip extends StatelessWidget {
  const EstadoActivoChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFD1FADF),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.verified, size: 18, color: Color(0xFF027A48)),
          SizedBox(width: 6),
          Text(
            'Activo',
            style: TextStyle(
              color: Color(0xFF027A48),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}