import 'package:flutter/material.dart';

class WhatIsNeekScreen extends StatelessWidget {
  const WhatIsNeekScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1320),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1320),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '¿Qué es Neek?',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Neek es una plataforma digital de ahorro y protección',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E1320),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Con Neek puedes crear metas de ahorro personalizadas, conocer el valor diario de las UDIs, cotizar un plan, proteger a tu familia con coberturas, gestionar tu seguro y más.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF374151),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Además, Neek te ayuda a tomar decisiones informadas sobre tu futuro financiero, brindando herramientas educativas y asesoría personalizada.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF374151),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}