import 'package:flutter/material.dart';
import 'package:bitakati_app/widgets/custom_appBar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PesticidesPage extends StatefulWidget {
  const PesticidesPage({super.key});

  @override
  State<PesticidesPage> createState() => _PesticidesPageState();
}

class _PesticidesPageState extends State<PesticidesPage> {
  final List<Map<String, String>> pesticides = [
    {
      'name': 'مبيد حشري - آفات الحبوب',
      'description': 'يستخدم لمكافحة الحشرات التي تصيب المحاصيل.',
      'image': 'images/insecticide1.png',
      'type': 'حشري',
      'color': '0xFF4CAF50',
    },
    {
      'name': 'مبيد فطري - أمراض النبات',
      'description': 'يستخدم لمكافحة الفطريات المسببة للأمراض في النباتات.',
      'image': 'images/fungicide1.png',
      'type': 'فطري',
      'color': '0xFF2196F3',
    },
    {
      'name': 'مبيد مبيد حشري - آفات الخضروات',
      'description': 'يستعمل للحماية من الحشرات الضارة في الخضروات.',
      'image': 'images/insecticide2.png',
      'type': 'حشري',
      'color': '0xFF673AB7',
    },
    {
      'name': 'مبيد أعشاب ضارة',
      'description': 'يقضي على الأعشاب الضارة دون التأثير على المحاصيل.',
      'image': 'images/herbicide1.png',
      'type': 'أعشاب',
      'color': '0xFFF44336',
    },
    {
      'name': 'مبيد قوارض',
      'description': 'يستخدم للسيطرة على القوارض في المزارع والمخازن.',
      'image': 'images/rodenticide1.png',
      'type': 'قوارض',
      'color': '0xFFFF9800',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppbar(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "المبيدات واستخداماتها",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "اكتشف مجموعة واسعة من المبيدات الزراعية",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Search and Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'ابحث عن مبيد...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade800,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    onPressed: () {
                      // Show filter options
                    },
                  ),
                ),
              ],
            ),
          ),

          // Pesticides List
          Expanded(
            child: AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: pesticides.length,
                itemBuilder: (context, index) {
                  final pesticide = pesticides[index];
                  final color = Color(int.parse(pesticide['color']!));
                  
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _buildPesticideCard(
                          name: pesticide['name']!,
                          description: pesticide['description']!,
                          image: pesticide['image']!,
                          type: pesticide['type']!,
                          color: color,
                          onTap: () {
                            // Navigate to detail page
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPesticideCard({
    required String name,
    required String description,
    required String image,
    required String type,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Image with type badge
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      //image: DecorationImage(
                        //image: AssetImage(image),
                        //fit: BoxFit.contain,
                      //),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      type,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: color),
                        const SizedBox(width: 4),
                        Text(
                          'اضغط للمزيد',
                          style: TextStyle(
                            fontSize: 12,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}