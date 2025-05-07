import 'package:bitakati_app/screens/EditProfile.dart';
import 'package:bitakati_app/screens/favoriteLists.dart';
import 'package:bitakati_app/screens/historyInteractionChatbot.dart';
import 'package:bitakati_app/screens/languageSettings.dart';
import 'package:bitakati_app/screens/purchaseTracking.dart';
import 'package:bitakati_app/screens/salesTracking.dart';
import 'package:bitakati_app/services/change_role_request.dart';
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
                _buildSettingItem("متابعة عمليات البيع", onTap: () {
                  Get.to(() => SalesTracking());
                }),
                _buildSettingItem("متابعة عمليات الشراء", onTap: () {
                  Get.to(() => PurchasesTracking());
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
              title: "إدارة الحساب",
              items: [
                _buildSettingItem("طلب تغيير الدور", onTap: () {
                  // Ajouter la logique pour le changement de rôle
                  _showChangeRoleDialog();
                }),
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
          "مرحبا User!",
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
  // Ajoutez cette méthode pour gérer la demande de changement de rôle
Future<void> _handleRoleChangeRequest(String requestedRole) async {
  try {
    // Récupérer le token depuis SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    if (token == null) {
      Get.snackbar(
        'Erreur',
        'Vous devez être connecté',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Afficher un indicateur de chargement
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    // Appeler le service
    final apiService = ApiChangeRoleService();
    final result = await apiService.requestRoleChange(
      token: token,
      requestedRole: requestedRole,
    );

    // Fermer l'indicateur de chargement
    Get.back();

    // Afficher le résultat
    Get.snackbar(
      result['success'] ? 'Succès' : 'Erreur',
      result['message'],
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: result['success'] ? Colors.green : Colors.red,
      colorText: Colors.white,
    );
  } catch (e) {
    Get.back();
    Get.snackbar(
      'Erreur',
      'Une erreur inattendue est survenue',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

  void _showChangeRoleDialog() {
  String? selectedRole;
  
  Get.dialog(
    AlertDialog(
      title: Text("طلب تغيير الدور"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("الرجاء اختيار الدور الجديد:"),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedRole,
            items: [
              // Remplacez ces valeurs par les rôles disponibles dans votre application
              DropdownMenuItem(value: 'prestataire', child: Text("مقدم الخدمة")),
              DropdownMenuItem(value: 'citoyen', child: Text("مواطن")),
            ],
            onChanged: (value) {
              selectedRole = value;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey, width: 1.w),

              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.green, width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey, width: 1.w),
              ),
              labelText: 'الدور المطلوب',

            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text("إلغاء"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {
            if (selectedRole == null) {
              Get.snackbar(
                "خطأ",
                "الرجاء اختيار دور",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }
            Get.back();
            _handleRoleChangeRequest(selectedRole!);
          },
          child: Text("تأكيد", style: TextStyle(color: Colors.white)),
        ),
      ],
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
            onPressed: () {
              // Logique pour déconnecter l'utilisateur
              Get.back();
              // Exemple de redirection vers l'écran de connexion
              // Get.offAll(() => LoginScreen());
              Get.snackbar(
                "تم تسجيل الخروج",
                "لقد تم تسجيل خروجك بنجاح",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text("تسجيل الخروج", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}