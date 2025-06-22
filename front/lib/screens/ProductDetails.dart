import 'package:bitakati_app/controllers/cartController.dart';
import 'package:bitakati_app/controllers/productController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ProductDetailsPage extends StatefulWidget {
  final String productId;
  final String? productName;
  final String? productPrice;
  final String? productImage;

  const ProductDetailsPage({
    super.key,
    required this.productId,
    this.productName,
    this.productPrice,
    this.productImage,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final ProductController _controller = Get.put(ProductController());
  bool isFavorite = false;
  int? currentUserId;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
    _controller.fetchProductDetails(widget.productId);
  }

  Future<void> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    print('UserId chargé: $userId');
    setState(() {
      currentUserId = userId;
    });
    // Forcer une mise à jour du bottomBar
    if (mounted) {
      setState(() {});
    }
  }
  // Ajoutez une méthode pour vérifier si l'utilisateur est propriétaire
  bool isProductOwner() {
    final details = _controller.productDetails.value;
    if (details == null || currentUserId == null) return false;
    
    final productOwnerId = details['utilisateur_id'];
    print('Vérification propriétaire - Product Owner: $productOwnerId, Current User: $currentUserId');
    
    return productOwnerId == currentUserId;
  }

  Future<String?> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'تفاصيل المنتج',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            tooltip: 'إضافة إلى المفضلة',
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (currentUserId == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final details = _controller.productDetails.value;
        if (details == null) {
          return const Center(child: Text('لا يمكن تحميل تفاصيل المنتج'));
        }

        final productName = details['nom'] ?? widget.productName ?? '';
        final productPrice = details['prix']?.toString() ?? widget.productPrice ?? '';
        final productImage = details['image_url'] ?? widget.productImage ?? '';
        final productDescription = details['description'] ?? 'لا يوجد وصف متاح';
        final productCategory = details['category']?['nom'] ?? '';
        final offerType = details['type_offre'] ?? '';
        final productQuantity = details['quantite']?.toString() ?? '0';

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        Hero(
                          tag: 'product-image-${widget.productId}',
                          child: _buildImage(productImage),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      productName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$productPrice دينار', 
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                          fontFamily: 'Tajawal',
                        ),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'التصنيف: $productCategory',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 66, 65, 65),
                        fontFamily: 'Tajawal',
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    if (offerType.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.local_offer, color: Colors.blueGrey, size: 22),
                            const SizedBox(width: 6),
                            Text(
                              'نوع العرض: $offerType',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.blueGrey,
                                fontFamily: 'Tajawal',
                                fontWeight: FontWeight.w600,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      'الكمية المتاحة: $productQuantity',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 59, 59, 59),
                        fontFamily: 'Tajawal',
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                  ],

                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'الوصف',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      productDescription,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontFamily: 'Tajawal',
                        height: 1.5,
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() => _buildBottomBar(isProductOwner())),
    );
  }

  Widget _buildImage(String imagePath) {
    if (imagePath.isEmpty) {
      return const Icon(Icons.image_not_supported, size: 100, color: Colors.grey);
    } else if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 100, color: Colors.grey),
      );
    } else if (imagePath.startsWith('/uploads/')) {
      final url = 'http://10.0.2.2:4000$imagePath';
      return Image.network(
        url,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 100, color: Colors.grey),
      );
    } else if (imagePath.startsWith('/')) {
      return Image.file(
        File(imagePath),
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 100, color: Colors.grey),
      );
    } else {
      final url = 'http://10.0.2.2:4000/uploads/$imagePath';
      return Image.network(
        url,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 100, color: Colors.grey),
      );
    }
  }

  Widget _buildBottomBar(bool isOwner) {
    print('Building bottom bar - isOwner: $isOwner');
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: isOwner
          ? Center(
              child: Text(
                "لا يمكنك شراء منتجك الخاص",
                style: TextStyle(
                  color: Colors.red[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Tajawal',
                ),
                textDirection: TextDirection.rtl,
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () async {
                      try {
                        // Vérifier la quantité disponible 
                        final details = _controller.productDetails.value;
                        final availableQuantity = int.parse(details!['quantite'].toString());

                        if (quantity > availableQuantity) {
                          Get.snackbar(
                            'خطأ',
                            'الكمية المطلوبة غير متوفرة',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        final produitId = int.tryParse(widget.productId) ?? 0;
                        final token = await loadToken();
                        
                        if (token == null || currentUserId == null) {
                          Get.snackbar(
                            'خطأ',
                            'يرجى تسجيل الدخول أولاً',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        final cartController = Get.put(CartController());
                        print('Envoi requête: userId=$currentUserId, produitId=$produitId, quantity=$quantity');
                        
                        final success = await cartController.ajouterProduit(
                          currentUserId!, 
                          produitId,
                          quantity,
                          token
                        );

                        if (success) {
                          Get.snackbar(
                            'نجاح',
                            'تم إضافة المنتج إلى سلة التسوق',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        }
                      } catch (e) {
                        print('Erreur ajout panier: $e');
                        Get.snackbar(
                          'خطأ',
                          'حدث خطأ أثناء إضافة المنتج',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: const Text(
                      'إضافة إلى السلة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                        color: Colors.white,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: quantity > 1
                            ? () => setState(() => quantity--)
                            : null,
                      ),
                      Text('$quantity', style: const TextStyle(fontSize: 18)),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() => quantity++),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
