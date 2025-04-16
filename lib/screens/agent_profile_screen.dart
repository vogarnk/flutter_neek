import 'package:flutter/material.dart';

class AgentProfileScreen extends StatelessWidget {
  const AgentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1320),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1320),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Mi Agente Neek'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/agent.jpg'), // 👈 Reemplaza con NetworkImage si usas URL
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enrique Ramos',
                    style: TextStyle(fontSize: 18 , color: Theme.of(context).textTheme.displaySmall?.color),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.verified, color: Color(0xFF2B5FF3), size: 18),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Agente Verificado Neek',
                style: TextStyle(
                  color: Color(0xFF2B5FF3),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ahorremos para tu futuro 😄🚀',
                style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
              ),
              const SizedBox(height: 20),

              // Biografía
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Biografía',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Hola! Mi nombre es Enrique Ramos Yudiche y soy tu Agente de Seguros Neek. '
                  'Mi compromiso es guiarte y ayudarte en lo que necesites. ¡Envía tu dinero al futuro!',
                  style: TextStyle(fontSize: 14 , color: Theme.of(context).textTheme.bodySmall?.color) ,
                ),
              ),
              const SizedBox(height: 20),

              // Fecha de inicio
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Agente Neek desde',
                    style: TextStyle(fontWeight: FontWeight.w500 , color: Theme.of(context).textTheme.displaySmall?.color),
                  ),
                  Text(
                    '08/2020',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Botones
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Header
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Cédula del Agente',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    // Imagen
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/images/cedula.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Ver Cédula'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B5FF3),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Agendar Asesoría'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}