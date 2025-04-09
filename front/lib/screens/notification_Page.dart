import 'package:flutter/material.dart';
import 'package:bitakati_app/widgets/notifications_bar.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Liste de notifications (tu peux les récupérer du backend après)
    final List<String> notifications = [
      'تنبيه : تقلبات جوية اليوم في قابس',
      'معلومة : كيفية رعاية الطماطم في الصيف',
      'خبر : فتح سوق جديد للفلاحة في صفاقس',
      'تحذير : مرض البياض الدقيقي في العنب منتشر هذه الفترة',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationsBar(notificationMsg: notifications[index]);
        },
      ),
    );
  }
}
