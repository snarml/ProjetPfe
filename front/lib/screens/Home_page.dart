// ignore_for_file: file_names

import 'package:bitakati_app/screens/Dashboard.dart';
import 'package:bitakati_app/widgets/build_post_card.dart';
import 'package:bitakati_app/widgets/chatbotmsg.dart';
import 'package:bitakati_app/widgets/custom_appBar.dart';
import 'package:bitakati_app/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(),
      drawer: Drawer(
        child: NavBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Searchbar(),
            Chatbotmsg(),
            // Première carte (Produit agricole)
            BuildPostCard(
              profileImage: Icon(Icons.person, color: Colors.green),
              username: 'محمد',
              date: "الخميس 1000, 2024 مساءً",
              category: "قمح ",
              quality: "بجودة ممتازة  ",
              images: [
                'images/wheat1.png',
                'images/wheat2.png',
                'images/wheat3.png',
              ],
            ),
            const SizedBox(height: 10),
            // Deuxième carte (Produit agricole)
            BuildPostCard(
              profileImage: Icon(Icons.person, color: Colors.green, size: 10),
              username: 'سعيد',
              date: "الخميس 1000, 2024 مساءً",
              category: "جرار",
              quality: "المسافة: 35000\nالموقع: قابس، تونس\nالسنة: 2023",
              images: [
                'images/tractor1.png',
                'images/tractor2.png',
                'images/tractor3.png',
              ],
            ),
          ],
        ),
      ),
    );
  }
}
