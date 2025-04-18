import 'dart:async';
import 'package:bitakati_app/screens/signIn/login_page.dart';
import 'package:bitakati_app/screens/signIn/signin_screen.dart';
import 'package:bitakati_app/services/authServices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class VerificationCode extends StatefulWidget {
  final String phone;
  final String token;

  const VerificationCode({super.key, required this.phone, required this.token});

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  final List<TextEditingController> _codeControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  String? _errorMessage;
  bool _isVerifying = false;

  final ApiService _apiService = ApiService();

  String _getCode() {
    return _codeControllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyCode() async {
    final enteredCode = _getCode();

    if (enteredCode.length != 6) {
      if (mounted) {
        setState(() =>
            _errorMessage = "الرجاء إدخال الرمز كاملاً المكون من 6 أرقام");
      }
      return;
    }

    try {
      final result = await _apiService.verifyCode(widget.token, enteredCode);
      print('API Response: $result');

      if (result['success'] == true) {
       if (mounted) {
        Get.snackbar(
          'نجاح',
          'تم التحقق من الرمز بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
          Get.offAll(
            () => LoginPage(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 500),
          );
       }
      } else {
        throw Exception(result['message'] ?? 'Échec de la vérification');
      }
    } catch (e) {
      print('Verification Error: $e');
      if (mounted) {
        setState(() => _isVerifying = false);
        for (var controller in _codeControllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();

        Get.snackbar(
          'فشل',
          e.toString().replaceAll("Exception: ", ""),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Image.asset('images/sign_in.jpeg', fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.30,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(25.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -5))
                ],
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("تأكيد رقم الهاتف",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(width: 40),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Icon(Icons.message, size: 70, color: Colors.green),
                  const SizedBox(height: 20),
                  const Text("أدخل الكود المرسل إلى",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18)),
                  Text(widget.phone,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),
                  const SizedBox(height: 30),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            6,
                            (index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: TextField(
                                      controller: _codeControllers[index],
                                      focusNode: _focusNodes[index],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                      decoration: InputDecoration(
                                        counter: const SizedBox.shrink(),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Colors.green)),
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (value) {
                                        if (value.isNotEmpty && index < 5) {
                                          _focusNodes[index + 1].requestFocus();
                                        } else if (value.isEmpty && index > 0) {
                                          // Retour au champ précédent si backspace
                                          _focusNodes[index - 1].requestFocus();
                                        }
                                        // Pas de vérification automatique ici
                                      },
                                    ),
                                  ),
                                ))),
                  ),
                  const SizedBox(height: 20),

                  // Bouton de vérification
                  ElevatedButton(
                    onPressed: _verifyCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: _isVerifying
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ))
                        : const Text(
                            "تحقق من الرمز",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),

                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(_errorMessage!,
                          style: const TextStyle(color: Colors.red)),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
