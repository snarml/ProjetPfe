import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiseaseDetailPage extends StatelessWidget {
  final Map<String, String> diseaseData;

  const DiseaseDetailPage({super.key, required this.diseaseData});

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
                diseaseData['name']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              background: Hero(
                tag: diseaseData['name']!,
                child: Image.asset(
                  diseaseData['image']!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Color(int.parse(diseaseData['color']!)),
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
            backgroundColor: Color(int.parse(diseaseData['color']!)),
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
                  _buildSectionTitle('وصف المرض'),
                  const SizedBox(height: 8),
                  _buildSectionContent(diseaseData['description']!),
                  const SizedBox(height: 20),
                  
                  // Symptoms Section
                  _buildSectionTitle('الأعراض'),
                  const SizedBox(height: 8),
                  _buildSectionContent(diseaseData['symptoms']!),
                  const SizedBox(height: 20),
                  
                  // Treatment Section
                  _buildSectionTitle('العلاج'),
                  const SizedBox(height: 8),
                  _buildSectionContent(diseaseData['treatment']!),
                  const SizedBox(height: 20),
                  
                  // Prevention Section
                  _buildSectionTitle('الوقاية'),
                  const SizedBox(height: 8),
                  _buildSectionContent(diseaseData['prevention']!),
                  const SizedBox(height: 30),
                  
                  // Severity Indicator
                  _buildSectionTitle('مستوى الخطورة'),
                  const SizedBox(height: 8),
                  _buildSeverityIndicator(),
                  const SizedBox(height: 30),
                  
                  // Affected Plants
                  _buildSectionTitle('النباتات المعرضة'),
                  const SizedBox(height: 8),
                  _buildAffectedPlantsList(),
                  const SizedBox(height: 40),
                  
                  // Emergency Action Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Implement emergency action
                      },
                      icon: const Icon(Icons.warning_amber),
                      label: const Text('إجراءات طارئة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                        shadowColor: Colors.red.withOpacity(0.4),
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
        color: Colors.red,
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

  Widget _buildSeverityIndicator() {
    return Column(
      children: [
        LinearProgressIndicator(
          value: 0.7, // Adjust based on disease severity
          backgroundColor: Colors.grey[300],
          color: Colors.red,
          minHeight: 10,
          borderRadius: BorderRadius.circular(10),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('منخفض', style: TextStyle(color: Colors.grey)),
            Text('متوسط', style: TextStyle(color: Colors.grey)),
            Text('عالي', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildAffectedPlantsList() {
    const plants = [
      'الطماطم',
      'الباذنجان',
      'الفلفل',
      'الخيار',
      'الكوسا',
    ];
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: plants.map((plant) => Chip(
        label: Text(plant),
        backgroundColor: Colors.red[50],
        side: BorderSide(color: Colors.red[100]!),
      )).toList(),
    );
  }
}