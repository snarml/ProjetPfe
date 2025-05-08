import 'package:bitakati_app/screens/signIn/forgot_password_screen.dart';
import 'package:bitakati_app/services/authServices.dart';
import 'package:bitakati_app/widgets/custom_Input_filed.dart';
import 'package:bitakati_app/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SignInScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _rememberPassword = false;
  bool _isLoading = false;
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final apiService = ApiService();
        await apiService.signIn(
          _phoneController.text,
          _passwordController.text,
        );

        //Sauvegarder les infos avec SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        if (_rememberPassword) {
          await prefs.setString('savedPhone', _phoneController.text);
        } else {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('savedPhone');
        }
        //Aller dans la page d'accueil
        Get.offAll(() => Navigationbar());
      } catch (e) {
        Get.snackbar('Erreur', e.toString(), backgroundColor: Colors.red);
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
 _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedPhone = prefs.getString('savedPhone');

    if (savedPhone != null) {
      setState(() {
        _phoneController.text = savedPhone;
        _rememberPassword = true;
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'أهلا بيك',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20.h),
                CustomInputField(
                  icon: Icons.phone,
                  hint: 'رقم الهاتف',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 12,
                  borderColor: Colors.green,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال رقم الهاتف';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.h),
                CustomInputField(
                  icon: Icons.lock,
                  hint: 'كلمة المرور',
                  controller: _passwordController,
                  isPassword: true,
                  borderColor: Colors.green,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال كلمة المرور';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('تذكر كلمة المرور'),
                    Checkbox(
                      value: _rememberPassword,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setState(() {
                          _rememberPassword = value!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'تسجيل دخول',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 16.h),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Get.to(() => ForgotPasswordScreen());
                    },
                    child: const Text(
                      'نسيت كلمة المرور؟',
                      style: TextStyle(color: Colors.green, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}
