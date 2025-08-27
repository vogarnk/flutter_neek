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
import '../../pdfx_viewer_screen.dart';

class PlanActionsRow extends StatelessWidget {
  final Map<String, dynamic> user;
  final List<dynamic> beneficiarios;
  final String status;
  final int? userPlanId;
  final String? polizaUrl;
  final Map<String, dynamic>? currentPlan;
  final List<dynamic>? cotizaciones;

  const PlanActionsRow({
    super.key,
    required this.user,
    required this.beneficiarios,
    required this.status,
    this.userPlanId,
    this.polizaUrl,
    this.currentPlan,
    this.cotizaciones,
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
                      if (polizaUrl != null && polizaUrl!.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PdfxViewerScreen(
                              title: 'Mi Póliza',
                              pdfUrl: polizaUrl!,
                            ),
                          ),
                        );
                      } else {
                        // Mostrar mensaje de que la póliza no está disponible
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('La póliza no está disponible en este momento'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    },
                  ),
                  PlanActionButton(
                    icon: Icons.credit_card,
                    label: 'Aportaciones',
                    onTap: () {
                      if (userPlanId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ContributionsScreen(userPlanId: userPlanId!)),
                        );
                      }
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
                            userPlanId: userPlanId,
                            currentPlan: currentPlan,
                            cotizaciones: cotizaciones,
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
            icon: Icons.policy,
            label: 'Ver mi póliza',
            onTap: () {
              if (polizaUrl != null && polizaUrl!.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PdfxViewerScreen(
                      title: 'Mi Póliza',
                      pdfUrl: polizaUrl!,
                    ),
                  ),
                );
              } else {
                // Mostrar mensaje de que la póliza no está disponible
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('La póliza no está disponible en este momento'),
                    backgroundColor: Colors.blue,
                  ),
                );
              }
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
                  userPlanId: userPlanId,
                  status: status,
                  currentPlan: currentPlan,
                  cotizaciones: cotizaciones,
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