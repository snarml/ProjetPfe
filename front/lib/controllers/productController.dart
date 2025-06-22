import 'dart:io';

import 'package:bitakati_app/models/product_model.dart';
import 'package:bitakati_app/services/marcheService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController {
  final MarcheService _marcheService = MarcheService();
  final RxList<Product> allProducts = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  RxList<Product> productsByCategory = <Product>[].obs;
  final Rx<Map<String, dynamic>?> productDetails = Rx<Map<String, dynamic>?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  String? _token;
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final ImagePicker _picker = ImagePicker();
  final Rx<XFile?> pickedFile = Rx<XFile?>(null);
  final RxString selectedCategory = RxString('');
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController quantityController;
  SharedPreferences? prefs;
  final RxString offerType = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadToken();
    initializeControllers();
    categories.value = [
      {'id': 1, 'nom': 'خضروات', 'type': 'produits'},
      {'id': 2, 'nom': 'فواكه' ,'type': 'produits'},
      {'id': 3, 'nom': 'حبوب' ,'type': 'produits' },
      {'id': 4, 'nom': 'الصيد البحري' ,'type': 'produits'},
      {'id': 5, 'nom': 'الماشية' ,'type': 'produits'},
      {'id': 6, 'nom': 'أدوات مستعملة','type': 'materiels'},
      {'id': 7, 'nom': 'أراضي','type': 'materiels'},
      {'id': 8, 'nom': 'الأدوية', 'type': 'materiels'},
      {'id': 9, 'nom': 'الأسمدة','type': 'materiels'},
      {'id': 10, 'nom': 'مواد وأدوات زراعية', 'type': 'materiels'},
      {'id': 11, 'nom': 'أدوات العناية والتنظيف', 'type': 'materiels'},
      {'id': 12, 'nom': 'مواد جمع المحصول', 'type': 'materiels'},
      {'id': 13, 'nom': 'أدوات تربية الماشية والأعلاف', 'type': 'materiels'},
      {'id': 14, 'nom': 'أدوات ومعدات الصيد البحري', 'type': 'materiels'},
    ];
  }

  void initializeControllers() {
    nameController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
    quantityController = TextEditingController();
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    super.onClose();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (_token != null) {
      loadProducts();
    } else {
      error.value = 'Token non trouvé ou vide';
    }
  }
     // charger tous les produits 
  Future<void> loadProducts() async {
    if (_token == null || _token!.isEmpty) {
      await _loadToken();
      if (_token == null || _token!.isEmpty) {
        error.value = 'Token non trouvé ou vide';
        return;
      }
    }
    try {
      isLoading.value = true;
      error.value = '';
      print('🔄 Chargement des produits...');
      final response = await _marcheService.getProducts(_token!);
      print('🔍 Réponse complète:');
      print('Response: $response');
      final products = (response).map((p) => Product.fromMap(p)).toList();
      allProducts.value = products;
      filteredProducts.value = products;
    } catch (e) {
      error.value = 'Erreur lors de la récupération: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void filterProducts(String query) {
    filteredProducts.value = allProducts.where((product) {
      return product.nom.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
  // charger les details du produit 

  Future<void> fetchProductDetails(String productId) async {
    try {
      isLoading.value = true;
      print("📡 Appel API pour récupérer les détails du produit...");
      final result = await _marcheService.getProductDetails(productId, _token!);

      if (result != null && result['product'] != null) {
        productDetails.value = result['product'];
        print("✅ Détails récupérés : ${productDetails.value}");
      } else {
        print("❌ Produit non trouvé ou réponse invalide");
        productDetails.value = null;
      }
    } catch (e) {
      print("🚨 Erreur lors de la récupération des détails : $e");
      error.value = 'Erreur lors de la récupération des détails: ${e.toString()}';
      productDetails.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      isLoading.value = true;
      if (_token?.isNotEmpty ?? false) {
        final result = await _marcheService.deleteProduct(_token!, productId);
        if (result) {
          await loadProducts();
          Get.snackbar(
            'تم الحذف',
            'تم حذف المنتج بنجاح',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          return true;
        }
        return false;
      } else {
        throw Exception('Token non trouvé ou vide');
      }
    } catch (e) {
      error.value = 'Erreur lors de la suppression: ${e.toString()}';
      Get.snackbar(
        'خطأ',
        'فشل في حذف المنتج: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // updateProduct ---
  Future<bool> updateProduct(Product product) async {
    try {
      isLoading.value = true;
      print('Token trouvé (longueur: ${_token?.length})');
      // Récupérer l'id de la catégorie à partir du nom sélectionné
      final categoryId = getCategoryIdByName(selectedCategory.value);
      if (categoryId == null) {
        Get.snackbar('خطأ', 'الفئة غير صالحة');
        return false;
      }

      // Gestion de l'image : si une nouvelle image est sélectionnée, on l'envoie, sinon on garde l'ancienne
      File? imageToSend;
      if (pickedFile.value != null) {
        imageToSend = File(pickedFile.value!.path);
        print('Envoi de nouvelle image: ${pickedFile.value!.path}');
      } else {
        imageToSend = null; // Le backend doit gérer la conservation de l'image existante si imageToSend est null
        print('Conservation de l\'image existante: ${product.image}');
      }
      final quantite = double.tryParse(quantityController.text) ?? 0;
      final prix = double.tryParse(priceController.text) ?? 0.0;

      final result = await _marcheService.updateProduct(
        product.id,
        nameController.text,
        descriptionController.text,
        prix,
        quantite,
        categoryId,
        imageToSend,
        _token!,
      );
      print('Réponse brute: ${result.toString()}');

      final body = result['body'];
      if (result['statusCode'] == 200) {
        if (body is Map && body['message'] != null) {
          await Future.delayed(Duration(seconds: 1));
          await loadProducts();
          Get.snackbar('نجاح', 
          "تم تعديل المنتج بنجاح", 
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          );
          return true;
        }
      } else {
        Get.snackbar('Erreur', body != null && body['message'] != null ? body['message'] : 'Erreur inconnue');
        return false;
      }
      return false;
    } catch (e) {
      error.value = 'Erreur lors de la mise à jour: ${e.toString()}';
      Get.snackbar('خطأ', 'فشل في تعديل المنتج: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addProduct() async {
    try {
      if (_token == null || _token!.isEmpty) throw Exception('Token non trouvé');
      final categoryId = getCategoryIdByName(selectedCategory.value);
      if (categoryId == null) throw Exception('Catégorie invalide');

      final result = await _marcheService.addProduct(
        nameController.text,
        descriptionController.text,
        double.parse(priceController.text),
        double.parse(quantityController.text),
        categoryId,
        offerType.value,
        pickedFile.value != null ? File(pickedFile.value!.path) : null,
        _token!,
      );

      if (result['statusCode'] == 201 || result['statusCode'] == 200) {
        await loadProducts();
        Get.snackbar(
          'تمت العملية',
          'تمت إضافة المنتج بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        throw Exception('Erreur lors de l\'ajout du produit');
      }
    } catch (e) {
      print('Erreur lors de l\'ajout du produit###: $e');
      // afficher l'erreur dans la console
      print('Erreur complète: $e');
      

      error.value = 'Erreur: ${e.toString()}';
      Get.snackbar(
        'خطأ',
        'فشل في إضافة المنتج: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// --- Utilitaire pour retrouver l'id d'une catégorie à partir de son nom ---
  int? getCategoryIdByName(String name) {
    final cat = categories.firstWhereOrNull((c) => c['nom'] == name);
    return cat != null ? cat['id'] as int : null;
  }

  Future<void> pickImage() async {
  try {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      // Limiter la taille pour optimiser le transfert
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    
    if (image != null) {
      // Vérifier si l'image provient de Google Drive (ce qui peut causer des problèmes)
      bool isGoogleDriveFile = image.path.contains('content://com.google.android.apps.docs');
      
      if (isGoogleDriveFile) {
        // Pour les fichiers Google Drive, on doit créer une copie locale
        try {
          final bytes = await image.readAsBytes();
          
          // Créer un fichier temporaire local
          final tempDir = await getTemporaryDirectory(); // Nécessite package 'path_provider'
          final String fileName = 'product_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final File localFile = File('${tempDir.path}/$fileName');
          
          // Écrire les données dans le fichier local
          await localFile.writeAsBytes(bytes);
          
          // Utiliser cette copie locale
          pickedFile.value = XFile(localFile.path);
          
          print('Image copiée depuis Google Drive####: ${localFile.path}');
        } catch (copyError) {
          print('Erreur lors de la copie du fichier Google Drive: $copyError');
          // Essayer d'utiliser directement le fichier
          pickedFile.value = image;
        }
      } else {
        // Fichier normal
        pickedFile.value = image;
      }
      
      // Vérifier si le fichier est accessible
      try {
        final File fileCheck = File(pickedFile.value!.path);
        final bool exists = await fileCheck.exists();
        final int size = await fileCheck.length();
        
        print('Chemin de l\'image################: ${pickedFile.value!.path}');
        print('Fichier existe: $exists, Taille: $size bytes');
        
        if (!exists || size <= 0) {
          throw Exception('Le fichier sélectionné n\'est pas accessible');
        }
      } catch (fileError) {
        print('Erreur lors de la vérification du fichier: $fileError');
      }
      
      Get.snackbar(
        'تم اختيار الصورة',
        'تم تحميل صورة المنتج بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    print('Erreur complète lors de la sélection d\'image: $e');
    Get.snackbar(
      'خطأ',
      'فشل في اختيار الصورة: ${e.toString()}',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

  Future<bool> toggleProductAvailability(Product product) async {
    final updatedProduct = Product.fromMap({
      ...product.toMap(),
      'disponible': !product.disponible,
    });

    final success = await updateProduct(updatedProduct);
    if (success) {
      Get.snackbar(
        'تم التحديث',
        'تم تغيير حالة المنتج',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } else {
      Get.snackbar(
        'فشل',
        'تعذر تحديث حالة المنتج',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  String formatDate(String date) {
    try {
      if (date == 'غير محدد') return date;
      final parsedDate = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd - HH:mm').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  void showConfirmDeleteDialog(Product product, Function onConfirm) {
    Get.dialog(
      AlertDialog(
        title: Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد أنك تريد حذف المنتج "${product.nom}"؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  bool isMaterielCategory() {
    
    final selected = categories.firstWhereOrNull(
      (cat) => cat['nom'] == selectedCategory.value,
    );
    return selected != null && selected['type'] == 'materiels';
  }
  // charger les produts par category 
  Future<void> loadProductsByCategory(int categoryId) async {
      print('Appel API pour la catégorie $categoryId');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
       try {
      final products = await _marcheService.getProductsByCategory(token, categoryId);
      print('API response products count: ${products.length}');
      productsByCategory.value = products;
    } catch (e) {
      print('Erreur lors du chargement des produits: $e');
    }
  } else {
    print('Token non trouvé');
  }
  }

}