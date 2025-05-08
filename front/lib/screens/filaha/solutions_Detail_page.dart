import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SolutionDetailPage extends StatelessWidget {
  final Map<String, String> solutionData;

  const SolutionDetailPage({super.key, required this.solutionData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                solutionData['title']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              background: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2),
                  BlendMode.darken,
                ),
                child: Image.asset(
                  solutionData['image']!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Color(int.parse(solutionData['color']!)),
                      child: const Center(
                        child: Icon(
                          Icons.eco,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            backgroundColor: Color(int.parse(solutionData['color']!)),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {
                  // Implement bookmark functionality
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  _buildSectionTitle('الوصف'),
                  const SizedBox(height: 8),
                  Text(
                    solutionData['description']!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Implementation Steps
                  _buildSectionTitle('خطوات التطبيق'),
                  const SizedBox(height: 8),
                  _buildNumberedList(solutionData['content']!),
                  const SizedBox(height: 20),
                  
                  // Benefits
                  _buildSectionTitle('الفوائد'),
                  const SizedBox(height: 8),
                  _buildBulletList(solutionData['benefits']!),
                  const SizedBox(height: 20),
                  
                  // Case Study
                  _buildSectionTitle('دراسة حالة'),
                  const SizedBox(height: 8),
                  _buildCaseStudy(),
                  const SizedBox(height: 30),
                  
                  // Implementation Tips
                  _buildSectionTitle('نصائح للتطبيق'),
                  const SizedBox(height: 8),
                  _buildTips(),
                  const SizedBox(height: 40),
                  
                  // Action Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(int.parse(solutionData['color']!)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                        shadowColor: Color(int.parse(solutionData['color']!))
                            .withOpacity(0.4),
                      ),
                      child: const Text(
                        'بدء التطبيق',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(int.parse(solutionData['color']!)),
      ),
    );
  }

  Widget _buildNumberedList(String content) {
    final items = content.split('\n').where((item) => item.isNotEmpty).toList();
    
    return Column(
      children: List.generate(items.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Color(int.parse(solutionData['color']!)).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: Color(int.parse(solutionData['color']!)),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  items[index],
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBulletList(String content) {
    final items = content.split('\n').where((item) => item.isNotEmpty).toList();
    
    return Column(
      children: List.generate(items.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle,
                color: Color(int.parse(solutionData['color']!)),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  items[index],
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCaseStudy() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.teal[100]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: Colors.teal[700],
              ),
              const SizedBox(width: 8),
              Text(
                'تجربة ناجحة',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'مزارع في منطقة الرياض حقق زيادة في الإنتاج بنسبة 40% بعد تطبيق هذه الممارسة لمدة موسمين، مع توفير 35% من استهلاك المياه.',
            style: TextStyle(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTips() {
    final tips = [
      'ابدأ بتجربة على مساحة صغيرة أولاً',
      'سجل النتائج والمشكلات التي تواجهها',
      'استشر المختصين عند الحاجة',
      'تأقلم الحل مع ظروف مزرعتك الخاصة',
      'شارك تجربتك مع المزارعين الآخرين',
    ];
    
    return Column(
      children: tips.map((tip) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: Colors.amber[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                tip,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[800],
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }
}