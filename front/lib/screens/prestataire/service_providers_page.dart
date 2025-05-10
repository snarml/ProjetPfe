import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'service_detail_page.dart';

class ServiceProvidersPage extends StatefulWidget {
  final String categoryName;
  final IconData categoryIcon;
  final Color categoryColor;

  const ServiceProvidersPage({
    super.key,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
  });

  @override
  State<ServiceProvidersPage> createState() => _ServiceProvidersPageState();
}

class _ServiceProvidersPageState extends State<ServiceProvidersPage> {
  final List<String> tunisianCities = [
    'تونس', 'صفاقس', 'سوسة', 'نابل', 'بنزرت',
    'قابس', 'أريانة', 'المنستير', 'المهدية', 'القيروان'
  ];
  
  final List<ServiceData> _allServices = [];
  List<ServiceData> _filteredServices = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedLocation = 'الكل';
  String _selectedPriceRange = 'الكل';
  String _selectedDistance = 'الأقرب';

  @override
  void initState() {
    super.initState();
    // Générer des données de service fictives
    for (int i = 0; i < 20; i++) {
      _allServices.add(_generateServiceData(i));
    }
    _filteredServices = _allServices;
    _searchController.addListener(_filterServices);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterServices() {
    setState(() {
      _filteredServices = _allServices.where((service) {
        final searchLower = _searchController.text.toLowerCase();
        final matchesSearch = service.title.toLowerCase().contains(searchLower) || 
                            service.description.toLowerCase().contains(searchLower);
        
        final matchesLocation = _selectedLocation == 'الكل' || 
                              service.location == _selectedLocation;
        
        final matchesPrice = _selectedPriceRange == 'الكل' ||
            (_selectedPriceRange == '< 50 د.ت' && service.price < 50) ||
            (_selectedPriceRange == '50 - 100 د.ت' && service.price >= 50 && service.price <= 100) ||
            (_selectedPriceRange == '> 100 د.ت' && service.price > 100);
        
        return matchesSearch && matchesLocation && matchesPrice;
      }).toList();
      
      // Trier par distance si sélectionné
      if (_selectedDistance == 'الأقرب') {
        _filteredServices.sort((a, b) => a.distance.compareTo(b.distance));
      } else if (_selectedDistance == 'الأبعد') {
        _filteredServices.sort((a, b) => b.distance.compareTo(a.distance));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      floatingActionButton: _buildFloatingActionButton(context),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(
            child: _buildServiceList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'ابحث عن خدمة...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: widget.categoryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: widget.categoryColor, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildLocationFilter(),
          const SizedBox(width: 8),
          _buildPriceFilter(),
          const SizedBox(width: 8),
          _buildDistanceFilter(),
        ],
      ),
    );
  }

  Widget _buildLocationFilter() {
    return FilterChip(
      label: Text(_selectedLocation),
      selected: _selectedLocation != 'الكل',
      onSelected: (_) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('اختر الولاية', style: TextStyle(fontSize: 18)),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: const Text('الكل'),
                        onTap: () {
                          setState(() => _selectedLocation = 'الكل');
                          _filterServices();
                          Navigator.pop(context);
                        },
                      ),
                      ...tunisianCities.map((city) => ListTile(
                        title: Text(city),
                        onTap: () {
                          setState(() => _selectedLocation = city);
                          _filterServices();
                          Navigator.pop(context);
                        },
                      )).toList(),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
      selectedColor: widget.categoryColor.withOpacity(0.2),
      checkmarkColor: widget.categoryColor,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: _selectedLocation != 'الكل' ? widget.categoryColor : Colors.black,
      ),
    );
  }
  Widget _buildPriceFilter() {
    return FilterChip(
      label: Text(_selectedPriceRange),
      selected: _selectedPriceRange != 'الكل',
      onSelected: (_) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('اختر نطاق السعر', style: TextStyle(fontSize: 18)),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: const Text('الكل'),
                        onTap: () {
                          setState(() => _selectedPriceRange = 'الكل');
                          _filterServices();
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('< 50 د.ت'),
                        onTap: () {
                          setState(() => _selectedPriceRange = '< 50 د.ت');
                          _filterServices();
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('50 - 100 د.ت'),
                        onTap: () {
                          setState(() => _selectedPriceRange = '50 - 100 د.ت');
                          _filterServices();
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('> 100 د.ت'),
                        onTap: () {
                          setState(() => _selectedPriceRange = '> 100 د.ت');
                          _filterServices();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
      selectedColor: widget.categoryColor.withOpacity(0.2),
      checkmarkColor: widget.categoryColor,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: _selectedPriceRange != 'الكل' ? widget.categoryColor : Colors.black,
      ),
    );
  }
  Widget _buildDistanceFilter() {
    return FilterChip(
      label: Text(_selectedDistance),
      selected: true,
      onSelected: (selected) {
        setState(() {
          _selectedDistance = _selectedDistance == 'الأقرب' ? 'الأبعد' : 'الأقرب';
          _filterServices();
        });
      },
      selectedColor: widget.categoryColor.withOpacity(0.2),
      checkmarkColor: widget.categoryColor,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: widget.categoryColor,
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        widget.categoryName,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: widget.categoryColor,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showPrivateServiceDialog(context),
      backgroundColor: widget.categoryColor,
      elevation: 4,
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }

  Widget _buildServiceList() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            widget.categoryColor.withOpacity(0.1),
            Colors.grey[50]!,
          ],
        ),
      ),
      child: _filteredServices.isEmpty
          ? const Center(child: Text('لا توجد خدمات متطابقة مع بحثك'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredServices.length,
              itemBuilder: (context, index) => _buildServiceCard(context, index),
            ),
    );
  }

  Widget _buildServiceCard(BuildContext context, int index) {
    final service = _filteredServices[index];

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToDetail(context, service),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildCardHeader(service),
              const SizedBox(height: 12),
              _buildServiceInfo(service),
              const SizedBox(height: 12),
              _buildServiceFooter(service),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader(ServiceData service) {
    return Row(
      children: [
        if (service.isPromo) _buildPromoBadge(),
        const Spacer(),
        Text(
          '${service.price} د.ت',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: widget.categoryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceInfo(ServiceData service) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: widget.categoryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(widget.categoryIcon, size: 30, color: widget.categoryColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                service.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceFooter(ServiceData service) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 18),
            Text(' ${service.rating.toStringAsFixed(1)}'),
            const Spacer(),
            Icon(Icons.location_on, color: Colors.grey[600], size: 18),
            Text(' ${service.location}'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.directions_car, color: Colors.grey[600], size: 18),
            Text(' ${service.distance.toStringAsFixed(1)} كم'),
          ],
        ),
      ],
    );
  }

  Widget _buildPromoBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.red[400],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'تخفيض',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, ServiceData service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailPage(
          serviceName: service.title,
          price: service.price,
          serviceProvider: 'حريف ${service.id}',
          categoryColor: widget.categoryColor,
        ),
      ),
    );
  }

  ServiceData _generateServiceData(int index) {
    return ServiceData(
      id: index + 1,
      title: '${_getServiceType(index)} ${index + 1}',
      description: _getServiceDescription(index),
      price: 30.0 + (index * 7),
      rating: 4.0 + (index * 0.1),
      location: tunisianCities[index % tunisianCities.length],
      isPromo: index % 3 == 0,
      distance: 1.0 + (index * 0.5), // Distance en km
    );
  }

  String _getServiceType(int index) {
    final types = {
      'الإرشاد و الدراسات الفلاحية': ['إرشاد', 'دراسة', 'تحليل'],
      'المخابر و التحاليل': ['تحليل', 'فحص', 'تقرير'],
      'التركيب و الصيانة': ['تركيب', 'صيانة', 'إصلاح'],
      'الكراء و المعدات': ['كراء', 'معدات', 'آلات'],
      'التوصيل': ['توصيل', 'شحن', 'نقل'],
      'اليد العاملة الفلاحية': ['عامل', 'فني', 'مساعد'],
      'الطاقة، البيئة و الموارد المائية': ['طاقة', 'بيئة', 'مياه'],
      'الطب البيطري و تربية الحيوانات': ['علاج', 'رعاية', 'فحص'],
    };
    return types[widget.categoryName]?[index % 3] ?? 'خدمة';
  }

  String _getServiceDescription(int index) {
    return 'خدمة ${widget.categoryName} محترفة مع ضمان. متوفرة في كامل تراب الجمهورية.';
  }

  void _showPrivateServiceDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();
    final dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'طلب خدمة خاصة',
          style: TextStyle(
            color: widget.categoryColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'فسّر خدمتك باش المهنيين ينجموا يجاوبوك',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                _buildDescriptionField(descriptionController),
                const SizedBox(height: 16),
                _buildLocationField(locationController),
                const SizedBox(height: 16),
                _buildDateField(dateController, context),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => _submitRequest(context, formKey),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.categoryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('إرسال', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'التفاصيل',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.categoryColor),
        ),
      ),
      maxLines: 3,
      validator: (value) => value!.isEmpty ? 'مطلوب' : null,
    );
  }

  Widget _buildLocationField(TextEditingController controller) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'الولاية',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.categoryColor),
        ),
      ),
      items: tunisianCities.map((city) {
        return DropdownMenuItem(
          value: city,
          child: Text(city),
        );
      }).toList(),
      onChanged: (value) => controller.text = value!,
      validator: (value) => value == null ? 'اختار الولاية' : null,
    );
  }

  Widget _buildDateField(TextEditingController controller, BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'نهار الخدمة',
        suffixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.categoryColor),
        ),
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          locale: const Locale('ar', 'TN'),
        );
        if (date != null) {
          controller.text = DateFormat('dd/MM/yyyy').format(date);
        }
      },
      validator: (value) => value!.isEmpty ? 'مطلوب' : null,
    );
  }

  void _submitRequest(BuildContext context, GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('طلبك تبعث للمهنيين في ${widget.categoryName}...'),
        ),
      );
    }
  }
}

class ServiceData {
  final int id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final String location;
  final bool isPromo;
  final double distance;

  ServiceData({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.location,
    required this.isPromo,
    required this.distance,
  });
}