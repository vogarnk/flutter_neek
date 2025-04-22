import 'package:flutter/material.dart';

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({super.key});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  String? _estadoCivil;
  bool _datosCorrectos = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: const Text('Datos personales'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Datos personales',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Nombre Completo',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 16),
              ),
              _buildTextField(
                '',
                initialValue: 'Andrea Mariana Marquez Monasteri',
                textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 12),

              Text(
                'Fecha de Nacimiento',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 16),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      '',
                      hint: 'DD',
                      hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField(
                      '',
                      hint: 'MM',
                      hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField(
                      '',
                      hint: 'YYYY',
                      hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              _buildDropdown('Lugar de Nacimiento', ['Estado 1', 'Estado 2']),
              const SizedBox(height: 12),

              _buildTextField('CURP', initialValue: 'AAAD990512MSLCHCL02'),
              const SizedBox(height: 12),

              _buildTextField('RFC', initialValue: 'AAAD990512HZ1'),
              const SizedBox(height: 12),

              _buildTextField('Numero de celular', initialValue: '6672309497'),
              const SizedBox(height: 12),

              _buildTextField('Correo', initialValue: 'andymonar@gmail.com'),
              const SizedBox(height: 12),

              CheckboxListTile(
                value: _datosCorrectos,
                onChanged: (value) {
                  setState(() => _datosCorrectos = value!);
                },
                activeColor: Colors.black,
                title: const Text('Mis datos personales son correctos'),
                subtitle: const Text(
                  'Mis datos personales coinciden con mis datos proporcionados anteriormente',
                  style: TextStyle(fontSize: 12),
                ),
              ),

              const Divider(height: 32),
              const Text('Estado civil', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              _buildRadioOption('Soltero'),
              _buildRadioOption('Casado(a)'),
              _buildRadioOption('Divorciado(a)'),
              _buildRadioOption('Viudo(a)'),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  // Acción de continuar
                },
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                child: const Center(child: Text('Continuar')),
              ),
              const SizedBox(height: 16),

              OutlinedButton(
                onPressed: () {
                  // Acción de guardar para después
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Guardar y Continuar más tarde'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    String? hint,
    String? initialValue,
    TextStyle? hintStyle,
    TextStyle? textStyle, // 👈 nuevo parámetro
    BuildContext? context,
  }) {
    final textTheme = context != null ? Theme.of(context).textTheme : null;

    return Builder(
      builder: (ctx) {
        final localTextTheme = textTheme ?? Theme.of(ctx).textTheme;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label.isNotEmpty)
              Text(
                label,
                style: localTextTheme.displaySmall?.copyWith(fontSize: 16),
              ),
            const SizedBox(height: 4),
            TextFormField(
              initialValue: initialValue,
              style: textStyle ?? localTextTheme.bodySmall?.copyWith(fontSize: 16), // 👈 aquí se usa
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: hintStyle ?? localTextTheme.bodySmall?.copyWith(fontSize: 16),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDropdown(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (_) {},
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption(String value) {
    return RadioListTile<String>(
      title: Text(value),
      value: value,
      groupValue: _estadoCivil,
      onChanged: (val) => setState(() => _estadoCivil = val),
      activeColor: Colors.black,
    );
  }
}