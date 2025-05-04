import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubcategoryBottomSheet extends StatelessWidget {
  final Map<String, dynamic> category;

  const SubcategoryBottomSheet({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(category['name'], style: GoogleFonts.cairo(fontSize: 20)),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: category['subcategories'].length,
              itemBuilder: (ctx, index) => ListTile(
                title: Text(
                  category['subcategories'][index],
                  style: GoogleFonts.cairo(),
                  textAlign: TextAlign.right,
                ),
                onTap: () => Navigator.pop(ctx),
              ),
            ),
          ),
        ],
      ),
    );
  }
}