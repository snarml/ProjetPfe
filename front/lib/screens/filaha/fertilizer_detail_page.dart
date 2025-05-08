import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FertilizerDetailPage extends StatelessWidget {
  final Map<String, String> fertilizerData;

  const FertilizerDetailPage({super.key, required this.fertilizerData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                fertilizerData['name']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              background: Hero(
                tag: fertilizerData['name']!,
                child: Image.asset(
                  fertilizerData['image']!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Color(int.parse(fertilizerData['color']!)),
                      child: const Center(
                        child: Icon(
                          Icons.help_outline,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            backgroundColor: Color(int.parse(fertilizerData['color']!)),
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
                icon: const Icon(Icons.share),
                onPressed: () {
                  // Implement share functionality
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
                  // Description Section
                  _buildSectionTitle('وصف السماد'),
                  const SizedBox(height: 8),
                  _buildSectionContent(fertilizerData['description']!),
                  const SizedBox(height: 20),
                  
                  // Usage Section
                  _buildSectionTitle('طريقة الاستخدام'),
                  const SizedBox(height: 8),
                  _buildSectionContent(fertilizerData['usage']!),
                  const SizedBox(height: 20),
                  
                  // Precautions Section
                  _buildSectionTitle('احتياطات الاستخدام'),
                  const SizedBox(height: 8),
                  _buildSectionContent(fertilizerData['precautions']!),
                  const SizedBox(height: 30),
                  
                  // Benefits Section
                  _buildSectionTitle('فوائد السماد'),
                  const SizedBox(height: 8),
                  _buildBenefitsList(),
                  const SizedBox(height: 30),
                  
                  // Application Tips
                  _buildSectionTitle('نصائح للتطبيق'),
                  const SizedBox(height: 8),
                  _buildTipsList(),
                  const SizedBox(height: 40),
                  
                  // Action Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(int.parse(fertilizerData['color']!)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                        shadowColor: Color(int.parse(fertilizerData['color']!))
                            .withOpacity(0.4),
                      ),
                      child: const Text(
                        'شراء الآن',
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
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[800],
        height: 1.5,
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildBenefitsList() {
    const benefits = [
      'تحسين جودة التربة',
      'زيادة إنتاجية المحاصيل',
      'تعزيز نمو الجذور',
      'تحسين مقاومة النبات للأمراض',
      'تحسين جودة الثمار',
    ];
    
    return Column(
      children: benefits.map((benefit) => _buildListTile(benefit)).toList(),
    );
  }

  Widget _buildTipsList() {
    const tips = [
      'يفضل التسميد في الصباح الباكر أو المساء',
      'تجنب التسميد أثناء فترات الحر الشديد',
      'احرص على توزيع السماد بالتساوي',
      'ري النبات بعد التسميد مباشرة',
    ];
    
    return Column(
      children: tips.map((tip) => _buildListTile(tip)).toList(),
    );
  }

  Widget _buildListTile(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Icon(
              Icons.check_circle,
              color: Color(int.parse(fertilizerData['color']!)),
              size: 18,
            ),
          ),
          Expanded(
            child: Text(
              text,
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
  }
}