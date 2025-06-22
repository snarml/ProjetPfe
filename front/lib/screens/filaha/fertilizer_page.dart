// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'fertilizer_detail_page.dart';

class FertilizerPage extends StatelessWidget {
  FertilizerPage({super.key});

  final List<Map<String, String>> fertilizers = [
    {
      'name': 'سماد عضوي',
      'description': 'مفيد لتحسين جودة التربة و زيادة الإنتاجية.',
      'image': 'images/organic_fertilizer_thumb.png',
      'usage': 'يضاف إلى التربة قبل الزراعة أو خلالها. يمكن استخدامه بكميات كبيرة نسبياً.',
      'precautions': 'تأكد من جودة السماد العضوي لتجنب إدخال أمراض أو بذور حشائش ضارة.',
      'color': '0xFF8BC34A',
    },
    {
      'name': 'سماد كيماوي',
      'description': 'يستخدم لتسريع نمو النباتات و تقوية الجذور.',
      'image': 'images/chemical_fertilizer_thumb.png',
      'usage': 'يستخدم بكميات محددة حسب نوع النبات ومرحلة النمو. يجب قراءة التعليمات بعناية.',
      'precautions': 'قد يكون ضارًا إذا تم استخدامه بكميات زائدة أو بطريقة غير صحيحة. تجنب ملامسة الجلد والعينين.',
      'color': '0xFFFF9800',
    },
    {
      'name': 'سماد NPK',
      'description': 'سماد متوازن يحتوي على نيتروجين، فوسفور و بوتاسيوم.',
      'image': 'images/npk_fertilizer_thumb.png',
      'usage': 'يستخدم لتغذية النباتات في مختلف مراحل النمو. تختلف الجرعات حسب التركيبة واحتياجات النبات.',
      'precautions': 'يجب تخزينه في مكان بارد وجاف بعيدًا عن متناول الأطفال والحيوانات الأليفة.',
      'color': '0xFF2196F3',
    },
    {
      'name': 'سماد سائل',
      'description': 'امتصاص سريع وسهل التطبيق على الأوراق أو التربة.',
      'image': 'images/liquid_fertilizer.png',
      'usage': 'يخلط مع الماء ويطبق حسب التعليمات. مناسب للرش الورقي.',
      'precautions': 'استخدم الكمية الموصى بها فقط. تجنب الرش في الأيام الحارة.',
      'color': '0xFF9C27B0',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('الأسمدة الزراعية'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: AnimationLimiter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'اختر نوع السماد',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'اختر من بين مجموعة واسعة من الأسمدة المناسبة لنباتاتك',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: AnimationLimiter(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: fertilizers.length,
                      itemBuilder: (context, index) {
                        final fertilizer = fertilizers[index];
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: _buildFertilizerCard(fertilizer, context),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFertilizerCard(Map<String, String> fertilizer, BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => FertilizerDetailPage(fertilizerData: fertilizer),
            transition: Transition.cupertino,
            duration: const Duration(milliseconds: 600));
      },
      borderRadius: BorderRadius.circular(20),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: Colors.black.withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(int.parse(fertilizer['color']!)),
                Color(int.parse(fertilizer['color']!)).withOpacity(0.7),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.eco,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset(
                            fertilizer['image']!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.help_outline,
                                color: Colors.white,
                                size: 40,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      fertilizer['name']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      fertilizer['description']!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'المزيد',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}