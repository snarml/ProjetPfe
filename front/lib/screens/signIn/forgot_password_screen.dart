import 'package:bitakati_app/screens/signIn/verification_code.dart';
import 'package:bitakati_app/services/authServices.dart';
import 'package:bitakati_app/widgets/custom_Input_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
    final ApiService _authServices = ApiService();
    
      get token => null;


  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Appel API pour envoyer le code ou le lien de réinitialisation
        // final result = await apiService.resetPassword(_phoneController.text);

        // Si l'API réussit, afficher un message de succès

        Get.to(
            () => VerificationCode(phone: _phoneController.text, token: token));
      } catch (e) {
        // Si erreur, afficher un message d'erreur
        Get.snackbar('خطأ', 'حدث خطأ. يرجى المحاولة مرة أخرى.',
            backgroundColor: Colors.red);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Directionality(
          textDirection:
              TextDirection.rtl, // Applique l'orientation RTL pour l'arabe
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Image.asset(
                    'images/sign_in.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.30,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 20.0),
                  height: MediaQuery.of(context).size.height * 0.65,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(66, 8, 8, 8),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'هل نسيت كلمة المرور؟',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Champ de numéro de téléphone
                      CustomInputField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 12,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'رقم الهاتف مطلوب';
                          }
                          if (value.length != 8) {
                            return 'يرجى إدخال رقم صالح';
                          }
                          return null;
                        },
                        icon: Icons.phone,
                        hint: 'أدخل رقم هاتفك',
                        borderColor: Colors.green,
                      ),
                      SizedBox(height: 20.h),
                      // Bouton envoyer le code de réinitialisation
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
                          onPressed: _isLoading ? null : _handleResetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'إرسال الكود',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Lien de retour à la page de connexion
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Get.back(); // Retour à la page de connexion
                          },
                          child: const Text(
                            'الرجوع إلى تسجيل الدخول',
                            style: TextStyle(color: Colors.green, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
