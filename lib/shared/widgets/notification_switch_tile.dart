import 'package:flutter/material.dart';
import '../../core/notification_api_service.dart';

class NotificationSwitchTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final String fieldKey;
  final bool initialValue;

  const NotificationSwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.fieldKey,
    required this.initialValue,
  });

  @override
  State<NotificationSwitchTile> createState() => _NotificationSwitchTileState();
}

class _NotificationSwitchTileState extends State<NotificationSwitchTile> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _onChanged(bool val) async {
    setState(() => _value = val);
    final success = await NotificationApiService.instance.toggleNotification(widget.fieldKey, val);
    if (!success) {
      setState(() => _value = !val); // revertir
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo guardar "${widget.title}"')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        widget.title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color:Colors.black),
      ),
      subtitle: Text(widget.subtitle, style: const TextStyle(color: Colors.black54)),
      trailing: Switch(
        value: _value,
        onChanged: _onChanged,
        activeColor: Colors.white,
        activeTrackColor: const Color(0xFF2B5FF3),
      ),
    );
  }
}
