import 'package:flutter/material.dart';
import 'package:neek/shared/app_bars/custom_home_app_bar.dart'; // 👈 Importa el widget
import 'package:neek/shared/cards/ahorro_card.dart';
import 'package:neek/shared/cards/plan_card.dart';
import 'package:neek/shared/cards/udi_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final List<String> planNames;

  const HomeScreen({
    Key? key,
    required this.user,
    required this.planNames,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  bool _hasShownModal = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);
    
    // Mostrar modal después de que el widget se construya
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPlansModalIfNeeded();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showPlansModalIfNeeded() {
    print('🏠 _showPlansModalIfNeeded - user_plans tipo: ${widget.user['user_plans'].runtimeType}');
    
    // Manejar user_plans como Map o List
    List<dynamic> userPlansRaw = [];
    
    if (widget.user['user_plans'] is Map) {
      print('🏠 _showPlansModalIfNeeded - user_plans es Map, convirtiendo a lista');
      final Map<String, dynamic> userPlansMap = widget.user['user_plans'] ?? {};
      userPlansRaw = userPlansMap.values.toList();
    } else if (widget.user['user_plans'] is List) {
      print('🏠 _showPlansModalIfNeeded - user_plans es List, usando directamente');
      userPlansRaw = widget.user['user_plans'] ?? [];
    } else {
      print('🏠 _showPlansModalIfNeeded - user_plans es de tipo inesperado: ${widget.user['user_plans'].runtimeType}');
      userPlansRaw = [];
    }
    
    final plans = List<Map<String, dynamic>>.from(userPlansRaw);
    if (plans.isEmpty && !_hasShownModal) {
      setState(() {
        _hasShownModal = true;
      });
      _showPlansInfoModal();
    }
  }

  void _showPlansInfoModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E293B), // slate-800
                  Color(0xFF334155), // slate-700
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icono de carga
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B5BFE),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.sync,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Título
                const Text(
                  '¡Estamos trabajando en tu información!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                // Mensaje
                const Text(
                  'Nuestro equipo está procesando y cargando la información de tus planes. Estará disponible a la brevedad.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 24),
                
                // Botón de acción
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Aquí puedes navegar al perfil del usuario
                      // Navigator.pushNamed(context, '/profile');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B5BFE),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Completar mi perfil',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Botón secundario
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Entendido',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('🏠 HomeScreen - user_plans tipo: ${widget.user['user_plans'].runtimeType}');
    print('🏠 HomeScreen - user_plans contenido: ${widget.user['user_plans']}');
    
    // user_plans puede ser un Map o una List, necesitamos manejarlo correctamente
    List<dynamic> userPlansRaw = [];
    
    if (widget.user['user_plans'] is Map) {
      print('🏠 HomeScreen - user_plans es Map, convirtiendo a lista');
      final Map<String, dynamic> userPlansMap = widget.user['user_plans'] ?? {};
      userPlansRaw = userPlansMap.values.toList();
    } else if (widget.user['user_plans'] is List) {
      print('🏠 HomeScreen - user_plans es List, usando directamente');
      userPlansRaw = widget.user['user_plans'] ?? [];
    } else {
      print('🏠 HomeScreen - user_plans es de tipo inesperado: ${widget.user['user_plans'].runtimeType}');
      userPlansRaw = [];
    }
    
    final plans = List<Map<String, dynamic>>.from(userPlansRaw)
      ..sort((a, b) {
        final statusA = (a['status'] ?? '').toString().toLowerCase();
        final statusB = (b['status'] ?? '').toString().toLowerCase();
        
        // Si ambos tienen el mismo status, mantener el orden original
        if (statusA == statusB) return 0;
        
        // Definir jerarquía de estados (mayor prioridad = menor número)
        final Map<String, int> statusPriority = {
          'autorizado': 1,
          'autorizado_por_pagar_1': 2,
          'cotizado': 3,
          'pendiente': 4,
          'cancelado': 5,
        };
        
        // Obtener prioridades, si no existe en el mapa, usar prioridad baja (999)
        final priorityA = statusPriority[statusA] ?? 999;
        final priorityB = statusPriority[statusB] ?? 999;
        
        // Ordenar por prioridad (menor número = mayor prioridad)
        return priorityA.compareTo(priorityB);
      });
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LOGO + ICONOS
              CustomHomeAppBar(user: widget.user),

              const SizedBox(height: 20),

              Text(
                '${widget.user['name']}!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Este es un resumen de tu cuenta',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 24),

              // TARJETA DE AHORRO
              Builder(
                builder: (context) {
                  print('🏠 AhorroCard - user_plans tipo: ${widget.user['user_plans'].runtimeType}');
                  
                  // Manejar user_plans como Map o List
                  List<dynamic> ahorroPlansRaw = [];
                  
                  if (widget.user['user_plans'] is Map) {
                    print('🏠 AhorroCard - user_plans es Map, convirtiendo a lista');
                    final Map<String, dynamic> ahorroPlansMap = widget.user['user_plans'] ?? {};
                    ahorroPlansRaw = ahorroPlansMap.values.toList();
                  } else if (widget.user['user_plans'] is List) {
                    print('🏠 AhorroCard - user_plans es List, usando directamente');
                    ahorroPlansRaw = widget.user['user_plans'] ?? [];
                  } else {
                    print('🏠 AhorroCard - user_plans es de tipo inesperado: ${widget.user['user_plans'].runtimeType}');
                    ahorroPlansRaw = [];
                  }
                  
                  final List<Map<String, dynamic>> ahorroPlans = List<Map<String, dynamic>>.from(ahorroPlansRaw);
                  return AhorroCard(plans: ahorroPlans);
                },
              ),

              const SizedBox(height: 20),

              // TARJETA DE PLAN
              if (plans.isNotEmpty)
                SizedBox(
                  height: 320,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                    final plan = plans[index];

                    final beneficiarios = List<Map<String, dynamic>>.from(plan['beneficiarios'] ?? []);
                    final nombre = plan['nombre_plan'] ?? 'Plan sin nombre';
                    final udis = double.tryParse(plan['recuperacion_final_udis'].toString()) ?? 0;
                    final udisMxn = double.tryParse(plan['recuperacion_final_udis_mxn'].toString()) ?? 0;
                    final sumaAsegurada = (plan['suma_asegurada'] ?? 0).toDouble();
                    final sumaAseguradaMxn = (plan['suma_asegurada_mxn'] ?? 0).toDouble();
                    final totalRetirar = (plan['total_a_retirar'] ?? 0).toDouble();
                    final totalRetirarMxn = (plan['total_a_retirar_mxn'] ?? 0).toDouble();
                    final totalRetirar2065 = (plan['total_a_retirar_2065'] ?? 0).toDouble();
                    final totalRetirar2065Mxn = (plan['total_a_retirar_2065_mxn'] ?? 0).toDouble();
                    final duracion = (plan['duracion'] ?? 0).toInt();
                    final status = plan['status'] ?? 'Sin status';
                    final userPlanId = plan['id'] ?? 'Sin id';
                    final polizaUrl = plan['poliza'];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: PlanCard(
                        user: widget.user,
                        nombrePlan: nombre,
                        duracion: duracion,
                        recuperacionFinalUdis: udis,
                        recuperacionFinalMxn: udisMxn,
                        sumaAsegurada: sumaAsegurada,
                        sumaAseguradaMxn: sumaAseguradaMxn,
                        totalRetirar: totalRetirar,
                        totalRetirarMxn: totalRetirarMxn,
                        totalRetirar2065: totalRetirar2065,
                        totalRetirar2065Mxn: totalRetirar2065Mxn,
                        beneficiarios: beneficiarios, // ✅ agregado
                        status: status,
                        userPlanId: userPlanId,
                        polizaUrl: polizaUrl,
                      ),
                    );
                  },
                ),
              )
              else
                // Widget alternativo cuando no hay planes
                Container(
                  height: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icono
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B5BFE).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Icon(
                            Icons.assignment_outlined,
                            color: Color(0xFF3B5BFE),
                            size: 40,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Título
                        const Text(
                          'Sin planes activos',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Mensaje
                        const Text(
                          'Tus planes aparecerán aquí una vez que estén disponibles.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

              if (plans.isNotEmpty) const SizedBox(height: 12),

              // Indicador de página
              if (plans.isNotEmpty)
                Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: plans.length,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 6,
                      activeDotColor: Color(0xFF3B5BFE),
                      dotColor: Color(0xFFCBD5E1), // Tailwind slate-300 aprox
                    ),
                  ),
                ),


              const SizedBox(height: 20),

              // TARJETA UDI
              UdiCard(
                udisActual: widget.user['udis_actual']?.toDouble(),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}