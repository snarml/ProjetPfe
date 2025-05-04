import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // Le point clé pour RTL
      textDirection: TextDirection.rtl,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Oflutter.com'),
            accountEmail: Text('info@oflutter.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset(
                  'images/avatar.png',
                  fit: BoxFit.cover,
                  width: 90.0,
                  height: 90.0,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                image: AssetImage('images/navbar.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.house,
              color: Color(0xFF1B4D3E),
              size: 20,
            ),
            title: Text('الصفحة الرئيسية'),
            onTap: () {
              // Naviguer vers l'accueil
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.solidUser,
              color: Color(0xFF1B4D3E),
              size: 20,
            ),
            title: Text('الملف الشخصي'),
            onTap: () {
              // Naviguer vers à propos
              Get.toNamed('/profile');
            },
          ),
          ListTile(
            leading: Stack(
              alignment: Alignment.center,
              children: [
                Icon(FontAwesomeIcons.handHolding,
                    size: 20, color: Color(0xFF1B4D3E)),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(FontAwesomeIcons.gear,
                      size: 13, color: Color(0xFF1B4D3E)),
                ),
              ],
            ),
            title: Text(' الخدمات'),
            onTap: () {
              // Naviguer vers contact
              Get.toNamed('/services');
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.solidLightbulb,
              color: Color(0xFF1B4D3E),
              size: 20,
            ),
            title: Text('+ فلاحة'),
            onTap: () {
              // Naviguer vers les paramètres
              Get.toNamed('/farmingPlus');
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.store,
              color: Color(0xFF1B4D3E),
              size: 20,
            ),
            title: Text('المتجر الالكتروني'),
            onTap: () {
              // Naviguer vers les paramètres
              Get.toNamed('/store');
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.doorOpen,
              color: Color(0xFF1B4D3E),
              size: 20,
            ),
            title: Text('تسجيل الخروج'),
            onTap: () {
              // Action de déconnexion
            },
          ),
          const Divider(),
          ListTile(
            title: Text('الإصدار 1.0.0'),
            subtitle: Text('© 2023 اسم شركتك'),
            trailing: Icon(Icons.info_outline),
            onTap: () {
              // Afficher les infos version
            },
          ),
        ],
      ),
    );
  }
}
