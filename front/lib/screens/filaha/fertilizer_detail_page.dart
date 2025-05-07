import 'package:flutter/material.dart';

class FertilizerDetailPage extends StatelessWidget {
  final Map<String, String> fertilizerData;

  const FertilizerDetailPage({super.key, required this.fertilizerData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fertilizerData['name'] ?? 'تفاصيل السماد'),
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
              Center(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset(
                    fertilizerData['image'] ?? 'images/placeholder.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, size: 80);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                fertilizerData['name'] ?? '',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text(
                'الوصف:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                fertilizerData['description'] ?? '',
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
              const Text(
                'طريقة الاستخدام:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                fertilizerData['usage'] ?? 'لم يتم توفير طريقة الاستخدام بعد.',
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
              const Text(
                'احتياطات الاستخدام:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                fertilizerData['precautions'] ?? 'لم يتم توفير احتياطات الاستخدام بعد.',
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}