import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality( // Le point clé pour RTL
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
                  'assets/images/avatar.png',
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
            leading: Icon(Icons.home, color: Colors.green),
            title: Text('الصفحة الرئيسية'),
            onTap: () {
              // Naviguer vers l'accueil
            },
          ),
          ListTile(
            leading:
            Icon(FontAwesomeIcons.store, color: Colors.green,size: 20),
            title: Text('المتجر الالكتروني'),
            onTap: () {
              // Naviguer vers les paramètres
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.green),
            title: Text('الملف الشخصي'),
            onTap: () {
              // Naviguer vers à propos
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_mail),
            title: Text('اتصل بنا'),
            onTap: () {
              // Naviguer vers contact
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
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
