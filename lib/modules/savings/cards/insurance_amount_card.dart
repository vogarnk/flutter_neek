import 'package:flutter/material.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/models/savings_models.dart';

class InsuranceAmountCard extends StatefulWidget {
  final Function({
    required int age,
    required double insuranceAmount,
  }) onSimulate;
  final VoidCallback onBack;

  const InsuranceAmountCard({
    super.key,
    required this.onSimulate,
    required this.onBack,
  });

  @override
  State<InsuranceAmountCard> createState() => _InsuranceAmountCardState();
}

class _InsuranceAmountCardState extends State<InsuranceAmountCard> {
  int _age = 25;
  double _insuranceAmount = 100000;
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.text = _insuranceAmount.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
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
                      'Suma Asegurada',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textGray900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Protege a tus beneficiarios',
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

          // Campo de suma asegurada
          _buildAmountField(),
          const SizedBox(height: 32),

          // Botón de simular
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _validateAndSimulate,
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

  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Suma Asegurada',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textGray900,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textGray900,
          ),
          decoration: InputDecoration(
            hintText: 'Ingresa la suma asegurada deseada',
            hintStyle: const TextStyle(
              color: AppColors.textGray500,
            ),
            prefixText: '\$ ',
            prefixStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textGray900,
            ),
            filled: true,
            fillColor: AppColors.background50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.textGray300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.textGray300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          onChanged: (value) {
            final amount = double.tryParse(value);
            if (amount != null) {
              setState(() => _insuranceAmount = amount);
            }
          },
        ),
        const SizedBox(height: 8),
        Text(
          'Mínimo: \$${SavingsConstants.minInsuranceAmount.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textGray500,
          ),
        ),
      ],
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

  void _validateAndSimulate() {
    if (_insuranceAmount < SavingsConstants.minInsuranceAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('La suma asegurada mínima es \$${SavingsConstants.minInsuranceAmount.toStringAsFixed(0)}'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onSimulate(
      age: _age,
      insuranceAmount: _insuranceAmount,
    );
  }
}
