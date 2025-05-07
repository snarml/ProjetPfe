import 'package:flutter/material.dart';

class NotificationDetailPage extends StatelessWidget {
  final String message;

  const NotificationDetailPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الإشعار'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'محتوى الإشعار:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
              // Vous pouvez ajouter d'autres détails ici si nécessaire
            ],
          ),
        ),
      ),
    );
  }
}