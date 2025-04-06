import 'package:bitakati_app/screens/Home_page.dart';
import 'package:flutter/material.dart';
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
  bool _isObscure = true; // Masque le mot de passe par défaut

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'أهلا بك',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              textDirection: TextDirection.rtl,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال رقم الهاتف';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _isObscure, // Cache le texte si _isObscure = true
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                border: const OutlineInputBorder(),
                prefixIcon: IconButton(
                  icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility, // Icône dynamique
                  ),
                  onPressed: (){
                    setState(() {
              _isObscure = !_isObscure; // Inverser l'état (masquer/afficher)
            });
                  },
                ),
                  
              ),
              textDirection: TextDirection.rtl,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال كلمة المرور';
                }
                return null;
              },
            ),
            Row(
              children: [
                Checkbox(
                  value: _rememberPassword,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      _rememberPassword = value!;
                    });
                  },
                ),
                const Text('تذكر كلمة المرور')
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Logique de connexion
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(content: Text('جاري تسجيل الدخول...')),
                  //   );
                    Get.offAll(() => HomePage());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'تسجيل دخول',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: 
() {
                  // Logique pour la récupération de mot de passe
                  //   Get.to(() => ForgotPasswordPage());
                },
                
                child: const Text(
                  'نسيت كلمة المرور؟',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
