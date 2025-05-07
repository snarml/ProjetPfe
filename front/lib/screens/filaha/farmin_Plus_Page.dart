import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'fertilizer_page.dart'; // Page de liste des fertilisants

class FarmingPlusPage extends StatelessWidget {
  const FarmingPlusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: Text(
          'دليلك الموثوق عن الزراعة'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 65, 153, 70),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildFeatureButton(
            title: 'وقاية و أمراض النباتات'.tr,
            imagePath: 'front/images/diseases.png',
            onTap: () {
              Get.toNamed('/diseases');
            },
          ),
          const SizedBox(height: 12),
          _buildFeatureButton(
            title: 'قائمة المبيدات و استعمالاتها'.tr,
            imagePath: 'front/images/pesticides.png',
            onTap: () {
              Get.toNamed('/pesticides');
            },
          ),
          const SizedBox(height: 12),
          _buildFeatureButton(
            title: 'حلول لتطبيق جيد'.tr,
            imagePath: 'front/images/solutions.png',
            onTap: () {
              Get.toNamed('/solutions');
            },
          ),
          const SizedBox(height: 12),
          _buildFeatureButton(
            title: 'الأسمدة'.tr, // Catégorie pour les fertilisants
            imagePath: 'front/images/fertilizers.png',
            onTap: () {
                Get.to(() => FertilizerPage());             },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 4, color: Colors.black45, offset: Offset(1, 1))],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
