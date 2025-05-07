import 'package:flutter/material.dart';
import 'package:bitakati_app/widgets/custom_appBar.dart';

class PesticidesPage extends StatefulWidget {
  const PesticidesPage({super.key});

  @override
  State<PesticidesPage> createState() => _PesticidesPageState();
}

class _PesticidesPageState extends State<PesticidesPage> {

  
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
                "المبيدات واستخداماتها",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              const SizedBox(height: 15),

              buildPesticideCard(
                name: "مبيد حشري - آفات الحبوب",
                description: "يستخدم لمكافحة الحشرات التي تصيب المحاصيل.",
                image: "images/insecticide1.png",
              ),

              const SizedBox(height: 15),

              buildPesticideCard(
                name: "مبيد فطري - أمراض النبات",
                description: "يستخدم لمكافحة الفطريات المسببة للأمراض في النباتات.",
                image: "images/fungicide1.png",
              ),

              const SizedBox(height: 15),

              buildPesticideCard(
                name: "مبيد مبيد حشري - آفات الخضروات",
                description: "يستعمل للحماية من الحشرات الضارة في الخضروات.",
                image: "images/insecticide2.png",
              ),
            ],
          ),
        ),
      ),
      
    );
  }

  Widget buildPesticideCard({
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
