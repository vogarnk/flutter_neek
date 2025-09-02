import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neek/modules/agent/help_center_screen.dart';
import 'package:neek/modules/notifications/notifications_screen.dart';
import 'package:neek/modules/account/account_screen.dart';
import 'package:neek/modules/chat/chat_screen.dart';

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
            _AnimatedIconButton(
              icon: Icons.headphones,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HelpCenterScreen(),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            _AnimatedIconButton(
              icon: Icons.chat_bubble_outline,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChatScreen(),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            _AnimatedIconButton(
              icon: Icons.notifications_none,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            _AnimatedIconButton(
              icon: Icons.person_outline,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AccountScreen(user: user),
                  ),
                );
              },
            ),
          ],
        ),

      ],
    );
  }
}

class _AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _AnimatedIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<_AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<_AnimatedIconButton> {
  double _scale = 1.0;

  void _animateTap() {
    setState(() => _scale = 0.85);
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() => _scale = 1.0);
      widget.onPressed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 1.0, end: _scale),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: _animateTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0), // 👈 Más compacto
              child: Icon(widget.icon, color: Colors.white70),
            ),

          ),
        );
      },
    );
  }
}
