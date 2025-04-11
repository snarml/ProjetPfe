import 'package:bitakati_app/widgets/custom_Input_filed.dart';
import 'package:flutter/material.dart';

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
  
  
  
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Color.fromARGB(255, 122, 169, 92),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'تعديل الملف الشخصي',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Column(
                        children: [
                          CustomInputField(icon: Icons.person, hint: 'الاسم الكامل', controller: _nameController),
                          CustomInputField(icon: Icons.phone, hint: 'رقم الهاتف', controller: _phoneController),
                          CustomInputField(icon: Icons.map, hint: 'الولاية', controller: _stateController),
                          CustomInputField(icon: Icons.location_city, hint: 'المدينة', controller: _cityController),
                          CustomInputField(icon: Icons.lock, hint: 'كلمة المرور القديمة', controller: _oldPasswordController, obscure: true),
                          CustomInputField(
                            icon: Icons.lock_open,
                            hint: 'كلمة المرور الجديدة',
                            controller: _newPasswordController,
                            obscure: true,
                            validator: (value) {
                              if (_oldPasswordController.text.isNotEmpty && value!.isEmpty) {
                                return 'الرجاء إدخال كلمة المرور الجديدة';
                              }
                              return null;
                            },
                          ),
                          CustomInputField(
                            icon: Icons.lock_outline,
                            hint: 'تأكيد كلمة المرور',
                            controller: _confirmPasswordController,
                            obscure: true,
                            validator: (value) {
                              if (_oldPasswordController.text.isNotEmpty && value != _newPasswordController.text) {
                                return 'كلمات المرور غير متطابقة';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('حفظ التغييرات', style: TextStyle(fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ التغييرات بنجاح')),
      );
      // Implémente la logique ici.
    }
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
}
