import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class VerificationCode extends StatefulWidget {
  final String phone;
  const VerificationCode({super.key, required this.phone});

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  final List<TextEditingController> _codeControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final String _correctCode = "123456";
  bool _isResendEnabled = false;
  int _timerSeconds = 60;
  Timer? _timer;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _isResendEnabled = false;
      _timerSeconds = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _isResendEnabled = true;
          _timer?.cancel();
        }
      });
    });
  }

  String _getCode() {
    return _codeControllers.map((controller) => controller.text).join();
  }

  void _verifyCode() async {
    final enteredCode = _getCode();

    if (enteredCode.length != 6) {
      setState(() {
        _errorMessage = "الرجاء إدخال الرمز كاملاً المكون من 6 أرقام";
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (enteredCode == _correctCode) {
      Get.dialog(
        AlertDialog(
          title: const Text("!نجاح", textAlign: TextAlign.center),
          content: const Text("تم التحقق بنجاح", textAlign: TextAlign.center),
          actions: [
            TextButton(
              onPressed: () => Get.offAllNamed('/login'),
              child: Center(
                child: Container(
                  
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(15)),
                  child: const Text("الانتقال إلى تسجيل الدخول", style: TextStyle(color: Colors.white),
                ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _errorMessage = "رمز غير صحيح، حاول مرة أخرى";
      });
      for (var controller in _codeControllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  void _resendCode() {
    Get.snackbar("إعادة إرسال", "تم إرسال رمز جديد إلى ${widget.phone}",
        snackPosition: SnackPosition.TOP, backgroundColor: Colors.blue, colorText: Colors.white);

    for (var controller in _codeControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
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
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -5))],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                      const Text(
                        textAlign: TextAlign.center, 
                        "تأكيد رقم الهاتف", 
                      
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      
                      const SizedBox(width: 40),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Icon(Icons.message, size: 70, color: Colors.green),
                  const SizedBox(height: 20),
                  Text("أدخل الكود المرسل إلى", textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
                  Text(widget.phone, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(height: 30),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
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
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.green)),
                            ),
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                _focusNodes[index + 1].requestFocus();
                              }
                              if (_getCode().length == 6) {
                                _verifyCode();
                              }
                            },
                          ),
                        ),
                      )),
                    ),
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                    ),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: _isResendEnabled ? _resendCode : null,
                    child: Text("إعادة إرسال الرمز (${_timerSeconds}s)", style: TextStyle(color: _isResendEnabled ? Colors.green : Colors.grey)),
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
