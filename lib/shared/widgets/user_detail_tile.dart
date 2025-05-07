import 'package:flutter/material.dart';

class UserDetailTile extends StatelessWidget {
  final String label;
  final String value;
  final bool showIcon;

  const UserDetailTile({
    super.key,
    required this.label,
    required this.value,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 6,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(value, style: const TextStyle(fontSize: 14)),
                if (showIcon)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(Icons.verified, size: 16, color: Colors.blue),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}