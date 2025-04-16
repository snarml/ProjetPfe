
import 'package:flutter/material.dart';
import 'package:bitakati_app/widgets/custom_appBar.dart';

class FertilizerPage extends StatefulWidget {
  const FertilizerPage({super.key});

  @override
  State<FertilizerPage> createState() => _FertilizerPageState();
}

class _FertilizerPageState extends State<FertilizerPage> {


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
              Text(
                textDirection: TextDirection.rtl,
                "أنواع الأسمدة",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              const SizedBox(height: 15),

              buildFertilizerCard(
                name: "سماد عضوي",
                description: "مفيد لتحسين جودة التربة و زيادة الإنتاجية.",
                image: "images/organic_fertilizer.png",
              ),

              const SizedBox(height: 15),

              buildFertilizerCard(
                name: "سماد كيماوي",
                description: "يستخدم لتسريع نمو النباتات و تقوية الجذور.",
                image: "images/chemical_fertilizer.png",
              ),

              const SizedBox(height: 15),

              buildFertilizerCard(
                name: "سماد NPK",
                description: "سماد متوازن يحتوي على نيتروجين، فوسفور و بوتاسيوم.",
                image: "images/npk_fertilizer.png",
              ),
            ],
          ),
        ),
      ),
    
    );
  }

  Widget buildFertilizerCard({
    required String name,
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
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(description, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
