import 'package:flutter/material.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/models/savings_models.dart';

class EducationCard extends StatefulWidget {
  final Function({
    required int age,
    required double monthlySavings,
    required int yearsToUniversity,
  }) onSimulate;
  final VoidCallback onBack;
  final int? initialAge;
  final double? initialMonthlySavings;
  final int? initialYearsToUniversity;

  const EducationCard({
    super.key,
    required this.onSimulate,
    required this.onBack,
    this.initialAge,
    this.initialMonthlySavings,
    this.initialYearsToUniversity,
  });

  @override
  State<EducationCard> createState() => _EducationCardState();
}

class _EducationCardState extends State<EducationCard> {
  int _age = 25;
  double _monthlySavings = 2500;
  int _yearsToUniversity = 10;

  @override
  void initState() {
    super.initState();
    // Usar valores iniciales si están disponibles
    if (widget.initialAge != null) _age = widget.initialAge!;
    if (widget.initialMonthlySavings != null) _monthlySavings = widget.initialMonthlySavings!;
    if (widget.initialYearsToUniversity != null) _yearsToUniversity = widget.initialYearsToUniversity!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              IconButton(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back, color: AppColors.textGray900),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Educación',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textGray900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Ahorra para la educación universitaria',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textGray500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Campo de edad
          _buildField(
            label: 'Edad',
            value: '$_age años',
            onTap: () => _showAgeSelector(),
          ),
          const SizedBox(height: 24),

          // Campo de años hasta universidad
          _buildField(
            label: 'Años hasta Universidad',
            value: '$_yearsToUniversity años',
            onTap: () => _showYearsToUniversitySelector(),
          ),
          const SizedBox(height: 24),

          // Campo de ahorro mensual
          _buildField(
            label: 'Ahorro Mensual',
            value: '\$${_monthlySavings.toStringAsFixed(0)}',
            onTap: () => _showMonthlySavingsSelector(),
          ),
          const SizedBox(height: 32),

          // Botón de simular
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onSimulate(
                age: _age,
                monthlySavings: _monthlySavings,
                yearsToUniversity: _yearsToUniversity,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: const Text(
                'Generar Simulación',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.textGray300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textGray900,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textGray900,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textGray500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAgeSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildSelector(
        title: 'Selecciona tu edad',
        items: SavingsConstants.ages,
        currentValue: _age,
        onSelected: (value) => setState(() => _age = value),
        formatter: (value) => '$value años',
      ),
    );
  }

  void _showYearsToUniversitySelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildSelector(
        title: 'Selecciona los años hasta la universidad',
        items: SavingsConstants.yearsToUniversity,
        currentValue: _yearsToUniversity,
        onSelected: (value) => setState(() => _yearsToUniversity = value),
        formatter: (value) => '$value años',
      ),
    );
  }

  void _showMonthlySavingsSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildSelector(
        title: 'Selecciona el ahorro mensual',
        items: SavingsConstants.monthlySavingsOptions,
        currentValue: _monthlySavings,
        onSelected: (value) => setState(() => _monthlySavings = value),
        formatter: (value) => '\$${value.toStringAsFixed(0)}',
      ),
    );
  }

  Widget _buildSelector<T>({
    required String title,
    required List<T> items,
    required T currentValue,
    required Function(T) onSelected,
    required String Function(T) formatter,
  }) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = item == currentValue;
                
                return ListTile(
                  title: Text(
                    formatter(item),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? AppColors.primary : Colors.white,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    onSelected(item);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
