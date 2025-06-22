import 'package:bitakati_app/models/product_model.dart';
import 'package:bitakati_app/screens/addProductPage.dart';
import 'package:bitakati_app/services/marcheService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesTracking extends StatefulWidget {
  const SalesTracking({super.key});

  @override
  _SalesTrackingState createState() => _SalesTrackingState();
}

class _SalesTrackingState extends State<SalesTracking> {
  Future<List<Product>>? _productsFuture;
  final TextEditingController _searchController = TextEditingController();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  final MarcheService _marcheService = MarcheService();
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');

    setState(() {
      _productsFuture = _getProducts();
    });
  }

  Future<List<Product>> _getProducts() async {
    try {
      if (_token?.isNotEmpty ?? false) {
        final response = await _marcheService.getProducts(_token!);
        print('Réponse brute de l\'API: $response'); // Ajoute ce print

        final products = (response).map((p) => Product.fromMap(p)).toList();
        print('####################Produits après mapping: $products'); // Ajoute ce print

        _allProducts = products;
        _filteredProducts = products;
        return products;
      } else {
        throw Exception('Token non trouvé ou vide');
      }
    } catch (e) {
      print('Erreur dans _getProducts: $e'); // Ajoute ce print

      throw Exception('Erreur lors de la récupération: ${e.toString()}');
    }
  }

  Future<bool> _deleteProduct(String productId) async {
    try {
      if (_token?.isNotEmpty ?? false) {
        return await _marcheService.deleteProduct(_token!, productId);
      } else {
        throw Exception('Token non trouvé ou vide');
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression: ${e.toString()}');
    }
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
      _filteredProducts = _allProducts;
    } else {
      _filteredProducts = _allProducts.where((product) {
        return product.nom.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  });
  }

  void _confirmDelete(Product product) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد أنك تريد حذف المنتج "${product.nom}"؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await _deleteProduct(product.id);
        if (success == true) {
          Get.snackbar(
            'تم الحذف',
            'تم حذف المنتج "${product.nom}" بنجاح',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          _loadProducts();
        } else {
          throw Exception('Échec de la suppression');
        }
      } catch (e) {
        Get.snackbar(
          'خطأ',
          'فشل في حذف المنتج: ${e.toString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  String _formatDate(String date) {
    try {
      if (date == 'غير محدد') return date;
      final parsedDate = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd - HH:mm').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  String getImageUrl(String imageName) {
    if (imageName.startsWith('http')) return imageName;
    if (imageName.isEmpty) return 'https://via.placeholder.com/150';

    // Enlever '/uploads/' s'il est déjà présent
  final cleanImageName = imageName.replaceAll('/uploads/', '');
  
  // Construire l'URL correcte
  return 'http://10.0.2.2:4000/uploads/$cleanImageName';
  }

  void _showProductDetails(Product product) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child:  Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image du produit
                if (product.image.isNotEmpty)
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Image.network(
                          getImageUrl(product.image),
                          width: 160.w,
                          height: 160.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 16.h),
                Text(
                  product.nom,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  product.category ?? '',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 16.h),
                // Détails sous forme de cards
                _detailCard(Icons.attach_money, 'السعر', '${product.prix} دينار'),
                _detailCard(Icons.inventory_2, 'الكمية', product.quantite.toString()),
                if (product.description.isNotEmpty)
                  _detailCard(Icons.description, 'الوصف', product.description),
                _detailCard(Icons.check_circle,
                    'الحالة', product.disponible ? 'متاح' : 'غير متاح',
                    valueColor: product.disponible ? Colors.green : Colors.red),
                _detailCard(Icons.calendar_today, 'تاريخ الإنشاء', _formatDate(product.createdAt)),
                SizedBox(height: 24.h),
                // Bouton d'édition
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    icon: Icon(Icons.edit, color: Colors.white),
                    label: Text(
                      'تعديل المنتج',
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                    onPressed: () async {
                      Get.back();
                      final result = await Get.to(() => AddProductPage(), arguments: {'product': product});
                      if (result == true) {
                        _loadProducts();
                      }
                    },
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
            ),
            // Bouton de fermeture flottant
            Positioned(
              top: 0,
              left: 0,
              child: IconButton(
                icon: Icon(Icons.close, size: 28.sp, color: Colors.grey[700]),
                onPressed: () => Get.back(),
                tooltip: 'إغلاق',
              ),
            ),
            
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // Widget pour afficher un détail sous forme de card avec icône
  Widget _detailCard(IconData icon, String label, String value, {Color? valueColor}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700], size: 26.sp),
        title: Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            color: valueColor ?? Colors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        subtitle: Text(
          label,
          style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: true,
        title: Text(
          'متابعة عمليات البيع',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
          ),
        ),
        backgroundColor: Colors.green[400],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildSearchField(),
            SizedBox(height: 20.h),
            Expanded(
              child: _productsFuture == null
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => _loadProducts(),
                      child: FutureBuilder<List<Product>>(
                        future: _productsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('حدث خطأ: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              _filteredProducts.isEmpty) {
                            return Center(
                                child: Text('لا توجد منتجات متوفرة.'));
                          }
                          print('Produits affichés: ${_filteredProducts.length}');

                          return ListView.builder(
                            
                            itemCount: _filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = _filteredProducts[index];
                              return _buildSaleItem(product);
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filterProducts,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'ابحث عن عملية بيع...',
          hintStyle: TextStyle(fontSize: 14.sp),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, size: 20.sp),
                  onPressed: () {
                    _searchController.clear();
                    _filterProducts('');
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildSaleItem(Product product) {
    print('Affichage produit: ${product.nom}');
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => _showProductDetails(product),
        leading: product.image.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  getImageUrl(product.image),
                  width: 50.w,
                  height: 50.h,
                  fit: BoxFit.cover,
                ),
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _confirmDelete(product),
                  icon: Icon(Icons.delete, color: Colors.white, size: 16.sp),
                  label: Text('حذف',
                      style: TextStyle(fontSize: 14.sp, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                    
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    minimumSize: Size(0, 0),
                  ),
                ),
                Text(
                  '${product.prix} دينار ',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              product.nom,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              'الكمية: ${product.quantite}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 4.h,
          ),
          decoration: BoxDecoration(
            color: product.disponible ? Colors.green[50] : Colors.red[50],
            borderRadius: BorderRadius.circular(4.r)),
          
          child: Text(
            product.disponible ? 'متاح' : 'غير متاح',
            style: TextStyle(
              fontSize: 12.sp,
              color: product.disponible ? Colors.green[800] : Colors.red[800],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}