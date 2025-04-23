import 'package:bitakati_app/routes/app_routes.dart';
import 'package:bitakati_app/services/authServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put(sharedPreferences);
  Get.put(ApiService());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690), // Taille de référence
      //Ajuste automatiquement la taille des textes.
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/welcome',
          getPages: AppRoutes.routes,
        );
      },
    );
  }
}

// Layout partagé pour toutes les pages
class SharedLayout extends StatelessWidget {
  final Widget child;

  const SharedLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Image de fond agricole (responsive)
            Image.asset(
              'images/sign_in.jpeg',
              height: 180.h, // Adaptatif
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            // Contenu spécifique à chaque page
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20.w), // Padding adaptatif
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
