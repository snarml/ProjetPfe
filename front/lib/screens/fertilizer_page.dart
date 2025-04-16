import 'package:flutter/material.dart';


class FertilizerPage extends StatelessWidget {
  const FertilizerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("أنواع الأسمدة"),
        backgroundColor: Colors.green[700],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildFertilizerCard(
              context,
              name: "سماد عضوي",
              description: "مفيد لتحسين جودة التربة و زيادة الإنتاجية.",
              image: "images/organic_fertilizer.png",
            ),
            buildFertilizerCard(
              context,
              name: "سماد كيماوي",
              description: "يستخدم لتسريع نمو النباتات و تقوية الجذور.",
              image: "images/chemical_fertilizer.png",
            ),
            buildFertilizerCard(
              context,
              name: "سماد NPK",
              description: "سماد متوازن يحتوي على نيتروجين، فوسفور و بوتاسيوم.",
              image: "images/npk_fertilizer.png",
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFertilizerCard(BuildContext context,
      {required String name, required String description, required String image}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Image.asset(image, width: 60, height: 60),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(description, style: const TextStyle(fontSize: 14)),
       /* onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FertilizerDetailPage(
                name: name,
                description: description,
                image: image,
              ),
            ),
          );
       */ 
      //},
      ),
    );
  }
}
