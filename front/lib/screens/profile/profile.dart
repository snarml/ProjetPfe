import 'package:bitakati_app/screens/profile/EditProfile.dart';
import 'package:bitakati_app/screens/profile/favoriteLists.dart';
import 'package:bitakati_app/screens/profile/historyInteractionChatbot.dart';
import 'package:bitakati_app/screens/profile/languageSettings.dart';
import 'package:bitakati_app/screens/purchaseTracking.dart';
import 'package:bitakati_app/screens/salesTracking.dart';
import 'package:bitakati_app/screens/prestataire/Service_Dashboard_Page.dart';
import 'package:bitakati_app/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool notificationsEnabled = true;
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
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.offAll(() => Navigationbar(selectedIndex: 0));
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
        title: Text(
          'الملف الشخصي',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
          ),
        ),
        backgroundColor: Colors.green[400],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfileHeader(),
            SizedBox(height: 25.h),
            _buildSectionCard(
              title: "معطيات",
              items: [
                _buildSettingItem("تعديل معطيات الملف الشخصي", onTap: () {
                  Get.to(() => Editprofile());
                }),
              ],
            ),
            _buildSectionCard(
              title: "إعدادات",
              items: [
                _buildSettingItem("إعدادات اللغة", onTap: () {
                  Get.to(() => LanguageSettings());
                }),
                _buildToggleItem("إشعارات", notificationsEnabled, (val) {
                  setState(() {
                    notificationsEnabled = val;
                  });
                }),
              ],
            ),
            _buildSectionCard(
              title: "متابعة",
              items: [
                _buildSettingItem("منتوجاتي", onTap: () {
                  Get.to(() => SalesTracking());
                }),
                _buildSettingItem("مشترياتي", onTap: () {
                  Get.to(() => PurchasesTracking());
                }),
                _buildSettingItem("متابعة الخدمات ", onTap: () {
                  Get.to(() => ServiceDashboardPage());
}),
              ],
            ),
            _buildSectionCard(
              title: "أنشطتي",
              items: [
                _buildSettingItem("سجل التفاعل مع المساعد الذكي", onTap: () {
                  Get.to(() => InteractionHistory());
                }),
                _buildSettingItem("قائمة الإعجاب", onTap: () {
                  Get.to(() => FavoritesList());
                }),
              ],
            ),
            // Nouvelle section pour les actions importantes
            _buildSectionCard(
              title: "تسجيل الخروج",
              items: [
                _buildLogoutItem(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 45.r,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage('images/avatar.png'),
        ),
        SizedBox(height: 10.h),
        Text(
        '! مرحبا ${fullName.isNotEmpty ? fullName : ''}',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5.h),
      ],
    );
  }

  Widget _buildSectionCard(
      {required String title, required List<Widget> items}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 240, 236, 236),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 82, 81, 81),
            blurRadius: 8,
            offset: Offset(1, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
            textAlign: TextAlign.right,
          ),
          Divider(height: 20.h, color: Colors.grey[300]),
          ...items
        ],
      ),
    );
  }
  

  Widget _buildSettingItem(String title, {void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.arrow_back_ios, size: 16.sp, color: Colors.grey),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 14.sp, color: Colors.black),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green,
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 14.sp),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutItem() {
    return InkWell(
      onTap: () {
        _showLogoutDialog();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.arrow_back_ios, size: 16.sp, color: Colors.grey),
            Expanded(
              child: Text(
                "تسجيل الخروج",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("تسجيل الخروج"),
        content: Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("إلغاء"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: _performLogout,
            child: Text("تسجيل الخروج", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout() async {
    try {
      Get.back();
      
      // Clear user data from shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('full_name');
      
      // Navigate to login screen
      // Get.offAll(() => LoginScreen());
      
      Get.snackbar(
        "تم تسجيل الخروج",
        "لقد تم تسجيل خروجك بنجاح",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء تسجيل الخروج",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}