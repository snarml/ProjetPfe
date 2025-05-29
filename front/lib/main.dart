import 'package:bitakati_app/routes/app_routes.dart';
import 'package:bitakati_app/services/authServices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
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
      designSize: Size(360, 690),
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

class SharedLayout extends StatelessWidget {
  final Widget child;

  const SharedLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Directionality( // Forcer RTL
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Image.asset(
                'images/sign_in.jpeg',
                height: 180.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
