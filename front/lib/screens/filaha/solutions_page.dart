import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'solutions_Detail_page.dart';

class SolutionsPage extends StatelessWidget {
  SolutionsPage({super.key});

  final List<Map<String, String>> solutions = [
    {
      'title': 'ترشيد استهلاك المياه',
      'description': 'تقنيات الري الذكية للحفاظ على الموارد المائية',
      'image': 'images/water_saving.png',
      'content': '''
1. استخدام أنظمة الري بالتنقيط
2. الري في الصباح الباكر أو المساء
3. مراقبة رطوبة التربة
4. جمع مياه الأمطار
5. استخدام نباتات تتحمل الجفاف''',
      'benefits': '''
- توفير يصل إلى 60% من المياه
- تحسين نمو النباتات
- تقليل تكاليف الري
- حماية الموارد المائية''',
      'color': '0xFF00BCD4',
    },
    {
      'title': 'تناوب المحاصيل',
      'description': 'تحسين خصوبة التربة والحد من الأمراض',
      'image': 'images/crop_rotation.png',
      'content': '''
1. تناوب محاصيل مختلفة كل موسم
2. زراعة البقوليات لتحسين النيتروجين
3. تجنب تكرار نفس المحصول سنوياً
4. تخطيط دورات لمدة 3-4 سنوات
5. دمج محاصيل تغطية التربة''',
      'benefits': '''
- تحسين خصوبة التربة
- تقليل الاعتماد على الأسمدة
- كسر دورة الآفات والأمراض
- زيادة الإنتاجية''',
      'color': '0xFF4CAF50',
    },
    {
      'title': 'الزراعة المصاحبة',
      'description': 'زراعة نباتات متوافقة لتعزيز النمو',
      'image': 'images/companion_planting.png',
      'content': '''
1. زراعة الطماطم مع الريحان
2. الجزر مع البصل
3. الذرة مع الفاصوليا
4. تجنب زراعة نباتات غير متوافقة
5. استخدام نباتات طاردة للحشرات''',
      'benefits': '''
- تحسين استخدام المساحة
- طرد الآفات بشكل طبيعي
- تحسين التلقيح
- زيادة التنوع البيولوجي''',
      'color': '0xFF8BC34A',
    },
    {
      'title': 'الزراعة بدون حرث',
      'description': 'حماية بنية التربة والحفاظ على رطوبتها',
      'image': 'images/no_till.png',
      'content': '''
1. الحد من اضطراب التربة
2. استخدام غطاء نباتي دائم
3. التحكم في الأعشاب بطرق طبيعية
4. استخدام معدات خاصة
5. التدرج في التطبيق''',
      'benefits': '''
- تحسين بنية التربة
- تقليل انجراف التربة
- الاحتفاظ بالرطوبة
- تخزين الكربون في التربة''',
      'color': '0xFF795548',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('حلول زراعية ذكية'),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
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
                  'ممارسات زراعية مستدامة',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'اكتشف أفضل الحلول لتحسين إنتاجيتك مع الحفاظ على البيئة',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: solutions.length,
                      itemBuilder: (context, index) {
                        final solution = solutions[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildSolutionCard(solution, context),
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
  Widget _buildSolutionCard(Map<String, String> solution, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Get.to(() => SolutionDetailPage(solutionData: solution),
              transition: Transition.cupertino,
              duration: const Duration(milliseconds: 600));
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(int.parse(solution['color']!)).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    solution['image']!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.eco,
                        color: Color(int.parse(solution['color']!)),
                        size: 40,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      solution['title']!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(int.parse(solution['color']!)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      solution['description']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber[400],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'ممارسة مستدامة',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}