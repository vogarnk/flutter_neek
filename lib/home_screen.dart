import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movibus/widgets/charts/animated_multi_ring_chart.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LOGO + ICONOS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    'assets/logo.svg',
                    height: 25,
                    fit: BoxFit.contain,                    
                  ),
                  Row(
                    children: const [
                      Icon(Icons.headphones, color: Colors.white70),
                      SizedBox(width: 16),
                      Icon(Icons.notifications_none, color: Colors.white70),
                      SizedBox(width: 16),
                      Icon(Icons.person_outline, color: Colors.white70),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                'Hola Lucia!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Este es un resumen de tu cuenta',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 24),

              // TARJETA DE AHORRO
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Chip(
                            label: Text('Activo'),
                            backgroundColor: Color(0xFFD1FADF),
                            labelStyle: TextStyle(color: Color(0xFF027A48)),
                          ),
                          SizedBox(height: 8),
                          Text('Ahorro total', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('200,800 UDIS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: 12),
                          Text('● Familia Monasteri', style: TextStyle(color: Colors.indigo)),
                          Text('● Mi Futuro', style: TextStyle(color: Colors.indigo)),
                          Text('● Mis Hijos', style: TextStyle(color: Colors.indigo)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const AnimatedMultiRingChart(
                      values: [0.9, 0.8, 0.75],
                      colors: [
                        Color(0xFF1E3A8A),
                        Color(0xFF2563EB),
                        Color(0xFF60A5FA),
                      ],
                      size: 100,
                    ),                    
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // TARJETA DE PLAN
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('neek', style: TextStyle(color: Colors.white70, fontSize: 16)),
                    const SizedBox(height: 4),
                    const Text('Mis Hijos', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('Lucia Monarrez', style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 12),
                    const Text('MOTIVO DE AHORRO:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const Text('Retiro', style: TextStyle(color: Colors.white, fontSize: 14)),
                    const SizedBox(height: 4),
                    const Text('PLAN DE AHORRO + PROTECCIÓN', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: const Text('Por Activar'),
                          backgroundColor: const Color(0xFFFDF6B2),
                          labelStyle: const TextStyle(color: Color(0xFF92400E)),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B5BFE),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Ver Plan'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '160,860.49 UDIS',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // TARJETA UDI
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('8.24 MXN 🇲🇽', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Valor del UDI al día de hoy', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    SizedBox(
                      width: 80,
                      height: 40,
                      child: Image.asset('assets/udi_graph.png', fit: BoxFit.cover), // imagen curva UDI
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
  
}