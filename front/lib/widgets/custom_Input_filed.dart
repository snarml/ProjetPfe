import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final String? Function(String?)? validator;
  final Color borderColor;
  final bool isPassword;
  final int? maxLength;
  final TextInputType? keyboardType;

  const CustomInputField({
    super.key,
    required this.icon,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.obscure = false,
    this.validator,
    this.maxLength,
    this.keyboardType,
    this.borderColor = Colors.transparent,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool isObscure = true;

  @override
  void initState() {
    super.initState();
    isObscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Material(
        elevation: 4,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(15),
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? isObscure : false,
          textAlign: TextAlign.right,
          validator: widget.validator,
          maxLength: widget.maxLength,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            counterText: '', // masque compteur caractères
            hintText: widget.hint,
            hintStyle: const TextStyle(color: Color.fromARGB(255, 126, 125, 125)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            suffixIcon: Icon(widget.icon, color: Colors.green),
            prefixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      isObscure ? Icons.visibility : Icons.visibility_off,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: widget.borderColor, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: widget.borderColor, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: widget.borderColor, width: 2.3),
            ),
          ),
        ),
      ),
    );
  }
}
