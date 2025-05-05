// ignore_for_file: file_names

import 'package:bitakati_app/screens/CartPage.dart';
import 'package:bitakati_app/screens/messageSearchScreen.dart';
import 'package:bitakati_app/screens/notification_Page.dart';
import 'package:bitakati_app/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  String fullName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('full_name') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize:  Size.fromHeight(100.h),
      child: 
    
    AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.green),
      title: Row(
        textDirection: TextDirection.rtl,
        children: <Widget>[
          // Profile icon
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: IconButton(
              onPressed: () {
                Get.to(() => const ProfilePage());
              },
              icon: const FaIcon(FontAwesomeIcons.userLarge, size: 17, color: Colors.green),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
             child : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '! مرحبا ${fullName.isNotEmpty ? fullName : ''}',
                style: const TextStyle(
                    fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const Text('! اكتشف وتعلم معنا',
                  style: TextStyle(fontSize: 12, color: Colors.black)),
            ],
          ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.cartShopping, size: 18),
                color: Colors.green,
                onPressed: () {
                  Get.to(() => const CartPage());
                },
              ),
              const SizedBox(width: 8),
              Stack(
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.solidBell, size: 18),
                    color: Colors.green,
                    onPressed: () {
                      Get.to(() => const NotificationPage());
                    },
                  ),
                ],
              ),
              const SizedBox(width: 5),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.solidCommentDots, size: 18),
                color: Colors.green,
                onPressed: () {
                  Get.to(() => const MessageSearchScreen());
                },
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}
