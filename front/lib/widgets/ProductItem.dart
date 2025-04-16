import 'package:bitakati_app/screens/ProductDetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String nom;
  final String prix;
  final String imagePath;
  final bool isChecked;
  final Function(bool?)? onChanged;

  const ProductItem({
    super.key,
    required this.id,
    required this.nom,
    required this.prix,
    required this.imagePath,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _navigateToDetails(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.asset(
                  imagePath, 
                  fit: BoxFit.cover, 
                  width: double.infinity
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                children: [
                  Text(nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(prix, style: const TextStyle(color: Color.fromARGB(255, 102, 100, 100))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Checkbox(
                        value: isChecked, 
                        onChanged: onChanged, 
                        activeColor: Colors.green,
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        onPressed: _navigateToDetails,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetails() {
    Get.to(
      () => ProductDetailsPage(
        productId: id,
        productName: nom,
        productPrice: prix,
        productImage: imagePath,
      ),
      // Options de transition
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }
}