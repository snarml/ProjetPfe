import 'package:bitakati_app/screens/signIn/signin_screen.dart';
import 'package:bitakati_app/screens/signIn/verification_code.dart';
import 'package:bitakati_app/widgets/custom_Input_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:bitakati_app/services/authServices.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ApiService _authServices = ApiService();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.h),
      child: SingleChildScrollView(
        // Wrap the Form widget inside SingleChildScrollView
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Center(
                child: Text(
                  'إنشاء حساب جديد',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16.h),
              CustomInputField(
                icon: Icons.person,
                hint: 'الاسم الكامل',
                controller: _nameController,
                borderColor: Colors.green,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الاسم الكامل';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.h),
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
                icon: Icons.map,
                hint: 'الولاية',
                controller: _stateController,
                borderColor: Colors.green,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الولاية';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.h),
              CustomInputField(
                icon: Icons.location_city,
                hint: 'المدينة',
                controller: _cityController,
                borderColor: Colors.green,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال المدينة';
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
              SizedBox(height: 10.h),
              CustomInputField(
                icon: Icons.lock_clock_outlined,
                hint: 'تأكيد كلمة المرور',
                controller: _confirmPasswordController,
                isPassword: true,
                borderColor: Colors.green,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء تأكيد كلمة المرور';
                  }
                  if (value != _passwordController.text) {
                    return 'كلمة المرور غير متطابقة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 56, // Hauteur fixe pour un bouton plus élégant
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          print("le bouton a été pressé ");
                          if (_formKey.currentState!.validate()) {
                            try {
                              // Call the signUp function

                              final response = await _authServices.signUp(
                                context,
                                _nameController.text.trim(),
                                _phoneController.text.trim(),
                                _stateController.text.trim(),
                                _cityController.text.trim(),
                                _passwordController.text.trim(),
                              );
                              print("reponse de l api : $response");
                              // If successful, navigate to verification
                              if (response != null) {
                                String phoneNumber = _phoneController.text;
                                Get.offAll(
                                    () => VerificationCode(phone: phoneNumber));
                              } else {
                                print("aucune réponse valide de l'api");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('خطأ في التسجيل'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } catch (e) {
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString().replaceAll('Exception: ', '')),
                                backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15.w),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'التالي',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'لديك حساب بالفعل؟',
                      style: TextStyle(
                          fontSize: 16), // Adjusted size for better readability
                    ),
                    TextButton(
                      onPressed: () {
                        Get.offAll(() => SignInScreen());
                      },
                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
