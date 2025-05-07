import 'package:flutter/material.dart';
import 'package:neek/modules/plans/what_is_neek_screen.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1621), // Fondo oscuro
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Centro de Ayuda', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpItem(
                title: '¿Qué es Neek?',
                subtitle: 'Conoce qué es Neek y cómo puede ayudarte a ahorrar.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WhatIsNeekScreen()),
                  );
                },
              ),
              const Divider(height: 1, color: Colors.black12),
              _buildHelpItem(
                title: '¿Cómo funcionan los planes de ahorro?',
                subtitle: 'Aprende cómo funcionan y cómo puedes beneficiarte.',
              ),
              const Divider(height: 1, color: Colors.black12),
              _buildHelpItem(
                title: 'Seguro de Vida',
                subtitle: 'Entiende qué cubre y cómo contratarlo.',
              ),
              const Divider(height: 1, color: Colors.black12),
              _buildHelpItem(
                title: 'Preguntas Frecuentes',
                subtitle: 'Consulta respuestas rápidas a dudas comunes.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpItem({
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: 16,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: const TextStyle(color: Colors.black54),
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.black38),
      onTap: onTap,
    );
  }
}