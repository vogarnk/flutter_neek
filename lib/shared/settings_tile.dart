import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const SettingsTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Necesario para mostrar splash en fondo blanco
      child: InkWell(
        onTap: onTap,
        splashColor: const Color(0x332B5FF3), // azul translúcido
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: titleStyle),
                    const SizedBox(height: 4),
                    Text(subtitle, style: subtitleStyle),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}