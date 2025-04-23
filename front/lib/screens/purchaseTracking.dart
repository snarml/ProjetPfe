import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PurchasesTracking extends StatelessWidget {
  const PurchasesTracking({super.key});

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
          'متابعة عمليات الشراء',
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
            _buildFilterChips(),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => _buildPurchaseItem(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['الكل', 'هذا الشهر', 'الأسبوع', 'اليوم'];
    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(left: 8.w),
            child: FilterChip(
              label: Text(filters[index]),
              selected: index == 0,
              onSelected: (bool selected) {},
              selectedColor: Colors.green[300],
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: index == 0 ? Colors.white : Colors.black,
                fontSize: 12.sp,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPurchaseItem(int index) {
    final products = ['بذور طماطم', 'أسمدة', 'مبيدات', 'أدوات زراعية', 'ري'];
    final prices = ['200 دج', '1500 دج', '800 دج', '2500 دج', '1200 دج'];
    final statuses = ['مكتمل', 'قيد التوصيل', 'ملغى', 'مكتمل', 'قيد التوصيل'];
    final statusColors = [
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.green,
      Colors.orange
    ];

    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(12.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.arrow_back_ios, size: 16.sp, color: Colors.grey),
              Text(
                products[index],
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColors[index].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  statuses[index],
                  style: TextStyle(
                    color: statusColors[index],
                    fontSize: 12.sp,
                  ),
                ),
              ),
              Text(
                prices[index],
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}