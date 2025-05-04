import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'notification_detail_page.dart'; // Import de la page de détails

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Liste de notifications (à remplacer par vos données réelles)
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
        backgroundColor: Colors.green[700],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: InkWell(
                onTap: () {
                  Get.to(() => NotificationDetailPage(message: notifications[index]));
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    notifications[index],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}