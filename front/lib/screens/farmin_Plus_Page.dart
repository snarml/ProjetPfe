import 'package:flutter/material.dart';
import 'fertilizer_page.dart'; // Import nécessaire

class FarmingPlusPage extends StatelessWidget {
  const FarmingPlusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: const Text(
          'دليلك الموثوق عن الزراعة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 65, 153, 70),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.green[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'دليلك الموثوق عن الزراعة',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Image.asset('images/farmer.png', width: 60),
                  ],
                ),
              ),
              _buildFeatureButton(
                context,
                title: 'وقاية و أمراض النباتات',
                imagePath: 'images/diseases.png',
                onTap: () => Navigator.pushNamed(context, '/diseases'),
              ),
              const SizedBox(height: 16),
              _buildFeatureButton(
                context,
                title: 'قائمة المبيدات و استعمالاتها',
                imagePath: 'images/pesticides.png',
                onTap: () => Navigator.pushNamed(context, '/pesticides'),
              ),
              const SizedBox(height: 16),
              _buildFeatureButton(
                context,
                title: 'حلول لتطبيق جيد',
                imagePath: 'images/solutions.png',
                onTap: () => Navigator.pushNamed(context, '/solutions'),
              ),
              const SizedBox(height: 16),
              _buildFeatureButton(
                context,
                title: 'الأسمدة حسب التربة',
                imagePath: 'images/fertilizers.png',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FertilizerPage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureButton(
    BuildContext context, {
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
