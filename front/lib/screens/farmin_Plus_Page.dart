import 'package:flutter/material.dart';

class FarmingPlusPage extends StatelessWidget {
  const FarmingPlusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('دليلك الموثوق عن الزراعة'),
        backgroundColor: Colors.green[700],
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildFeatureButton(
            context,
            title: 'وقاية و أمراض النباتات',
            imagePath: 'images/diseases.png',
            onTap: () {
              Navigator.pushNamed(context, '/diseases'); 
            },
          ),
          const SizedBox(height: 12),
          _buildFeatureButton(
            context,
            title: 'قائمة المبيدات و استعمالاتها',
            imagePath: 'images/pesticides.png',
            onTap: () {
              Navigator.pushNamed(context, '/pesticides'); 
            },
          ),
          const SizedBox(height: 12),
          _buildFeatureButton(
            context,
            title: 'حلول لتطبيق جيد',
            imagePath: 'images/solutions.png',
            onTap: () {
              Navigator.pushNamed(context, '/solutions'); 
            },
          ),
          const SizedBox(height: 12),
          _buildFeatureButton(
            context,
            title: 'الأسمدة حسب التربة',
            imagePath: 'images/fertilizers.png',
            onTap: () {
              Navigator.pushNamed(context, '/fertilizer'); 
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton(BuildContext context,
      {required String title,
      required String imagePath,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                  blurRadius: 4, color: Colors.black45, offset: Offset(1, 1))
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
