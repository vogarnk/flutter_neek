import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neek/core/theme/app_colors.dart';

class UdiPlanSummaryCard extends StatelessWidget {
  final Map<String, dynamic> planData;
  final bool extraSeleccionada;
  final int? coberturaDSeleccionada;
  final ValueChanged<bool>? onExtraChanged;
  final ValueChanged<int>? onCoberturaDChanged;

  const UdiPlanSummaryCard({
    Key? key,
    required this.planData,
    this.extraSeleccionada = false,
    this.coberturaDSeleccionada,
    this.onExtraChanged,
    this.onCoberturaDChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'es_MX', symbol: '\$');
    // Datos básicos del plan
    final int duracion = planData['duracion_plan'] as int;
    final double primaAnualPesos = double.tryParse(planData['prima_anual_pesos']) ?? 0;
    final double primaAnualUdis = double.tryParse(planData['prima_anual_udis']) ?? 0;
    final double udiRate = primaAnualUdis > 0 ? primaAnualPesos / primaAnualUdis : 0;

    // Protección de vida
    final double proteccionPesos = double.tryParse(planData['seguro_vida_proteccion']) ?? 0;
    final double proteccionUdis = udiRate > 0 ? proteccionPesos / udiRate : 0;

    // Cálculo de años de retiro
    final int currentYear = DateTime.now().year;
    final int targetYear = currentYear + duracion;
    final String? retiroTargetStr = planData['retira_$targetYear'];
    final String? retiro2050Str = planData['retira_2050'];

    double? retiroTarget = retiroTargetStr != null ? double.tryParse(retiroTargetStr) : null;
    double? retiro2050 = retiro2050Str != null ? double.tryParse(retiro2050Str) : null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          // Encabezado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF5FF),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Center(
              child: Text(
                'Ahorro + Protección ⭐️',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ),

          // Prima anual
          _udiRow(
            title: 'Prima Anual (Ahorro anual)',
            amountUdis: '${primaAnualUdis.toStringAsFixed(2)} UDIS',
            amountMxn: currencyFormat.format(primaAnualPesos),
            note: 'Proyección de UDI al día de hoy',
            isDarkBackground: true,
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // Suma Asegurada
          _udiRow(
            title: 'Suma Asegurada',
            subtitle: 'En caso de fallecimiento',
            amountUdis: currencyFormat.format(proteccionPesos),
            icon: Icons.shield_outlined,
            highlightSubtitle: true,
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // Retiro en año objetivo
          if (retiroTarget != null)
            _udiRow(
              title: 'Total a retirar en $targetYear',

              amountUdis: currencyFormat.format(retiroTarget), 
              isDarkBackground: true,
            ),
          if (retiroTarget != null)
            const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // Retiro en 2050 (siempre existe)
          if (retiro2050 != null)
            _udiRow(
              title: 'Total a retirar en 2050',
              amountUdis: currencyFormat.format(retiro2050),
            ),
          if (retiro2050 != null)
            const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // Beneficiarios y Coberturas (estáticos)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: CoberturasExpansion(
              onExtraChanged: onExtraChanged,
              onCoberturaDChanged: onCoberturaDChanged as CoberturaDCallback?,
              extraSeleccionada: extraSeleccionada,
              coberturaDSeleccionada: coberturaDSeleccionada,
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _infoBadgeRow(
            title: 'Beneficiarios',
            icon: Icons.groups_3_outlined,
            badgeText: '+3 Beneficiarios',
            note: 'Recomendado',
            isDarkBackground: true,
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
        ],
      ),
    );
  }

  Widget _udiRow({
    required String title,
    String? subtitle,
    String? amountUdis,
    String? amountMxn,
    String? note,
    IconData? icon,
    bool highlightSubtitle = false,
    bool isDarkBackground = false,
  }) {
    return Container(
      width: double.infinity,
      color: isDarkBackground ? AppColors.background50 : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111827),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 4),
              const Icon(Icons.info_outline, size: 14, color: Color(0xFF9CA3AF)),
            ],
          ),

          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: highlightSubtitle ? const Color(0xFF2563EB) : const Color(0xFF6B7280),
                  fontWeight: highlightSubtitle ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          if (amountUdis != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                amountUdis!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
                textAlign: TextAlign.center,
              ),
            ),

          if (amountMxn != null)
            const SizedBox(height: 4),

          if (amountMxn != null)
            Text(
              amountMxn!,
              style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
            ),

          if (note != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                note!,
                style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoBadgeRow({
    required String title,
    required IconData icon,
    required String badgeText,
    required String note,
    bool isDarkBackground = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: isDarkBackground ? AppColors.background50 : Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF6B7280))),
              const SizedBox(width: 4),
              const Icon(Icons.info_outline, size: 14, color: Color(0xFF9CA3AF)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: const Color(0xFF2563EB)),
                const SizedBox(width: 6),
                Text(badgeText, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(note, style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
        ],
      ),
    );
  }
}

typedef CoberturaExtraCallback = void Function(bool value);
typedef CoberturaDCallback = void Function(int? value);

class CoberturasExpansion extends StatefulWidget {
  final CoberturaExtraCallback? onExtraChanged;
  final CoberturaDCallback? onCoberturaDChanged;
  final bool extraSeleccionada;
  final int? coberturaDSeleccionada;

  const CoberturasExpansion({
    Key? key,
    this.onExtraChanged,
    this.onCoberturaDChanged,
    this.extraSeleccionada = false,
    this.coberturaDSeleccionada,
  }) : super(key: key);

  @override
  State<CoberturasExpansion> createState() => _CoberturasExpansionState();
}

class _CoberturasExpansionState extends State<CoberturasExpansion> {
  late bool extraSeleccionada;
  int? coberturaDSeleccionada;
  bool expanded = false;

  final List<Map<String, String>> coberturasIncluidas = [
    {
      'titulo': "Cobertura por Fallecimiento",
      'descripcion': "La cobertura básica del seguro de vida y ahorro pagará la suma asegurada a los beneficiarios designados en la póliza al ocurrir el fallecimiento del Asegurado.",
    },
    {
      'titulo': "Eliminación de aportaciones en caso de invalidez total y permanente (BIT)",
      'descripcion': "Si durante el plazo de seguro de esta cobertura el asegurado contratante sufre invalidez total y permanente, la compañía lo eximirá del pago de primas que correspondan al riesgo de su cobertura básica que venzan después de transcurrir el período de espera de 6 meses, cancelándose los beneficios adicionales que se tengan contratados.",
    },
    {
      'titulo': "Adelanto de Suma Asegurada al asegurado en caso de enfermedad terminal",
      'descripcion': "Se pagará el 25% de la suma asegurada correspondiente a la cobertura básica de la póliza, con un límite máximo de 500 SMGMVDF.",
    },
  ];

  final List<Map<String, String>> coberturasExtra = [
    {
      'titulo': "BIPA Pago de Suma Asegurada por Invalidez total y permanente",
      'descripcion': "Si durante el plazo de seguro de esta cobertura el asegurado sufre invalidez total y permanente, la compañía pagará al asegurado, en una sola exhibición, la suma asegurada contratada para este beneficio inmediatamente después de transcurrir el período de espera de 6 meses. La suma asegurada se pagará en una sola exhibición, después de haberse comprobado el estado de invalidez del Asegurado.",
    },
  ];

  final List<Map<String, String>> coberturasD = [
    {
      'titulo': "DI1 Doble indemnización por muerte accidental",
      'descripcion': "La Compañía pagará la suma asegurada contratada en esta cobertura, en caso de que el asegurado sufra un accidente durante la vigencia de la póliza, mismo que le causa la muerte.",
    },
    {
      'titulo': "DI2 Indemnización por muerte accidental ó pérdida de miembros.",
      'descripcion': "DI1 + Pago de suma asegurada por pérdida de miembros. Las lesiones se pagarán de acuerdo a la escala elegida (\"Escala A\" o \"Escala B\") conforme a lo indicado en la tabla de indemnización correspondiente.",
    },
    {
      'titulo': "DI3 Indemnización por muerte ó pérdida de miembros colectiva",
      'descripcion': "DI2 + Muerte colectiva. Solo se duplicará si el accidente que les dio origen ocurre: Mientras viaje como pasajero en cualquier vehículo público, con pago de pasaje, sobre una ruta establecida normalmente para ruta de pasajeros y sujeta a itinerarios regulares o mientras se encuentre en un ascensor que opere para servicio público.",
    },
  ];

  @override
  void initState() {
    super.initState();
    extraSeleccionada = widget.extraSeleccionada;
    coberturaDSeleccionada = widget.coberturaDSeleccionada;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.textWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        backgroundColor: AppColors.textWhite,
        collapsedBackgroundColor: AppColors.textWhite,
        initiallyExpanded: false,
        onExpansionChanged: (val) => setState(() => expanded = val),
        title: Row(
          children: [
            const Icon(Icons.shield_outlined, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              "Coberturas del plan",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 15,
              ),
            ),
            const Spacer(),
          ],
        ),
        children: [
          // Incluidas
          const Padding(
            padding: EdgeInsets.only(left: 8, top: 8, bottom: 4),
            child: Text("Incluidas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textGray900)),
          ),
          ...coberturasIncluidas.map((c) => _buildCoberturaCard(c['titulo']!, c['descripcion']!)),
          const Padding(
            padding: EdgeInsets.only(left: 8, top: 12, bottom: 4),
            child: Text("Extra", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textGray900)),
          ),
          ...coberturasExtra.asMap().entries.map((entry) => _buildCoberturaExtraCard(entry.key, entry.value)),
          const Padding(
            padding: EdgeInsets.only(left: 8, top: 12, bottom: 4),
            child: Text("Coberturas D", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textGray900)),
          ),
          ...coberturasD.asMap().entries.map((entry) => _buildCoberturaDCard(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildCoberturaCard(String titulo, String descripcion) => Card(
    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    elevation: 0,
    color: AppColors.background50,
    child: ListTile(
      leading: const Icon(Icons.info_outline, color: AppColors.primary),
      title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textGray900)),
      subtitle: Text(descripcion, style: const TextStyle(color: AppColors.textGray500)),
    ),
  );

  Widget _buildCoberturaExtraCard(int idx, Map<String, String> c) => Card(
    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    elevation: 0,
    color: AppColors.background50,
    child: SwitchListTile(
      value: extraSeleccionada,
      onChanged: (val) {
        setState(() => extraSeleccionada = val);
        if (widget.onExtraChanged != null) widget.onExtraChanged!(val);
      },
      title: Text(c['titulo']!, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textGray900)),
      subtitle: Text(c['descripcion']!, style: const TextStyle(color: AppColors.textGray500)),
      activeColor: AppColors.primary,
    ),
  );

  Widget _buildCoberturaDCard(int idx, Map<String, String> c) {
    final bool isSelected = coberturaDSeleccionada == idx;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 0,
      color: AppColors.background50,
      child: SwitchListTile(
        value: isSelected,
        onChanged: (val) {
          if (!isSelected && val) {
            // Cambiar la selección a este
            setState(() => coberturaDSeleccionada = idx);
            if (widget.onCoberturaDChanged != null) widget.onCoberturaDChanged!(idx);
          } else if (isSelected && !val) {
            // Permitir desactivar el que está activo
            setState(() => coberturaDSeleccionada = null);
            if (widget.onCoberturaDChanged != null) widget.onCoberturaDChanged!(null);
          }
        },
        title: Text(c['titulo']!, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textGray900)),
        subtitle: Text(c['descripcion']!, style: const TextStyle(color: AppColors.textGray500)),
        activeColor: AppColors.primary,
      ),
    );
  }
}