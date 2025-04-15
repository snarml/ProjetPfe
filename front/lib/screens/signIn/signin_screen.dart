import 'package:bitakati_app/screens/Home_page.dart';
import 'package:bitakati_app/widgets/custom_Input_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.h),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'أهلا بك',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.h), // Augmenté pour plus d'espace
            CustomInputField(
              icon: Icons.phone,
              hint: 'رقم الهاتف',
              controller: _phoneController,
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
            SizedBox(height: 16.h), // Consistency: using .h
            // Réorganisé pour l'interface RTL (droite à gauche)
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align to the right for RTL
              children: [
                const Text('تذكر كلمة المرور'), // Text first for RTL
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Logique de connexion
                    Get.offAll(() => HomePage());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  elevation: 0, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), 
                    
                  ),
                  
                ),
                child: const Text(
                  'تسجيل دخول',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold,letterSpacing: 0.5),
                ),
              ),
            ),
            SizedBox(height: 16.h), // Consistency: using .h
            Center(
              child: TextButton(
                onPressed: () {
                  // Logique pour la récupération de mot de passe
                  // Get.to(() => ForgotPasswordPage());
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
    );
  }
}