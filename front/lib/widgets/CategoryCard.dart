import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryDropdown extends StatelessWidget {
  final int marketTypeIndex;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  CategoryDropdown({
    super.key,
    required this.marketTypeIndex,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  final List<List<String>> marketCategories = [
    ['الكل', 'الأدوية', 'مواد وأدوات زراعية', 'أدوات العناية والتنظيف', 'مواد جمع المحصول', 'أدوات تربية الماشية والأعلاف', 'أدوات ومعدات الصيد البحري'],
    ['الكل', 'خضروات', 'غلال', 'حبوب', 'الماشية', 'الصيد البحري'],
  ];

  @override
  Widget build(BuildContext context) {
    final currentCategories = marketCategories[marketTypeIndex];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          filled: true,
          fillColor: Colors.white,
        ),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.green),
        dropdownColor: Colors.white,
        style: GoogleFonts.cairo(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        items: currentCategories.map((category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(
              category,
              style: GoogleFonts.cairo(),
            ),
          );
        }).toList(),
        onChanged: (value) => onCategoryChanged(value!),
      ),
    );
  }
}