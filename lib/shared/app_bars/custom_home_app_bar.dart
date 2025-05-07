import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neek/modules/agent/help_center_screen.dart';
import 'package:neek/modules/notifications/notifications_screen.dart';
import 'package:neek/modules/account/account_screen.dart';

class CustomHomeAppBar extends StatelessWidget {
  final Map<String, dynamic> user;

  const CustomHomeAppBar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(
          'assets/logo.svg',
          height: 25,
          fit: BoxFit.contain,
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HelpCenterScreen(),
                  ),
                );
              },
              child: const Icon(Icons.headphones, color: Colors.white70),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                );
              },
              child: const Icon(Icons.notifications_none, color: Colors.white70),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AccountScreen(user: user),
                  ),
                );
              },
              child: const Icon(Icons.person_outline, color: Colors.white70),
            ),
          ],
        ),
      ],
    );
  }
}
