import 'package:bitakati_app/screens/CartPage.dart';
import 'package:bitakati_app/screens/addProductPage.dart';
import 'package:bitakati_app/widgets/ProductItem.dart';
import 'package:bitakati_app/widgets/add_product_bottom.dart';
import 'package:bitakati_app/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product_model.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;
  String selectedCategory = 'الكل';
  String searchQuery = '';
  final ScrollController _scrollController = ScrollController();
  final ScrollController _categoryScrollController = ScrollController();

  final List<Product> produits = [
    Product(
      id: '1',
      nom: 'طماطم',
      prix: '2.50 د.ت',
      image: 'images/tomate.jpg',
      category: 'خضروات',
      checked: false,
    ),
    Product(
      id: '2',
      nom: 'ليمون',
      prix: '1.80 د.ت',
      image: 'images/lemon.jpeg',
      category: 'خضروات',
      checked: false,
    ),
    Product(
      id: '3',
      nom: 'سفنارية',
      prix: '3.00 د.ت',
      image: 'images/carotte.jpg',
      category: 'خضروات',
      checked: false,
    ),
    Product(
      id: '4',
      nom: 'تفاح',
      prix: '4.00 د.ت',
      image: 'images/apple.jpeg',
      category: 'فواكه',
      checked: false,
    ),
    Product(
      id: '5',
      nom: 'برتقال',
      prix: '3.50 د.ت',
      image: 'images/orange.jpeg',
      category: 'فواكه',
      checked: false,
    ),
    Product(
      id: '6',
      nom: 'موز',
      prix: '2.80 د.ت',
      image: 'images/banane.png',
      category: 'فواكه',
      checked: false,
    ),
    Product(
      id: '7',
      nom: 'قمح',
      prix: '1.50 د.ت',
      image: 'images/barley.jpeg',
      category: 'حبوب',
      checked: false,
    ),
    Product(
      id: '8',
      nom: 'شعير',
      prix: '1.20 د.ت',
      image: 'images/wheat.jpeg',
      category: 'حبوب',
      checked: false,
    ),
    Product(
      id: '9',
      nom: 'رز',
      prix: '1.80 د.ت',
      image: 'images/rice.jpeg',
      category: 'حبوب',
      checked: false,
    ),
    Product(
      id: '10',
      nom: 'أرض زراعية',
      prix: '5000.00 د.ت',
      image: 'images/land.jpeg',
      category: 'أراضي',
      checked: false,
    ),
    Product(
      id: '11',
      nom: 'أدوات زراعية',
      prix: '150.00 د.ت',
      image: 'images/tools.jpeg',
      category: 'أدوات مستعملة',
      checked: false,
    ),
    Product(
      id: '12',
      nom: 'معدات زراعية',
      prix: '200.00 د.ت',
      image: 'images/equipment.jpg',
      category: 'أدوات مستعملة',
      checked: false,
    ),
    Product(
      id: '13',
      nom: 'فواكه بحرية',
      prix: '15.00 د.ت',
      image: 'images/seafood.jpeg',
      category: 'الصيد البحري',
      checked: false,
    ),
    Product(
      id: '14',
      nom: 'أسماك',
      prix: '10.00 د.ت',
      image: 'images/fish.jpeg',
      category: 'الصيد البحري',
      checked: false,
    ),
  ];

  final List<List<String>> marketCategories = [
    ['الكل', 'الأدوية', 'مواد وأدوات زراعية', 'أدوات العناية والتنظيف', 'مواد جمع المحصول', 'أدوات تربية الماشية والأعلاف', 'أدوات ومعدات الصيد البحري'],
    ['الكل', 'خضروات', 'فواكه', 'حبوب', 'أراضي', 'الصيد البحري'],
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = _tabController.index;
        selectedCategory = 'الكل';
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _scrollController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  List<Product> get filteredProducts {
    return produits.where((product) {
      final matchesCategory = selectedCategory == 'الكل' || product.category == selectedCategory;
      final matchesSearch = product.nom.toLowerCase().contains(searchQuery.toLowerCase()) ||
          product.prix.contains(searchQuery);
      final matchesMarketType =
          _currentTabIndex == 0 ? _isSupplyProduct(product) : _isAgriculturalProduct(product);
      return matchesCategory && matchesSearch && matchesMarketType;
    }).toList();
  }

  bool _isSupplyProduct(Product product) => ['أدوات مستعملة', 'أراضي', 'الأدوية', 'مواد وأدوات زراعية', 'أدوات العناية والتنظيف', 'مواد جمع المحصول', 'أدوات تربية الماشية والأعلاف', 'أدوات ومعدات الصيد البحري'].contains(product.category);
  bool _isAgriculturalProduct(Product product) => ['خضروات', 'فواكه', 'حبوب', 'الصيد البحري'].contains(product.category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text('التسوق',
            style: GoogleFonts.cairo(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            icon: Badge(
              label: const Text('3', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.red,
              child: const Icon(Icons.shopping_cart, color: Colors.white),
            ),
            onPressed: () => Get.to(() => const CartPage()),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.green[700],
              indicatorWeight: 3,
              labelColor: Colors.green[700],
              unselectedLabelColor: Colors.grey,
              labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'المواد، الّوازم و المعدات'),
                Tab(text: 'المنتوج الفلاحي و البحري'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: AddProductButton(
              onPressed: () => Get.to(() => const AddProductPage()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Searchbar(
              
            ),
          ),
          SizedBox(
            height: 60,
            child: ListView.builder(
              controller: _categoryScrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: (_currentTabIndex < marketCategories.length) ? marketCategories[_currentTabIndex].length: 0,
              itemBuilder: (context, index) {
                final category = marketCategories[_currentTabIndex][index];
                final isSelected = category == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.green[700],
                      ),
                    ),
                    selected: isSelected,
                    backgroundColor: Colors.white,
                    selectedColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.green[700]!),
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(), // Prevent swiping between tabs
              children: [
                _buildProductsView(),
                _buildProductsView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsView() {
    return RefreshIndicator(
      onRefresh: () async => setState(() {}),
      child: filteredProducts.isEmpty
          ? Center(
              child: Text(
                'لا توجد منتجات متاحة',
                style: GoogleFonts.cairo(fontSize: 18),
              ),
            )
          : GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductItem(
                  product: filteredProducts[index],
                  onChanged: (val) => _handleProductSelection(filteredProducts[index], val),
                  id: product.id,
                  nom: product.nom,
                  prix: product.prix,
                  imagePath: product.image,
                  isChecked: product.checked,
                );
              },
            ),
    );
  }

  void _handleProductSelection(Product product, bool? value) {
    setState(() => product.checked = value ?? false);
    if (value == true) {
      Get.snackbar(
        'تمت الإضافة',
        'تم إضافة ${product.nom} إلى السلة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    }
  }
}