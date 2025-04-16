import 'package:bitakati_app/screens/signIn/signin_screen.dart';
import 'package:bitakati_app/screens/signIn/signup_screen.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _SignInState();
}

class _SignInState extends State<LoginPage> {
  bool isLoginMode = true;

  void toggleMode() {
    setState(() {
      isLoginMode = !isLoginMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
    child:   Stack(
        alignment: Alignment.topCenter,
        children: [
          // Image en haut
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

          // Conteneur contenant le formulaire
          Positioned(
            top: MediaQuery.of(context).size.height * 0.30,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0  ),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Boutons "Créer un compte" et "Se connecter"
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (!isLoginMode) toggleMode();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isLoginMode ? Colors.green : Colors.grey.shade300,
                            foregroundColor: isLoginMode ? Colors.white : Colors.black,
                            elevation: isLoginMode ? 2 : 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                          
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('تسجيل دخول', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (isLoginMode) toggleMode();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !isLoginMode ? Colors.green : Colors.grey.shade300,
                            foregroundColor: !isLoginMode ? Colors.white : Colors.black,
                            elevation: !isLoginMode ? 2 : 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('إنشاء حساب', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Contenu du formulaire (Login ou Register)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: isLoginMode ? const SignInScreen() : const SignUpScreen(),
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
    );
  }
}