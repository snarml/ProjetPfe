import 'package:bitakati_app/controllers/cartController.dart';
import 'package:bitakati_app/screens/CheckoutPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final CartController cartController;
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    cartController = Get.find<CartController>();
    _loadCartData();
  }

  Future<void> _loadCartData() async {
    try {
      final token = await loadToken();
      final prefs = await SharedPreferences.getInstance();
      currentUserId = prefs.getInt('user_id');

      if (token != null && currentUserId != null) {
        await cartController.fetchCart(currentUserId!, token);
      }
    } catch (e) {
      print('Erreur chargement panier: $e');
    }
  }

  // Liste des produits dans le panier (exemple)
  List<Map<String, dynamic>> cartItems = [
    {
      'id': '1',
      'name': 'بودر الأرز',
      'price': 14.0,
      'image': 'images/rice.jpeg',
      'quantity': 2,
      'unit': 'كيلو',
    },
    {
      'id': '6',
      'name': 'الطماطم',
      'price': 0.8,
      'image': 'images/tomate.jpg',
      'quantity': 5,
      'unit': 'كيلو',
    },
    {
      'id': '5',
      'name': 'موز',
      'price': 8.0,
      'image': 'images/banane.png',
      'quantity': 1,
      'unit': 'كيلو',
    },
  ];

  double get totalPrice {
    return cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'عربة التسوق',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _clearCart(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (cartController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (cartController.cartItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'السلة فارغة',
                        style: GoogleFonts.cairo(
                          fontSize: 20,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  return _buildCartItem(item, index);
                },
              );
            }),
          ),
          _buildTotalSection(),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
     print('🛒 Données du produit:');
      print(item);
    // Fonction pour construire l'image
    Widget _buildProductImage(String? imageUrl) {
      if (imageUrl == null || imageUrl.isEmpty) {
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
        );
      }

      // Si c'est une URL complète
      if (imageUrl.startsWith('http')) {
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('Erreur chargement image: $error');
                return Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.error_outline, color: Colors.grey[400]),
                );
              },
            ),
          ),
        );
      }

      // Si c'est une image locale
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Utiliser la nouvelle fonction pour l'image
            _buildProductImage(item['image_url'] ?? item['image']),
            const SizedBox(width: 12),
            // Détails du produit
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item['nom'] ?? item['name'] ?? 'منتج غير معروف', // Ajouter un fallback
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item['price']} دينار / ${item['unit']}',
                    style: GoogleFonts.cairo(
                      color: Colors.green[700],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  // Contrôle de quantité
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 20),
                        onPressed: () => _updateQuantity(index, -1),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          padding: const EdgeInsets.all(4),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${item['quantity']}',
                          style: GoogleFonts.cairo(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 20),
                        onPressed: () => _updateQuantity(index, 1),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.green[100],
                          padding: const EdgeInsets.all(4),
                        ),
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

  Widget _buildTotalSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المجموع',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$totalPrice دينار',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _checkout(),
              child: Text(
                'إتمام الشراء',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateQuantity(int index, int change) async {
    try {
      final item = cartController.cartItems[index];
      final newQuantity = item['quantite'] + change;
      
      if (newQuantity <= 0) {
        await _removeItem(index);
        return;
      }

      final token = await loadToken();
      if (token == null || currentUserId == null) return;

      final success = await cartController.updateQuantity(
        currentUserId!,
        item['produit_id'],
        newQuantity,
        token
      );

      if (success) {
        await _loadCartData(); // Recharger le panier
      }
    } catch (e) {
      print('Erreur modification quantité: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحديث الكمية',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _removeItem(int index) async {
    try {
      final item = cartController.cartItems[index];
      final token = await loadToken();
      if (token == null || currentUserId == null) return;

      final success = await cartController.removeItem(
        currentUserId!,
        item['produit_id'],
        token
      );

      if (success) {
        Get.snackbar(
          'نجاح',
          'تم حذف المنتج من السلة',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await _loadCartData(); // Recharger le panier
      }
    } catch (e) {
      print('Erreur suppression produit: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء حذف المنتج',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _clearCart() async {
    try {
      final token = await loadToken();
      if (token == null || currentUserId == null) return;

      final success = await cartController.clearCart(currentUserId!, token);
      
      if (success) {
        Get.snackbar(
          'نجاح',
          'تم تفريغ السلة بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await _loadCartData(); // Recharger le panier
      }
    } catch (e) {
      print('Erreur vidage panier: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تفريغ السلة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _checkout() {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'السلة فارغة',
        'أضف منتجات إلى السلة أولاً',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Ici vous pouvez ajouter la logique de paiement
    Get.to(() => CheckoutPage(totalAmount: totalPrice));
  }
  
  loadToken() {}
}

