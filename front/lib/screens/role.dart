import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Role extends StatelessWidget {
  const Role({super.key});

  void _handleRoleSelection(BuildContext context, String role) {
  if (role == 'فلاح') {
    // Redirection uniquement pour le rôle "فلاح"
    Get.toNamed('/login', arguments: role);
  } else {
    // Afficher un message pour les autres rôles
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ميزة تسجيل الدخول متاحة حالياً فقط للفلاحين'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690), minTextAdapt: true);

    return Scaffold(
      backgroundColor: const Color(0xFFEFFBF1),
      appBar: AppBar(
        title: Text(
          'اختر دورك في المنصة',
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30.h),
            _buildRoleCard(
              context,
              title: 'مواطن',
              subtitle:' للتسوق الإكتروني',
              icon: Icons.person_outline,
              gradientColors: [Colors.orange.shade300, Colors.deepOrange.shade200],
            ),
            SizedBox(height: 24.h),
            _buildRoleCard(
              context,
              title: 'فلاح',
              subtitle: 'لإدارة محاصيلك وبيع منتجاتك',
              icon: Icons.agriculture_outlined,
              gradientColors: [Colors.lightGreen.shade400, Colors.green.shade600],
            ),
            SizedBox(height: 24.h),
            _buildRoleCard(
              context,
              title: 'مزود خدمة',
              subtitle: 'لتقديم خدمات للفلاحين والعملاء',
              icon: Icons.miscellaneous_services_outlined,
              gradientColors: [Colors.teal.shade300, Colors.cyan.shade600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
  }) {
    return GestureDetector(
      onTap: () => _handleRoleSelection(context, title),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51), // Equivalent to withOpacity(0.2)
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40.sp,
              color: Colors.white,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withAlpha(230), // Equivalent to withOpacity(0.9)
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
