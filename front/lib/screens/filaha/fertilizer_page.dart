import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'fertilizer_detail_page.dart';

class FertilizerPage extends StatelessWidget {
  FertilizerPage({super.key}); // Retrait de 'const' ici

  final List<Map<String, String>> fertilizers = [
    {
      'name': 'سماد عضوي',
      'description': 'مفيد لتحسين جودة التربة و زيادة الإنتاجية.',
      'image': 'images/organic_fertilizer_thumb.png',
      'usage': 'يضاف إلى التربة قبل الزراعة أو خلالها. يمكن استخدامه بكميات كبيرة نسبياً.',
      'precautions': 'تأكد من جودة السماد العضوي لتجنب إدخال أمراض أو بذور حشائش ضارة.',
    },
    {
      'name': 'سماد كيماوي',
      'description': 'يستخدم لتسريع نمو النباتات و تقوية الجذور.',
      'image': 'images/chemical_fertilizer_thumb.png',
      'usage': 'يستخدم بكميات محددة حسب نوع النبات ومرحلة النمو. يجب قراءة التعليمات بعناية.',
      'precautions': 'قد يكون ضارًا إذا تم استخدامه بكميات زائدة أو بطريقة غير صحيحة. تجنب ملامسة الجلد والعينين.',
    },
    {
      'name': 'سماد NPK',
      'description': 'سماد متوازن يحتوي على نيتروجين، فوسفور و بوتاسيوم.',
      'image': 'images/npk_fertilizer_thumb.png',
      'usage': 'يستخدم لتغذية النباتات في مختلف مراحل النمو. تختلف الجرعات حسب التركيبة واحتياجات النبات.',
      'precautions': 'يجب تخزينه في مكان بارد وجاف بعيدًا عن متناول الأطفال والحيوانات الأليفة.',
    },
    // Ajoutez d'autres fertilisants ici
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة الأسمدة'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: fertilizers.length,
          itemBuilder: (context, index) {
            final fertilizer = fertilizers[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                onTap: () {
                  Get.to(() => FertilizerDetailPage(fertilizerData: fertilizer));
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            fertilizer['image']!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported, size: 60);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          fertilizer['name']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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