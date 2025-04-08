// ignore_for_file: file_names

import 'package:bitakati_app/widgets/build_post_card.dart';
import 'package:bitakati_app/widgets/chatbotmsg.dart';
import 'package:bitakati_app/widgets/custom_appBar.dart';
import 'package:bitakati_app/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:bitakati_app/widgets/navigation_bar.dart';
import 'package:bitakati_app/widgets/notifications_bar.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppbar(),
            Searchbar(),
            Chatbotmsg(),
            // Prmière carte (Produit agricole )
            BuildPostCard(
              profileImage: Icon( Icons.person, color: Colors.green),
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

            NotificationsBar(notificationMsg: 'مرحبا بك! هل ترغب في رؤية تنبيهات جديدة؟'),

            const SizedBox(height: 10),
            // Deuxième carte (Produit agricole)
            BuildPostCard(
              profileImage: Icon( Icons.person, color: Colors.green,size: 10),
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
      bottomNavigationBar: Navigationbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      );
  }

}
