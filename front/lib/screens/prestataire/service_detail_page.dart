import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class ServiceDetailPage extends StatefulWidget {
  final String serviceName;
  final double price;
  final String serviceProvider;
  final Color categoryColor;

  const ServiceDetailPage({
    super.key,
    required this.serviceName,
    required this.price,
    required this.serviceProvider,
    required this.categoryColor,
  });

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _quantity = 1;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'تفاصيل الخدمة',
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
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
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
                  child: Image.network(
                    _getServiceImage(widget.serviceName),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
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
                    widget.serviceName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${widget.price} د.ت',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                        fontFamily: 'Tajawal',
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '(42 تقييم) 4.7',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const Icon(Icons.star_half, color: Colors.amber, size: 20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'المزود',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.serviceProvider,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.verified_user, color: Colors.blue, size: 20),
                    ],
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
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getServiceDescription(widget.serviceName),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontFamily: 'Tajawal',
                      height: 1.5,
                    ),
                    textAlign: TextAlign.right,
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
                    'التعريفة',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 12),
                  _buildPriceRow('السعر الأساسي', '${widget.price} د.ت'),
                  _buildPriceRow('ضريبة (19%)', '${widget.price * 0.19} د.ت'),
                  const Divider(height: 24),
                  _buildPriceRow(
                    'المجموع',
                    '${widget.price * 1.19} د.ت',
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  String _getServiceImage(String serviceName) {
    if (serviceName.toLowerCase().contains('إرشاد')) {
      return 'https://example.com/agriculture.jpg';
    } else if (serviceName.toLowerCase().contains('تحليل')) {
      return 'https://example.com/lab.jpg';
    } else {
      return 'https://via.placeholder.com/400x300';
    }
  }

  String _getServiceDescription(String serviceName) {
    if (serviceName.toLowerCase().contains('إرشاد')) {
      return 'خدمات الإرشاد الفلاحي المتكاملة مع خبراء في المجال. نقدم دراسات جدوى وتخطيط للمشاريع الفلاحية مع متابعة دورية.';
    } else if (serviceName.toLowerCase().contains('تحليل')) {
      return 'مختبرات متخصصة في تحليل التربة والمياه والمحاصيل. نتائج دقيقة مع تقارير تفصيلية تساعد في تحسين الإنتاجية.';
    } else {
      return 'خدمة احترافية مع ضمان الجودة. فريق عمل مؤهل وذو خبرة في المجال الفلاحي.';
    }
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green : Colors.grey[700],
              fontFamily: 'Tajawal',
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green : Colors.grey[700],
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
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
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.categoryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () => _showBookingDialog(context),
              child: const Text(
                'حجز الخدمة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  color: Colors.white,
                ),
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
                  onPressed: () {
                    if (_quantity > 1) {
                      setState(() {
                        _quantity--;
                      });
                    }
                  },
                ),
                Text('$_quantity', style: const TextStyle(fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _quantity++;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'حجز الخدمة',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('الرجاء اختيار تاريخ ووقت التدخل', 
                  style: TextStyle(fontSize: 16, fontFamily: 'Tajawal')),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_selectedDate != null
                      ? DateFormat.yMd().format(_selectedDate!)
                      : 'اختر التاريخ',
                    style: const TextStyle(fontFamily: 'Tajawal')),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _selectTime(context),
                  icon: const Icon(Icons.access_time),
                  label: Text(_selectedTime != null
                      ? _selectedTime!.format(context)
                      : 'اختر الوقت',
                    style: const TextStyle(fontFamily: 'Tajawal')),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Get.snackbar(
                  'تم الحجز',
                  'تم حجز الخدمة بنجاح',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: widget.categoryColor,
                  colorText: Colors.white,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.categoryColor,
              ),
              child: const Text('تأكيد', style: TextStyle(fontFamily: 'Tajawal')),
            ),
          ],
        );
      },
    );
  }
}