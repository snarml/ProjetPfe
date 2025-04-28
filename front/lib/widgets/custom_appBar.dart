// ignore_for_file: file_names

import 'package:bitakati_app/screens/CartPage.dart';
import 'package:bitakati_app/screens/messageSearchScreen.dart';
import 'package:bitakati_app/screens/notification_Page.dart';
import 'package:bitakati_app/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.green),
      title: Row(
        textDirection: TextDirection.rtl,
        children: <Widget>[
          // Profile icon with modern look
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
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('! مرحبا  ',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              Text('! اكتشف وتعلم معنا',
                  style: TextStyle(fontSize: 12, color: Colors.black)),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Modern shopping cart icon
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.cartShopping, size: 20),
                color: Colors.green,
                onPressed: () {
                  Get.to(() => const CartPage());
                },
              ),
              const SizedBox(width: 8),
              // Modern notification icon with badge potential
              Stack(
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.solidBell, size: 20),
                    color: Colors.green,
                    onPressed: () {
                      Get.to(() => const NotificationPage());
                    },
                  ),
                  // You can add a badge here if needed
                  // Positioned(
                  //   right: 8,
                  //   top: 8,
                  //   child: Container(
                  //     padding: const EdgeInsets.all(2),
                  //     decoration: BoxDecoration(
                  //       color: Colors.red,
                  //       borderRadius: BorderRadius.circular(6),
                  //     constraints: const BoxConstraints(
                  //       minWidth: 12,
                  //       minHeight: 12,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(width: 8),
              // Modern message icon
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.solidCommentDots, size: 20),
                color: Colors.green,
                onPressed: () {
                  Get.to(() => const MessageSearchScreen());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}