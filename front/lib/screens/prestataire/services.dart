import 'package:flutter/material.dart';
import 'service_providers_page.dart';

class Services extends StatelessWidget {
  const Services({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'خدمات الفلاحية',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildCategoryCard(
              context,
              'الإرشاد و الدراسات الفلاحية',
              Icons.agriculture,
              Colors.blue,
            ),
            _buildCategoryCard(
              context,
              'المخابر و التحاليل',
              Icons.science,
              Colors.orange,
            ),
            _buildCategoryCard(
              context,
              'التركيب و الصيانة',
              Icons.build,
              Colors.red,
            ),
            _buildCategoryCard(
              context,
              'الكراء و المعدات',
              Icons.construction,
              Colors.purple,
            ),
            _buildCategoryCard(
              context,
              'التوصيل',
              Icons.local_shipping,
              Colors.teal,
            ),
            _buildCategoryCard(
              context,
              'اليد العاملة الفلاحية',
              Icons.people,
              Colors.brown,
            ),
            _buildCategoryCard(
              context,
              'الطاقة، البيئة و الموارد المائية',
              Icons.water_drop,
              Colors.blueAccent,
            ),
            _buildCategoryCard(
              context,
              'الطب البيطري و تربية الحيوانات',
              Icons.pets,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, String title, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceProvidersPage(
                categoryName: title,
                categoryIcon: icon,
                categoryColor: color,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}