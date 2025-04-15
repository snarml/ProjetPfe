
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.green), // Change the color of the icons
      title: Row(
        textDirection: TextDirection.rtl,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.green,
            radius: 16,// Profile icon size
            child: IconButton(
              onPressed: () {
                // Handle profile icon press
                // You can navigate to the profile page or perform any action here
                Get.toNamed ('/profile'); // Navigate to the profile page
              }, 
              icon: const Icon(Icons.person, color: Colors.white, size: 17), // Profile icon
            ),
          ),
          SizedBox(width: 10),//space between the profile icon and the text
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('! مرحبا  ', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
              Text( '! اكتشف وتعلم معنا', style: TextStyle(fontSize: 12, color: Colors.black)),
            ],
          ),
          const Spacer(),// this will push the icons to the right 
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                icon:  const Icon(Icons.shopping_cart),
                onPressed: () {
                  Get.toNamed ('/panier'); // Navigate to the panier page
                },
          ),
          SizedBox(width: 0),//space between the icon
                IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Get.toNamed ('/notification'); 
            },
          ),
           IconButton(
            icon: const Icon(Icons.message_sharp),
            onPressed: () {
              
              Get.toNamed ('/messagePage'); // Navigate to the message page
            },
          ),
              ],
            ),
          
          
          ],
    ),
    );
  }
}
