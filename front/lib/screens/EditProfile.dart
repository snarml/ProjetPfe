import 'package:bitakati_app/services/userManagementServices.dart';
import 'package:bitakati_app/widgets/custom_Input_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('full_name') ?? '';
      _phoneController.text = prefs.getString('num_tel') ?? '';
      _stateController.text = prefs.getString('pays') ?? '';
      _cityController.text = prefs.getString('ville') ?? '';
    });
  }

  void _submitForm()async {
    if (!_formKey.currentState!.validate()) return;

    bool isPasswordSectionFilled = _oldPasswordController.text.isNotEmpty ||
        _newPasswordController.text.isNotEmpty ||
        _confirmPasswordController.text.isNotEmpty;

    if (_nameController.text.isEmpty &&
        _phoneController.text.isEmpty &&
        _stateController.text.isEmpty &&
        _cityController.text.isEmpty &&
        !isPasswordSectionFilled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء تعديل على الأقل حقل واحد')),
      );
      return;
    }

    // Validate password fields only if any of them is filled
    if (isPasswordSectionFilled) {
      if (_oldPasswordController.text.isEmpty) {
        _showError('الرجاء إدخال كلمة المرور القديمة');
        return;
      }
      if (_newPasswordController.text.isEmpty) {
        _showError('الرجاء إدخال كلمة المرور الجديدة');
        return;
      }
      if (_confirmPasswordController.text.isEmpty ||
          _newPasswordController.text != _confirmPasswordController.text) {
        _showError('كلمات المرور غير متطابقة');
        return;
      }
    }

    setState(() => _isLoading = true);

    UserManagementServices().editProfile(
      _nameController.text,
      _phoneController.text,
      _stateController.text,
      _cityController.text,
      isPasswordSectionFilled ? _oldPasswordController.text : null,
      isPasswordSectionFilled ? _newPasswordController.text : null,
      isPasswordSectionFilled ? _confirmPasswordController.text : null,
    ).then((response) async {
      setState(() => _isLoading = false);
      if (response['success']) {
        // 🔐 Mettre à jour les données dans SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('full_name', _nameController.text);
      prefs.setString('num_tel', _phoneController.text);
      prefs.setString('pays', _stateController.text);
      prefs.setString('ville', _cityController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ التغييرات بنجاح')),
        );
        Navigator.pushReplacement(context, 
          MaterialPageRoute(builder: (context) => const Editprofile()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'فشل التحديث')),
        );
      }
    }).catchError((error) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $error')),
      );
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
        title: Text(
          'تعديل الملف الشخصي',
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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green.shade300, width: 3.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset('images/avatar.png', fit: BoxFit.cover),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Icon(Icons.camera_alt_rounded, size: 22.sp, color: Colors.green.shade700),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            Form(
              key: _formKey,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  padding: EdgeInsets.all(25.w),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 246, 248, 244),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 82, 81, 81),
                        blurRadius: 8,
                        offset: Offset(1, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CustomInputField(icon: Icons.person, hint: 'الاسم الكامل', borderColor: Colors.green, controller: _nameController),
                      CustomInputField(icon: Icons.phone, hint: 'رقم الهاتف', borderColor: Colors.green, controller: _phoneController),
                      CustomInputField(icon: Icons.map, hint: 'الولاية', borderColor: Colors.green, controller: _stateController),
                      CustomInputField(icon: Icons.location_city, hint: 'المدينة', borderColor: Colors.green, controller: _cityController),
                      CustomInputField(icon: Icons.lock, hint: 'كلمة المرور القديمة', controller: _oldPasswordController, isPassword: true, borderColor: Colors.green),
                      CustomInputField(icon: Icons.lock, hint: 'كلمة المرور الجديدة', controller: _newPasswordController, isPassword: true, borderColor: Colors.green),
                      CustomInputField(icon: Icons.lock, hint: 'تأكيد كلمة المرور', controller: _confirmPasswordController, isPassword: true, borderColor: Colors.green),
                      SizedBox(height: 30.h),
                      Container(
                        width: double.infinity,
                        height: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          gradient: LinearGradient(
                            colors: [Color(0xFF00C853), Color(0xFF64DD17)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.green.shade200, blurRadius: 10, offset: Offset(0, 4)),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text('حفظ التغييرات', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
