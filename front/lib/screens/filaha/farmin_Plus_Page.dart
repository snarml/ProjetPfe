import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'fertilizer_page.dart';

class FarmingPlusPage extends StatelessWidget {
  const FarmingPlusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'دليلك الموثوق عن الزراعة'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF2E7D32),
                const Color(0xFF43A047),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'ابحث عن معلومات زراعية...'.tr,
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Categories Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.9,
                children: [
                  _buildCategoryCard(
                    title: 'وقاية و أمراض النباتات'.tr,
                    icon: Icons.health_and_safety,
                    color: const Color(0xFFE53935),
                    image: 'front\images\diseases.png', // Chemin corrigé
                    onTap: () => Get.toNamed('/diseases'),
                  ),
                  _buildCategoryCard(
                    title: 'قائمة المبيدات و استعمالاتها'.tr,
                    icon: Icons.bug_report,
                    color: const Color(0xFF3949AB),
                    image: 'front\images\pesticides.png', // Chemin corrigé
                    onTap: () => Get.toNamed('/pesticides'),
                  ),
                  _buildCategoryCard(
                    title: 'حلول لتطبيق جيد'.tr,
                    icon: Icons.lightbulb,
                    color: const Color(0xFFFB8C00),
                    image: 'front\images\solutions.png', // Chemin corrigé
                    onTap: () => Get.toNamed('/solutions'),
                  ),
                  _buildCategoryCard(
                    title: 'الأسمدة'.tr,
                    icon: Icons.grass,
                    color: const Color(0xFF43A047),
                    image: 'front\images\fertilizers.jpeg', // Chemin corrigé
                    onTap: () => Get.to(() => FertilizerPage()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required IconData icon,
    required Color color,
    required String image,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.9),
              color.withOpacity(0.7),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background Image with overlay
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2),
                  BlendMode.darken,
                ),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: color.withOpacity(0.7),
                      child: Center(
                        child: Icon(
                          icon,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}