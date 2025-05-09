import 'package:flutter/material.dart';

class PlanActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const PlanActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  State<PlanActionButton> createState() => _PlanActionButtonState();
}

class _PlanActionButtonState extends State<PlanActionButton> {
  double _scale = 1.0;

  void _handleTap() {
    setState(() => _scale = 0.9);
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() => _scale = 1.0);
      if (widget.onTap != null) widget.onTap!();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: _scale),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return GestureDetector(
          onTap: _handleTap,
          child: Transform.scale(
            scale: value,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    widget.icon,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.label,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
