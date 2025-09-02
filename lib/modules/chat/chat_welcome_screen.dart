import 'package:flutter/material.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/modules/chat/chat_screen.dart';

class ChatWelcomeScreen extends StatelessWidget {
  final Map<String, dynamic>? user;

  const ChatWelcomeScreen({super.key, this.user});

  String _firstName() {
    final name = user != null ? (user!['name']?.toString() ?? '') : '';
    if (name.isEmpty) return '';
    final parts = name.split(' ');
    return parts.isNotEmpty ? parts.first : name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
        title: const Text('Ayuda'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.contrastBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hola ${_firstName()}',
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '¿Cómo te podemos ayudar hoy?',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _NewMessageCard(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatScreen()),
              ),
            ),
            const SizedBox(height: 12),
            const _FaqCard(),
          ],
        ),
      ),
    );
  }
}

class _NewMessageCard extends StatelessWidget {
  final VoidCallback onTap;

  const _NewMessageCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: const [
            Icon(Icons.mode_comment_outlined, color: AppColors.textWhite),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Mensaje nuevo',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textWhite),
          ],
        ),
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.contrastBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Preguntas frecuentes',
            style: TextStyle(
              color: AppColors.textWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          _FaqExpandableTile(
            title: '¿Qué es Neek?',
            subtitle: 'Conoce qué es Neek y cómo puede ayudarte a ahorrar.',
            content:
                'Neek es una plataforma digital de ahorro y protección.\n\n'
                'Con Neek puedes crear metas de ahorro personalizadas, conocer el valor diario de las UDIs, '
                'cotizar un plan, proteger a tu familia con coberturas y gestionar tu seguro.\n\n'
                'Además, te ayudamos a tomar decisiones informadas con herramientas educativas y asesoría.',
          ),
          _FaqDivider(),
          _FaqExpandableTile(
            title: '¿Cómo funcionan los planes de ahorro?',
            subtitle: 'Aprende cómo funcionan y cómo puedes beneficiarte.',
            content:
                'Nuestros planes convierten tus aportaciones a UDIs para proteger tu ahorro de la inflación. '
                'Puedes definir metas, periodicidad y monto; dar seguimiento a tu progreso y ajustar tu plan '
                'cuando lo necesites.',
          ),
          _FaqDivider(),
          _FaqExpandableTile(
            title: 'Seguro de Vida',
            subtitle: 'Entiende qué cubre y cómo contratarlo.',
            content:
                'Incluye coberturas que protegen a tus beneficiarios en caso de fallecimiento. '
                'Puedes cotizar, revisar condiciones y contratar desde la app de forma segura.',
          ),
          _FaqDivider(),
          _FaqExpandableTile(
            title: 'Preguntas Frecuentes',
            subtitle: 'Consulta respuestas rápidas a dudas comunes.',
            content:
                'Resolvemos dudas sobre depósitos, pólizas, beneficiarios, y configuración de tu plan. '
                'Si necesitas más ayuda, inicia un "Mensaje nuevo" para hablar con nosotros.',
          ),
        ],
      ),
    );
  }
}

class _FaqExpandableTile extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String content;

  const _FaqExpandableTile({
    required this.title,
    this.subtitle,
    required this.content,
  });

  @override
  State<_FaqExpandableTile> createState() => _FaqExpandableTileState();
}

class _FaqExpandableTileState extends State<_FaqExpandableTile> {
  bool _expanded = false;

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: _toggle,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.help_outline, size: 20, color: Colors.white70),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle!,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.expand_more, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(32, 4, 8, 8),
            child: Text(
              widget.content,
              style: const TextStyle(color: Colors.white70, height: 1.45),
            ),
          ),
          crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}

class _FaqDivider extends StatelessWidget {
  const _FaqDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Divider(
        height: 1,
        color: AppColors.background.withOpacity(0.3),
      ),
    );
  }
}


