import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neek/shared/common/gradient_circle_ring.dart';
import 'package:neek/core/theme/app_colors.dart';

class RegisterCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onTap;

  const RegisterCard({
    super.key,
    required this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Container(
        height: 220,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Información e input distribuidos verticalmente
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 🔥 Clave
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  SvgPicture.asset(
                    'assets/logo.svg',
                    height: 16,
                    fit: BoxFit.contain,
                  ),

                  // Input centrado
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      controller: controller,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Nombra tu plan de ahorro',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  // Texto inferior
                  const Text(
                    'AHORRO + PROTECCIÓN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Aro con blur detrás
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  const GradientCircleRing(size: 90, strokeWidth: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}