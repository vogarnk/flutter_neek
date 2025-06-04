import 'package:flutter/material.dart';
import 'package:neek/shared/buttons/plan_action_button.dart';
import '../../modules/plans/plan_settings_screen.dart';
import '../../modules/beneficiaries/beneficiaries_screen.dart';
import '../../modules/plans/plan_quote_details_screen.dart';

class PlanActionsRow extends StatelessWidget {
  final Map<String, dynamic> user;
  final List<dynamic> beneficiarios;

  const PlanActionsRow({
    super.key,
    required this.user,
    required this.beneficiarios,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        PlanActionButton(
          icon: Icons.calculate,
          label: 'Cotización',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PlanQuoteDetailsScreen()),
            );
          },
        ),
        PlanActionButton(
          icon: Icons.settings,
          label: 'Ajustes',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PlanSettingsScreen()),
            );
          },
        ),
        PlanActionButton(
          icon: Icons.people,
          label: 'Beneficiarios',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BeneficiariesScreen(
                  user: user,
                  beneficiarios: beneficiarios,
                ),
              ),
            );
          },
        ),
        const PlanActionButton(icon: Icons.description, label: 'Legal'),
      ],
    );
  }
}
