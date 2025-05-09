class _EditPlanNameModal extends StatelessWidget {
  const _EditPlanNameModal({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Padding(
      padding: MediaQuery.of(context).viewInsets, // para mover con el teclado
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header con cerrar
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Cambiar nombre del plan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Asigna un nombre a tu plan de ahorro y sigamos visionando un futuro.',
              style: TextStyle(fontSize: 14, color: AppColors.textGray500),
            ),
            const SizedBox(height: 16),
            // Tarjeta editable
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('neek', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Nombra tu plan de ahorro',
                      hintStyle: const TextStyle(color: Colors.white70),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'PLAN DE AHORRO + PROTECCIÓN',
                    style: TextStyle(fontSize: 10, color: Colors.white54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Recuerda nombrar tu plan de acuerdo a tu objetivo de ahorro o sobre las metas que deseas lograr. Una vez que cambies el nombre te notificaremos para confirmar.',
              style: TextStyle(fontSize: 13, color: AppColors.textGray500),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: acción guardar
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Guardar',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
