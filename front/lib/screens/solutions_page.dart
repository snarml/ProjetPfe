import 'package:flutter/material.dart';
import 'package:bitakati_app/widgets/custom_appBar.dart';
import 'package:bitakati_app/widgets/navigation_bar.dart';

class SolutionsPage extends StatefulWidget {
  const SolutionsPage({super.key});

  @override
  State<SolutionsPage> createState() => _SolutionsPageState();
}

class _SolutionsPageState extends State<SolutionsPage> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppbar(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text( textDirection: TextDirection.rtl,
                "حلول لتطبيق الزراعة الجيدة",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              const SizedBox(height: 15),

              buildSolutionCard(
                title: "الزراعة المتكاملة",
                description: "تتمثل في زراعة المحاصيل بطرق تحسن التربة وتقلل من الآفات.",
                image: "images/integrated_farming.png",
              ),

              const SizedBox(height: 15),

              buildSolutionCard(
                title: "الممارسات المستدامة",
                description: "استخدام أساليب زراعية تحافظ على البيئة وتزيد الإنتاجية.",
                image: "images/sustainable_farming.png",
              ),

              const SizedBox(height: 15),

              buildSolutionCard(
                title: "الري الحديث",
                description: "تقنيات الري الحديثة مثل الري بالتنقيط لتحسين كفاءة المياه.",
                image: "images/modern_irrigation.png",
              ),

              const SizedBox(height: 15),

              buildSolutionCard(
                title: "التسميد العضوي",
                description: "استخدام المواد العضوية لتحسين جودة التربة وزيادة خصوبتها.",
                image: "images/organic_fertilization.png",
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navigationbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget buildSolutionCard({
    required String title,
    required String description,
    required String image,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Image.asset(image, width: 60, height: 60),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(description, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
