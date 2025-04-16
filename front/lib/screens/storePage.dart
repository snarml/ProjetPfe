import 'package:bitakati_app/screens/CartPage.dart';
import 'package:bitakati_app/screens/addProductPage.dart';
import 'package:bitakati_app/widgets/ProductItem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Page principale du magasin
class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  List<Map<String, dynamic>> produits = [
    {
      'id': '1',
      'nom': 'بودر الأرز',
      'prix': '14 دينار للكيلو',
      'image': 'images/rice.jpeg',
      'checked': false,
      'category': 'أساسيات',
    },
    {
      'id': '2',
      'nom': 'خميرة الليمون',
      'prix': '15 دينار للكيلو',
      'image': 'images/lemon.jpeg',
      'checked': false,
      'category': 'مكونات',
    },
    {
      'id': '3',
      'nom': 'قمح',
      'prix': '14 دينار للكيلو',
      'image': 'images/wheat.jpeg',
      'checked': false,
      'category': 'أساسيات',
    },
    {
      'id': '4',
      'nom': 'سفارجلة',
      'prix': '11 دينار للكيلو',
      'image': 'images/carotte.jpg',
      'checked': false,
      'category': 'خضروات',
    },
    {
      'id': '5',
      'nom': 'موز',
      'prix': '8 دينار للكيلو',
      'image': 'images/banane.png',
      'checked': false,
      'category': 'فواكه',
    },
    {
      'id': '6',
      'nom': 'الطماطم',
      'prix': '0.800 دينار للكيلو',
      'image': 'images/tomate.jpg',
      'checked': true,
      'category': 'خضروات',
    },
  ];

  String selectedCategory = 'الكل';
  List<String> categories = ['الكل', 'أساسيات', 'خضروات', 'فواكه', 'مكونات'];

  void _showAddedToCartSnackbar(String productName) {
    Get.snackbar(
      'تمت الإضافة',
      'تم إضافة $productName إلى السلة',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.check_circle, color: Colors.white),
      shouldIconPulse: true,
    );
  }

  List<Map<String, dynamic>> get filteredProducts {
    if (selectedCategory == 'الكل') return produits;
    return produits.where((p) => p['category'] == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'التسوق',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        elevation: 3,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.to(() => const AddProductPage()),
          ),
          Badge(
            label: const Text('3'),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () => Get.to(() => const CartPage()),
            ),
          ),
          const SizedBox(width: 10),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Barre de recherche et filtre
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Barre de recherche
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '...ابحث عن منتج',
                      hintStyle: GoogleFonts.cairo(),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.green),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    textAlign: TextAlign.right,
                    style: GoogleFonts.cairo(),
                  ),
                ),
                const SizedBox(height: 10),
                // Filtres par catégorie
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(categories[index]),
                          selected: selectedCategory == categories[index],
                          selectedColor: Colors.green,
                          labelStyle: GoogleFonts.cairo(
                            color: selectedCategory == categories[index]
                                ? Colors.white
                                : Colors.black,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = categories[index];
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Liste des produits
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductItem(
                  id: product['id'],
                  nom: product['nom'],
                  prix: product['prix'],
                  imagePath: product['image'],
                  isChecked: product['checked'],
                  onChanged: (val) {
                    setState(() {
                      product['checked'] = val;
                      if (val == true) {
                        _showAddedToCartSnackbar(product['nom']);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Page d'ajout de produit

