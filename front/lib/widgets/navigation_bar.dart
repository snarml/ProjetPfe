import 'package:bitakati_app/controllers/NavigationController.dart';
import 'package:bitakati_app/screens/Home_page.dart';
import 'package:bitakati_app/screens/filaha/farmin_Plus_Page.dart';
import 'package:bitakati_app/screens/profile.dart';
import 'package:bitakati_app/screens/services.dart';
import 'package:bitakati_app/screens/storePage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Navigationbar extends StatefulWidget {
  final int selectedIndex;
  const Navigationbar({super.key, this.selectedIndex=0});

  @override
  State<Navigationbar> createState() => _NavigationbarState();
}

class _NavigationbarState extends State<Navigationbar> {
  @override
  Widget build(BuildContext context) {
    // Initialisation du controller
    final NavigationController navController = Get.put(NavigationController());

    final List<Widget> _pages = [
      HomePage(),
      Services(),
      StorePage(),
      FarmingPlusPage(),
      ProfilePage(),
    ];

    final List<Widget> _navigationItem = [
      const Icon(FontAwesomeIcons.house, size: 20),
      Stack(
        alignment: Alignment.center,
        children: [
          const Icon(FontAwesomeIcons.handHolding, size: 23),
          Positioned(
            top: 0,
            right: 0,
            child: const Icon(FontAwesomeIcons.gear, size: 13),
          ),
        ],
      ),
      const Icon(FontAwesomeIcons.store, size: 20),
      const Icon(FontAwesomeIcons.solidLightbulb, size: 20),
      const Icon(FontAwesomeIcons.solidUser, size: 20),
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: navController.currentIndex.value,
          children: _pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => CurvedNavigationBar(
          backgroundColor: Colors.white,
          color: Colors.green,
          items: _navigationItem,
          height: 60,
          animationDuration: const Duration(milliseconds: 300),
          index: navController.currentIndex.value,
          onTap: (index) {
            navController.changePage(index); 
          },
        ),
      ),
    );
  }
}
