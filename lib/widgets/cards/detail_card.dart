import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final String title;
  final String udis;
  final String mxn;
  final IconData icon;

  const DetailCard({
    super.key,
    required this.title,
    required this.udis,
    required this.mxn,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  udis,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  mxn,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFF0C1C3C),
            child: Icon(icon, size: 30, color: Colors.white),
          )
        ],
      ),
    );
  }
}
