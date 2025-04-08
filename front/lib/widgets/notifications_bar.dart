import 'package:flutter/material.dart';

class NotificationsBar extends StatelessWidget {
  final String notificationMsg;
  const NotificationsBar({super.key, required this.notificationMsg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              notificationMsg,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
