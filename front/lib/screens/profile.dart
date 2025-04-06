import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690), minTextAdapt: true, splitScreenMode: true);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'الملف الشخصي',
          style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 25.sp,
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 4,
        shadowColor: Colors.black.withAlpha(77), // Equivalent to withOpacity(0.3)
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            // Section profil utilisateur avec avatar animé
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(51), // Equivalent to withOpacity(0.2)
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 40.r,
                
              ),
            ),
            SizedBox(height: 10.h),
            // Nom utilisateur avec animation de texte
            AnimatedDefaultTextStyle(
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              duration: Duration(milliseconds: 500),
              child: Text('مرحبا user!'),
            ),
            SizedBox(height: 20.h),
            // Liste des paramètres avec animations et effets de survol
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Column(
                children: [
                  buildAnimatedCard(context, 'معطيات', false),
                  buildSubSettingsItem(context, 'تعديل معطيات الملف الشخصي'),
                  
                  buildAnimatedCard(context, 'إعدادات', false),
                  buildSubSettingsItem(context, 'إعدادات اللغة'),
                  buildSettingsToggleItem(context, 'إشعارات', notificationsEnabled),
                  
                  buildAnimatedCard(context, 'متابعة', false),
                  buildSubSettingsItem(context, 'متابعة عمليات البيع'),
                  buildSubSettingsItem(context, 'متابعة عمليات الشراء'),
                  
                  buildAnimatedCard(context, 'أنشطتي', false),
                  buildSubSettingsItem(context, 'سجل التفاعل مع المساعد الذكي'),
                  buildSubSettingsItem(context, 'قائمة الإعجاب'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour créer un élément de paramètre principal sous forme de carte avec animation
  Widget buildAnimatedCard(BuildContext context, String title, bool hasTrailing) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51), // Equivalent to withOpacity(0.2)
            blurRadius: 6,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 15.w),
        child: buildSettingsItem(context, title, hasTrailing: hasTrailing),
      ),
    );
  }

  // Fonction pour créer un élément de paramètre principal avec animation
  Widget buildSettingsItem(BuildContext context, String title, {bool hasTrailing = true}) {
    return Padding(
      padding:  EdgeInsets.only(top: 15.h, bottom: 5.h),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          const Spacer(),
          if (hasTrailing)
            const Icon(Icons.keyboard_arrow_down, color: Color.fromARGB(255, 238, 65, 65)),
        ],
      ),
    );
  }

  // Fonction pour créer un sous-élément de paramètre
  Widget buildSubSettingsItem(BuildContext context, String title) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          Icon(Icons.keyboard_arrow_left, color: Colors.grey),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              title,
              style:  TextStyle(fontSize: 14.sp, color: Colors.black),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour créer un élément de paramètre avec toggle
  Widget buildSettingsToggleItem(BuildContext context, String title, bool value) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Text(
            title,
            style:  TextStyle(fontSize: 14.sp),
          ),
          const Spacer(),
          Switch(
            value: value,
            onChanged: (newValue) {
              setState(() {
                notificationsEnabled = newValue;
              });
            },
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
