import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'diseases_Detail_Page.dart';

class DiseasesPage extends StatelessWidget {
  DiseasesPage({super.key});

  final List<Map<String, String>> diseases = [
    {
      'name': 'البياض الدقيقي',
      'description': 'فطر يظهر كطبقة بيضاء مسحوقية على الأوراق.',
      'image': 'images/powdery_mildew.png',
      'symptoms': 'بقع بيضاء مسحوقية، اصفرار الأوراق، تقزم النمو',
      'treatment': 'مبيدات فطرية، تحسين التهوية، تقليل الرطوبة',
      'prevention': 'زراعة أصناف مقاومة، تباعد النباتات، تجنب الري العلوي',
      'color': '0xFF9E9E9E',
    },
    {
      'name': 'الندوة المبكرة',
      'description': 'مرض فطري يسبب بقعاً بنية على الأوراق.',
      'image': 'images/early_blight.png',
      'symptoms': 'بقع بنية دائرية، اصفرار الأوراق، سقوط الأوراق المبكر',
      'treatment': 'إزالة الأجزاء المصابة، استخدام مبيدات فطرية نحاسية',
      'prevention': 'تدوير المحاصيل، تجنب رطوبة الأوراق المطولة',
      'color': '0xFF795548',
    },
    {
      'name': 'عفن الجذور',
      'description': 'تعفن نظام الجذر بسبب الفطريات أو الإفراط في الري.',
      'image': 'images/root_rot.png',
      'symptoms': 'ذبول النبات، اصفرار الأوراق، جذور بنية لينة',
      'treatment': 'تقليل الري، استخدام مبيدات فطرية، إزالة النباتات المصابة',
      'prevention': 'تصريف جيد للتربة، تجنب الإفراط في الري',
      'color': '0xFF8D6E63',
    },
    {
      'name': 'التبقع البكتيري',
      'description': 'مرض بكتيري يسبب بقعاً مائية على الأوراق.',
      'image': 'images/bacterial_spot.png',
      'symptoms': 'بقع مائية صغيرة، تحولها إلى بنية، تشقق الأوراق',
      'treatment': 'تقليم الأجزاء المصابة، مبيدات بكتيرية نحاسية',
      'prevention': 'استخدام بذور معالجة، تجنب العمل بالنباتات عند البلل',
      'color': '0xFF4CAF50',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('أمراض النباتات'),
        centerTitle: true,
        backgroundColor: Colors.red[700],
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
                  'تعرف على أمراض النباتات',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'اكتشف كيفية تشخيص وعلاج الأمراض الشائعة التي تصيب نباتاتك',
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
                      itemCount: diseases.length,
                      itemBuilder: (context, index) {
                        final disease = diseases[index];
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: _buildDiseaseCard(disease, context),
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
  Widget _buildDiseaseCard(Map<String, String> disease, BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => DiseaseDetailPage(diseaseData: disease),
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
                Color(int.parse(disease['color']!)),
                Color(int.parse(disease['color']!)).withOpacity(0.7),
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
                    Icons.health_and_safety,
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
                            disease['image']!,
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
                      disease['name']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      disease['description']!,
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
                            'التفاصيل',
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