import 'package:flutter/material.dart';
import 'package:neek/shared/buttons/plan_action_button.dart';
import '../../modules/plans/plan_settings_screen.dart';
import '../../modules/beneficiaries/beneficiaries_screen.dart';
import '../../modules/beneficiaries/confirmed_beneficiaries_screen.dart'; // <-- Nuevo import
import '../../modules/plans/plan_quote_details_screen.dart';
import '../../modules/legal/legal_screen.dart';
import '../../modules/plans/contributions_screen.dart';
import '../../modules/plans/movements_screen.dart';
import '../../modules/plans/stats/stats_screen.dart';

class PlanActionsRow extends StatelessWidget {
  final Map<String, dynamic> user;
  final List<dynamic> beneficiarios;
  final String status;

  const PlanActionsRow({
    super.key,
    required this.user,
    required this.beneficiarios,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    if (status == 'autorizado') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  PlanActionButton(
                    icon: Icons.policy,
                    label: 'Póliza',
                    onTap: () {
                      Navigator.pushNamed(context, '/mi-poliza');
                    },
                  ),
                  PlanActionButton(
                    icon: Icons.credit_card,
                    label: 'Aportaciones',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ContributionsScreen()),
                      );
                    },
                  ),
                  PlanActionButton(
                    icon: Icons.account_balance_wallet,
                    label: 'Movimientos',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MovementsScreen()),
                      );
                    },
                  ),
                  PlanActionButton(
                    icon: Icons.show_chart,
                    label: 'Stats',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const StatsScreen()),
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
                          builder: (_) => ConfirmedBeneficiariesScreen(
                            user: user,
                            beneficiarios: beneficiarios,
                          ),
                        ),
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
                    icon: Icons.picture_as_pdf,
                    label: 'Estados',
                    onTap: () {
                      Navigator.pushNamed(context, '/estados');
                    },
                  ),
                  PlanActionButton(
                    icon: Icons.balance,
                    label: 'Legal',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LegalScreen()),
                      );
                    },
                  ),
                ].map((e) => Padding(padding: const EdgeInsets.only(right: 12), child: e)).toList(),
              ),
            ),
          ),
        ],
      );
    }

    // Otros estados
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (status == 'cotizado') ...[
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
        ] else if (status == 'autorizado_por_pagar_1') ...[
          PlanActionButton(
            icon: Icons.lock,
            label: 'Póliza',
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Plan inactivo'),
                  content: const Text('Este plan aún no ha sido activado.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Entendido'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
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
        PlanActionButton(
          icon: Icons.description,
          label: 'Legal',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LegalScreen()),
            );
          },
        ),
      ],
    );
  }
}