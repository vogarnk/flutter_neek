import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/core/quote_service.dart';
import 'package:neek/modules/savings/widgets/simulation_plan_card.dart';

class PlanSelectionWidget extends StatefulWidget {
  final List<PlanOption> plans;
  final Function(PlanOption) onPlanSelected;

  const PlanSelectionWidget({
    super.key,
    required this.plans,
    required this.onPlanSelected,
  });

  @override
  State<PlanSelectionWidget> createState() => _PlanSelectionWidgetState();
}

class _PlanSelectionWidgetState extends State<PlanSelectionWidget> {
  PlanOption? selectedPlan;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Planes disponibles',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Desliza para ver todos los planes disponibles:',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textGray300,
          ),
        ),
        const SizedBox(height: 20),
        
        // PageView con los planes
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.plans.length,
            itemBuilder: (context, index) {
              final plan = widget.plans[index];
              final isSelected = selectedPlan?.id == plan.id;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SingleChildScrollView(
                  child: SimulationPlanCard(
                    plan: plan,
                    isSelected: isSelected,
                    onTap: () => setState(() => selectedPlan = plan),
                  ),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Indicador de páginas moderno
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.swipe_left_alt,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              SmoothPageIndicator(
                controller: _pageController,
                count: widget.plans.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 6,
                  dotWidth: 6,
                  spacing: 8,
                  expansionFactor: 3,
                  activeDotColor: Colors.white,
                  dotColor: Colors.white54,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.swipe_right_alt,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Botón de continuar
        if (selectedPlan != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onPlanSelected(selectedPlan!),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: const Text(
                'Continuar con este plan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

}
