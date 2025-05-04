import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Searchbar extends StatelessWidget {
  
  final ValueChanged<String>? onChanged;
  const Searchbar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
  

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: '...ابحث عن منتج',
          hintStyle: GoogleFonts.cairo(),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: const Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.green)),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
        textAlign: TextAlign.right,
        style: GoogleFonts.cairo(),
      ),
    );
  }
}