// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Navigationbar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const Navigationbar({super.key, required this.onItemTapped, required this.selectedIndex});

  @override
  _NavigationbarState createState() => _NavigationbarState();
}

class _NavigationbarState extends State<Navigationbar> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690), minTextAdapt: true, splitScreenMode: true);
    return Container(
      decoration: BoxDecoration(
        color:  const Color.fromARGB(255, 212, 210, 210),
      
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 5.r,
            blurRadius: 7.r,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        
        
      ),
      child: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.h,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.shopping_cart, "متجر إلكتروني", 0),
              _buildNavItem(Icons.lightbulb, "فلاحة+", 1),
               //Espace pour l'icône centrale (Home)
              _buildNavItem(Icons.home, "الرئيسية", 4),
              _buildNavItem(Icons.handyman, "الخدمات", 2),
              _buildNavItem(Icons.person, "ملف شخصي", 3),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = widget.selectedIndex == index;
    return GestureDetector(
      onTap: () {
        widget.onItemTapped(index);
        setState(() {
          selectedIndex = index; // Update the selected index
        });
        // Navigation vers les pages correspondantes
      switch (index) {
        case 0:
          Get.toNamed( '/store'); // Naviguer vers la page du magasin
          break;
        case 1:
          Get.toNamed( '/farmingPlus'); // Naviguer vers la page "فلاحة+"
          break;
        case 2:
          Get.toNamed('/services'); // Naviguer vers la page des services
          break;
        case 3:
            Get.toNamed ('/profile'); // Naviguer vers la page du profil
          break;
        default:
          break;
      }
        
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: isSelected ? Matrix4.translationValues(0, -5, 0) : Matrix4.translationValues(0, 0, 0), // Move the icon up when selected
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.green : Colors.black,
              size: isSelected ? 35 : 25,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.green : Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
