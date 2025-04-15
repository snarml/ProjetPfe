import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final String? Function(String?)? validator;
  final Color borderColor;
  final bool isPassword; // Indique si le champ est un mot de passe

  const CustomInputField({
    Key? key,
    required this.icon,
    required this.hint,
    required this.controller,
    this.isPassword = false, // Défaut à faux
    this.obscure = false,
    this.validator,
    this.borderColor = Colors.transparent,
  }) : super(key: key);
  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}
class _CustomInputFieldState extends State<CustomInputField> {
  bool isObscure = true; // Masque le mot de passe par défaut
  @override
  void initState() {
    super.initState();
    // si le champs n'est pas un champs de mot de passe , on n'obscurit pas le texte 
    if (!widget.isPassword) {
      isObscure = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child:Container(
        //ajouter un conteneur avec un ombre 
        decoration: BoxDecoration(
        
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 3), // décalage de l'ombre
            ),
          ],
        ),

      
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? isObscure : false,
        textAlign: TextAlign.right,
        validator: widget.validator,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 126, 125, 125)),
          filled: true,
          fillColor: Colors.white,
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
            borderSide: BorderSide(color: widget.borderColor,width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: widget.borderColor,width: 1.5)
            ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: widget.borderColor, width: 2.3)
            ),
        ),
      ),
      ),
    );
  }
}