import 'package:flutter/material.dart';

class PlanActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const PlanActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              icon,
              color: Colors.black,
              size: 40, // 👈 Aumenta este valor para agrandar el ícono
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
