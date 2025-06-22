import 'package:bitakati_app/controllers/productController.dart';
import 'package:bitakati_app/screens/CartPage.dart';
import 'package:bitakati_app/screens/addProductPage.dart';
import 'package:bitakati_app/widgets/ProductItem.dart';
import 'package:bitakati_app/widgets/add_product_bottom.dart';
import 'package:bitakati_app/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product_model.dart';

enum SortOption {
  recent,    // Plus récent
  priceLow,  // Prix croissant
  priceHigh, // Prix décroissant
  name       // Ordre alphabétique
}

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;
  String selectedCategory = 'الكل';
  String searchQuery = '';
  final ScrollController _scrollController = ScrollController();
  final ScrollController _categoryScrollController = ScrollController();
  final ProductController _productController = Get.put(ProductController());
  SortOption currentSortOption = SortOption.recent;
  RangeValues _priceRange = const RangeValues(0, 1000);
  bool _availableOnly = false;

  final List<List<String>> marketCategories = [
    [
      'الكل',
      'أدوات مستعملة',
      'أراضي',
      'الأدوية',
      'الأسمدة',
      'مواد وأدوات زراعية',
      'أدوات العناية والتنظيف',
      'مواد جمع المحصول',
      'أدوات تربية الماشية والأعلاف',
      'أدوات ومعدات الصيد البحري'
    ],
    ['الكل', 'خضروات', 'فواكه', 'حبوب', 'الصيد البحري', 'الماشية'],
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadProducts();
  }

  // Charger tous les produits au démarrage
  Future<void> _loadProducts() async {
    await _productController.loadProducts();
    print('Produits chargés (allProducts): ${_productController.allProducts.length}');
    for (var p in _productController.allProducts) {
      print('Produit: id=${p.id}, nom=${p.nom}, categorie_id=${p.categoryId}, category=${p.category}');
    }
    setState(() {});
  }

  // Charger les produits d'une catégorie spécifique
  Future<void> _loadProductsForCategory(String categoryName) async {
    int? categoryId = _getCategoryIdByName(categoryName);
    
    if (categoryName == 'الكل') {
      // Pour "Tous", on charge tous les produits mais on applique le filtre par type de marché
      await _productController.loadProducts();
    } else if (categoryId != null) {
      // Pour une catégorie spécifique
      await _productController.loadProductsByCategory(categoryId);
    }
    
    setState(() {}); // Rafraîchir l'interface
  }

  int? _getCategoryIdByName(String categoryName) {
    final categories = [
      {'id': 1, 'nom': 'خضروات', 'type': 'produits'},
      {'id': 2, 'nom': 'فواكه', 'type': 'produits'},
      {'id': 3, 'nom': 'حبوب', 'type': 'produits'},
      {'id': 4, 'nom': 'الصيد البحري', 'type': 'produits'},
      {'id': 5, 'nom': 'الماشية', 'type': 'produits'},
      {'id': 6, 'nom': 'أدوات مستعملة', 'type': 'materiels'},
      {'id': 7, 'nom': 'أراضي', 'type': 'materiels'},
      {'id': 8, 'nom': 'الأدوية', 'type': 'materiels'},
      {'id': 9, 'nom': 'الأسمدة', 'type': 'materiels'},
      {'id': 10, 'nom': 'مواد وأدوات زراعية', 'type': 'materiels'},
      {'id': 11, 'nom': 'أدوات العناية والتنظيف', 'type': 'materiels'},
      {'id': 12, 'nom': 'مواد جمع المحصول', 'type': 'materiels'},
      {'id': 13, 'nom': 'أدوات تربية الماشية والأعلاف', 'type': 'materiels'},
      {'id': 14, 'nom': 'أدوات ومعدات الصيد البحري', 'type': 'materiels'},
    ];
    final found =
        categories.firstWhereOrNull((cat) => cat['nom'] == categoryName);
    return found != null ? found['id'] as int : null;
  }

  String? _getCategoryNameById(int id) {
    final categories = [
      {'id': 1, 'nom': 'خضروات'},
      {'id': 2, 'nom': 'فواكه'},
      {'id': 3, 'nom': 'حبوب'},
      {'id': 4, 'nom': 'الصيد البحري'},
      {'id': 5, 'nom': 'الماشية'},
      {'id': 6, 'nom': 'أدوات مستعملة'},
      {'id': 7, 'nom': 'أراضي'},
      {'id': 8, 'nom': 'الأدوية'},
      {'id': 9, 'nom': 'الأسمدة'},
      {'id': 10, 'nom': 'مواد وأدوات زراعية'},
      {'id': 11, 'nom': 'أدوات العناية والتنظيف'},
      {'id': 12, 'nom': 'مواد جمع المحصول'},
      {'id': 13, 'nom': 'أدوات تربية الماشية والأعلاف'},
      {'id': 14, 'nom': 'أدوات ومعدات الصيد البحري'},
    ];
    final found = categories.firstWhereOrNull((cat) => cat['id'] == id);
    return found != null ? found['nom'] as String : null;
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = _tabController.index;
        selectedCategory = 'الكل';
      });

      _loadProducts(); // Recharger les produits quand on change d'onglet

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
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

  // Correction principale ici - cette méthode filtre correctement les produits
List<Product> get filteredProducts {
    return _productController.allProducts.where((product) {
      // 1. Filtre par type de marché (onglet)
      final matchesMarketType = _currentTabIndex == 0
          ? _isSupplyProduct(product)
          : _isAgriculturalProduct(product);

      // 2. Filtre par catégorie
      final matchesCategory = selectedCategory == 'الكل' ||
          _getCategoryNameById(product.categoryId) == selectedCategory;

      // 3. Filtre par recherche
      final matchesSearch = searchQuery.isEmpty ||
          product.nom.toLowerCase().contains(searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
          _getCategoryNameById(product.categoryId)!.toLowerCase().contains(searchQuery.toLowerCase());

      // 4. Filtre par prix
      final matchesPrice = product.prix >= _priceRange.start && 
                          product.prix <= _priceRange.end;

      // 5. Filtre par disponibilité
      final matchesAvailability = !_availableOnly || product.disponible;

      return matchesMarketType && 
             matchesCategory && 
             matchesSearch && 
             matchesPrice && 
             matchesAvailability;
    }).toList()..sort((a, b) {
      // Tri des résultats
      switch (currentSortOption) {
        case SortOption.recent:
          return b.id.compareTo(a.id);
        case SortOption.priceLow:
          return a.prix.compareTo(b.prix);
        case SortOption.priceHigh:
          return b.prix.compareTo(a.prix);
        case SortOption.name:
          return a.nom.compareTo(b.nom);
      }
    });
  }
  void _showFilterDialog() {
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setStateDialog) => AlertDialog(
        title: Text('فلترة المنتجات', style: GoogleFonts.cairo()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Prix
            Text('نطاق السعر', style: GoogleFonts.cairo()),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: 12000,
              divisions: 20,
              labels: RangeLabels(
                '${_priceRange.start.round()} د.ت',
                '${_priceRange.end.round()} د.ت',
              ),
              onChanged: (RangeValues values) {
                setStateDialog(() => _priceRange = values);
              },
            ),
            
            // Disponibilité
            CheckboxListTile(
              title: Text('المنتجات المتوفرة فقط', style: GoogleFonts.cairo()),
              value: _availableOnly,
              onChanged: (bool? value) {
                setStateDialog(() => _availableOnly = value ?? false);
              },
            ),

            // Tri
            DropdownButtonFormField<SortOption>(
              value: currentSortOption,
              items: [
                DropdownMenuItem(
                  value: SortOption.recent,
                  child: Text('الأحدث', style: GoogleFonts.cairo()),
                ),
                DropdownMenuItem(
                  value: SortOption.priceLow,
                  child: Text('السعر: من الأقل إلى الأعلى', style: GoogleFonts.cairo()),
                ),
                DropdownMenuItem(
                  value: SortOption.priceHigh,
                  child: Text('السعر: من الأعلى إلى الأقل', style: GoogleFonts.cairo()),
                ),
                DropdownMenuItem(
                  value: SortOption.name,
                  child: Text('الترتيب الأبجدي', style: GoogleFonts.cairo()),
                ),
              ],
              onChanged: (value) {
                setStateDialog(() => currentSortOption = value ?? SortOption.recent);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {}); // Rafraîchir la liste
              Navigator.pop(context);
            },
            child: Text('تطبيق', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    ),
  );
}

  bool _isSupplyProduct(Product product) => [
        'أدوات مستعملة',
        'أراضي',
        'الأدوية',
        'الأسمدة',
        'مواد وأدوات زراعية',
        'أدوات العناية والتنظيف',
        'مواد جمع المحصول',
        'أدوات تربية الماشية والأعلاف',
        'أدوات ومعدات الصيد البحري'
      ].contains(product.category);

  bool _isAgriculturalProduct(Product product) => [
        'خضروات',
        'فواكه',
        'حبوب',
        'الصيد البحري',
        'الماشية'
      ].contains(product.category);

  void _updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

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
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
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
              onPressed: () => Get.to(() => AddProductPage()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Searchbar(
              onSearchChanged: _updateSearchQuery,
              onFilterPressed: _showFilterDialog,
            ),
          ),
          SizedBox(
            height: 60,
            child: ListView.builder(
              controller: _categoryScrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: marketCategories[_currentTabIndex].length,
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
                        _loadProductsForCategory(category);
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
    return Obx(() {
      final displayProducts = filteredProducts;
      print('Affichage de ${displayProducts.length} produits');
      
      return RefreshIndicator(
        onRefresh: _loadProducts,
        child: displayProducts.isEmpty
            ? ListView(
                children: [
                  SizedBox(height: 150),
                  Center(
                    child: Text(
                      'لا توجد منتجات متاحة',
                      style: GoogleFonts.cairo(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                ],
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
                itemCount: displayProducts.length,
                itemBuilder: (context, index) {
                  final product = displayProducts[index];
                  return ProductItem(
                    id: product.id,
                    nom: product.nom,
                    prix: product.prix.toString(),
                    imagePath: product.image,
                    isChecked: product.checked,
                    onChanged: (value) => _handleProductSelection(product, value),
                    product: product,
                  );
                },
              ),
      );
    });
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