import 'dart:io';
import 'package:bitakati_app/controllers/productController.dart';
import 'package:bitakati_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddProductPage extends StatefulWidget {
  final Product? product;

  AddProductPage({super.key}) : product = Get.arguments?['product'];

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final ProductController _controller = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _initializeFormWithProductData();
    } else {
      _clearForm(); // Ajouter cette ligne
    }
  }

  void _clearForm() {
    _controller.nameController.clear();
    _controller.priceController.clear();
    _controller.quantityController.clear();
    _controller.descriptionController.clear();
    _controller.selectedCategory.value = '';
    _controller.offerType.value = '';
    _controller.pickedFile.value = null;
  }

  void _initializeFormWithProductData() {
    _controller.nameController.text = widget.product!.nom;
    _controller.priceController.text = widget.product!.prix.toString();
    _controller.quantityController.text = (widget.product!.quantite % 1 == 0)
        ? widget.product!.quantite.toInt().toString()
        : widget.product!.quantite.toString();
    _controller.descriptionController.text = widget.product!.description;

    final categoryName = _controller.categories.firstWhere(
      (cat) =>
          cat['id'].toString() == widget.product!.category.toString() ||
          cat['nom'] == widget.product!.category,
      orElse: () => <String, dynamic>{},
    )['nom'];
    if (categoryName != null) {
      _controller.selectedCategory.value = categoryName;
    }

    if (widget.product != null && widget.product!.offerType != null) {
      _controller.offerType.value = widget.product!.offerType!;
    }
  }

  bool isMaterielCategory() {
    final selected = _controller.categories.firstWhereOrNull(
      (cat) => cat['nom'] == _controller.selectedCategory.value,
    );
    return selected != null && selected['type'] == 'materiels';
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.product != null;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            isEditing ? "تعديل المنتج" : "إضافة منتج جديد",
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.green[700],
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          actions: [
            TextButton(
              onPressed: () => isEditing
                  ? _controller.updateProduct(widget.product!)
                  : _controller.addProduct(),
              child: Text(
                isEditing ? "تعديل" : "حفظ",
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Section Image
                  _buildImageSection(),
                  const SizedBox(height: 30),

                  // Nom du produit
                  _buildTextField(
                    label: 'اسم المنتج',
                    hintText: 'أدخل اسم المنتج',
                    controller: _controller.nameController,
                    validator: (value) =>
                        value!.isEmpty ? 'الرجاء إدخال اسم المنتج' : null,
                  ),
                  const SizedBox(height: 20),

                  // Prix et Catégorie
                  Row(
                    children: [
                      // Prix
                      _buildPriceField(),
                      const SizedBox(width: 16),
                      // Catégorie
                      _buildCategoryDropdown(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (isMaterielCategory())
                    DropdownButtonFormField<String>(
                      value: _controller.offerType.value.isEmpty
                          ? null
                          : _controller.offerType.value,
                      items: [
                        DropdownMenuItem(value: 'vente', child: Text('للبيع')),
                        DropdownMenuItem(
                            value: 'location', child: Text('للإيجار')),
                      ],
                      onChanged: (value) {
                        if (value != null) _controller.offerType.value = value;
                      },
                      decoration: InputDecoration(labelText: 'نوع العرض'),
                    ),

                  // Quantité
                  _buildTextField(
                    label: 'الكمية',
                    hintText: '0',
                    suffixText: 'كغ',
                    controller: _controller.quantityController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value!.isEmpty) return 'الرجاء إدخال الكمية';
                      if (double.tryParse(value) == null)
                        return 'الرجاء إدخال كمية صحيحة';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Description
                  _buildTextField(
                    label: 'الوصف',
                    hintText: 'أدخل وصف المنتج...',
                    controller: _controller.descriptionController,
                    maxLines: 4,
                    isDescription: true,
                  ),
                  const SizedBox(height: 30),

                  // Bouton d'enregistrement
                  _buildSaveButton(context, isEditing),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return GestureDetector(
      onTap: _controller.pickImage,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          image: _buildBackgroundImage(),
        ),
        child: _showImagePlaceholder()
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      'اضغط لإضافة صورة',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }

// Méthode séparée pour déterminer l'image de fond
  DecorationImage? _buildBackgroundImage() {
    if (_controller.pickedFile.value != null) {
      // Affiche l'image sélectionnée depuis l'appareil
      return DecorationImage(
        image: FileImage(File(_controller.pickedFile.value!.path)),
        fit: BoxFit.cover,
      );
    } else if (widget.product != null && widget.product!.image.isNotEmpty) {
      // Affiche l'image existante du produit
      String imageUrl = _getCompleteImageUrl(widget.product!.image);
      print('URL d\'image du produit: $imageUrl');

      return DecorationImage(
        image: NetworkImage(imageUrl),
        fit: BoxFit.cover,
        onError: (exception, stackTrace) {
          print('Erreur de chargement d\'image: $exception');
        },
      );
    }
    return null;
  }

// Méthode pour déterminer s'il faut afficher le placeholder
  bool _showImagePlaceholder() {
    return _controller.pickedFile.value == null &&
        (widget.product == null || widget.product!.image.isEmpty);
  }

// Méthode pour construire l'URL complète de l'image
  String _getCompleteImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    } else {
      // Ajustez cette URL en fonction de votre backend
      return 'http://10.0.2.2:4000/uploads/$imagePath';
    }
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    String? suffixText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int? maxLines = 1,
    bool isDescription = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.9),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.cairo(),
              suffixText: suffixText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: isDescription ? 16 : 14,
              ),
            ),
            keyboardType: keyboardType,
            style: GoogleFonts.cairo(),
            textAlign: TextAlign.right,
            validator: validator,
            maxLines: maxLines,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceField() {
    return Expanded(
      child: _buildTextField(
        label: 'السعر',
        hintText: '0.00',
        suffixText: 'دينار ',
        controller: _controller.priceController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) return 'الرجاء إدخال السعر';
          if (double.tryParse(value) == null) return 'الرجاء إدخال سعر صحيح';
          return null;
        },
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'الفئة',
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.9),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonFormField<String>(
                value: _controller.selectedCategory.value.isEmpty
                    ? null
                    : _controller.selectedCategory.value,
                decoration: InputDecoration(
                  hintText: 'اختر الفئة',
                  hintStyle: GoogleFonts.cairo(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                items: _controller.categories.map((category) {
                  // Extract the name as String from the category map
                  final String categoryName = category['nom'] as String;
                  return DropdownMenuItem<String>(
                    value: categoryName,
                    child: Text(
                      categoryName,
                      style: GoogleFonts.cairo(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    _controller.selectedCategory.value = value;
                  }
                },
                validator: (value) =>
                    value == null ? 'الرجاء اختيار الفئة' : null,
                style: GoogleFonts.cairo(),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                dropdownColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, bool isEditing) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () async {
          if (_validateForm()) {
            // Ajouter cette validation
            if (isEditing) {
              final success = await _controller.updateProduct(widget.product!);
              if (success) {
                _clearForm(); // Nettoyer le formulaire
                Get.snackbar(
                'نجاح',
                'تم تعديل المنتج بنجاح',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
                            // Attendre un peu avant de fermer la page
              await Future.delayed(const Duration(milliseconds: 500));
              Navigator.of(context).pop(true);  // Utiliser Navigator.pop() au lieu de Get.back()
              }
            } else {
              final success = await _controller.addProduct();
              if (success) {
                _clearForm(); // Nettoyer le formulaire
                
                Get.snackbar(
                'نجاح',
                'تم إضافة المنتج بنجاح',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
              // Attendre un peu avant de fermer la page
              await Future.delayed(const Duration(milliseconds: 500));
              Navigator.of(context).pop(true);  // Utiliser Navigator.pop() au lieu de Get.back()
              }
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          isEditing ? 'تعديل المنتج' : 'حفظ المنتج',
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Ajouter cette méthode de validation
  bool _validateForm() {
    if (_controller.nameController.text.isEmpty) {
      Get.snackbar('خطأ', 'الرجاء إدخال اسم المنتج');
      return false;
    }
    if (_controller.selectedCategory.value.isEmpty) {
      Get.snackbar('خطأ', 'الرجاء اختيار الفئة');
      return false;
    }
    if (_controller.priceController.text.isEmpty) {
      Get.snackbar('خطأ', 'الرجاء إدخال السعر');
      return false;
    }
    if (_controller.quantityController.text.isEmpty) {
      Get.snackbar('خطأ', 'الرجاء إدخال الكمية');
      return false;
    }
    return true;
  }
}
