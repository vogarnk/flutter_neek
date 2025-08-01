import 'package:flutter/material.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/modules/beneficiaries/create_beneficiary_screen.dart';

class BeneficiariesCard extends StatelessWidget {
  final List<dynamic> beneficiarios;
  final bool mostrarBoton;

  const BeneficiariesCard({
    super.key,
    required this.beneficiarios,
    this.mostrarBoton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mis beneficiarios',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textGray900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Administra tus beneficiarios',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textGray400,
            ),
          ),
          const SizedBox(height: 20),

          // Encabezados
          Row(
            children: const [
              Expanded(
                flex: 3,
                child: Text(
                  'BENEFICIARIO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.textGray500,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'TIPO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.textGray500,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'ACCESO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.textGray500,
                  ),
                ),
              ),
              Text(
                '%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.textGray500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),

          const SizedBox(height: 8),
          ...beneficiarios.map((b) {
            return Column(
              children: [
                _beneficiarioRow(
                  avatar: b['avatar_url'],
                  nombre: b['nombre'] ?? 'Desconocido',
                  tipo: 'Tradicional',
                  acceso: b['tipo'] ?? 'Sin tipo',
                  porcentaje: int.tryParse(b['porcentaje'].toString()) ?? 0,
                ),
                const Divider(height: 24),
              ],
            );
          }).toList(),

          const SizedBox(height: 8),

          // Footer
          mostrarBoton
              ? SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CreateBeneficiaryScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Añadir beneficiarios'),
                  ),
                )
        : GestureDetector(
            onTap: () => _mostrarTiposBeneficiarios(context),
            child: Row(
              children: const [
                Text(
                  'Tipos de beneficiarios',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textGray400,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.info_outline, size: 16, color: AppColors.textGray400),
              ],
            ),
          ),              
        ],
      ),
    );
  }

  Widget _beneficiarioRow({
    String? avatar,
    required String nombre,
    required String tipo,
    required String acceso,
    required int porcentaje,
  }) {
    final accesoLower = acceso.toLowerCase();
    final bool esBasico = accesoLower == 'básico';
    final bool esIntermedio = accesoLower == 'intermedio';
    final bool esAvanzado = accesoLower == 'avanzado';

    final Color bgColor = esBasico
        ? const Color(0xFFF1F0FF)
        : esIntermedio
            ? const Color(0xFFE0FCF9)
            : esAvanzado
                ? const Color(0xFFCCFBF1)
                : const Color(0xFFE5E7EB);

    final Color textColor = esBasico
        ? const Color(0xFF6366F1)
        : esIntermedio
            ? const Color(0xFF06B6D4)
            : esAvanzado
                ? const Color(0xFF0D9488)
                : AppColors.textGray500;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar + nombre (todo como una celda)
          Expanded(
            flex: 3,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFE5E7EB), // gris claro de fondo
                  child: Icon(
                    Icons.person,
                    color: Color(0xFF9CA3AF), // gris medio para el ícono
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textGray900,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Tipo
          Expanded(
            flex: 2,
            child: Text(
              tipo,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: AppColors.textGray900,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),

          // Acceso badge
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  acceso,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Porcentaje
          Text(
            '$porcentaje%',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.textGray900,
            ),
          ),
        ],
      ),
    );
  }

void _mostrarTiposBeneficiarios(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tipos de beneficiarios',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.textGray900,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '¿Que es un beneficiario?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textGray900,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Un beneficiario es la persona que el “Asegurado” selecciona en caso de hacer válida la cobertura básica. Neek te ofrece personalizar el nivel de acceso a la información de tu seguro.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textGray500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tipos de beneficiarios',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textGray900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _tipoBeneficiarioTile(
                      'Básico',
                      'Este nivel le permite al beneficiario saber: Tipo de cobertura, Número de Póliza, Botón de emergencia.',
                      Color(0xFFF1F0FF),
                      Color(0xFF6366F1),
                    ),
                    const SizedBox(height: 12),
                    _tipoBeneficiarioTile(
                      'Intermedio',
                      'Incluye lo del nivel básico más: Porcentaje de beneficiario y Suma Asegurada.',
                      Color(0xFFE0FCF9),
                      Color(0xFF06B6D4),
                    ),
                    const SizedBox(height: 12),
                    _tipoBeneficiarioTile(
                      'Avanzado',
                      'Incluye los dos niveles anteriores más: Información completa de todos los beneficiarios y porcentajes.',
                      Color(0xFFCCFBF1),
                      Color(0xFF0D9488),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Entendido'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}
Widget _tipoBeneficiarioTile(String titulo, String descripcion, Color bgColor, Color textColor) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          descripcion,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textGray900,
          ),
        ),
      ],
    ),
  );
}
}