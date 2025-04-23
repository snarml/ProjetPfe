import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InteractionHistory extends StatelessWidget {
  const InteractionHistory({super.key});

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
          'سجل التفاعل مع المساعد الذكي',
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
            _buildDateSelector(),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) => _buildInteractionItem(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.calendar_today, size: 20.sp, color: Colors.green),
        Text(
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
        Text(
          'حدد التاريخ:',
          style: TextStyle(fontSize: 14.sp),
        ),
      ],
    );
  }

  Widget _buildInteractionItem(int index) {
    final questions = [
      'ما هو أفضل وقت لزراعة الطماطم؟',
      'كيف أتعامل مع آفات البطاطس؟',
      'ما هي كمية الماء اللازمة للفلفل؟',
      'أفضل أنواع الأسمدة للبصل',
      'كيف أحفظ المحصول بعد الحصاد؟'
    ];
    final dates = ['10:30 ص', 'أمس 3:45 م', '12/06 8:20 ص', '10/06 5:15 م', '08/06 11:30 ص'];

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
            offset: Offset(0, 2),),
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
                dates[index % dates.length],
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            questions[index % questions.length],
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'عرض التفاصيل',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(width: 4.w),
              Icon(Icons.remove_red_eye, size: 16.sp, color: Colors.green[800]),
            ],
          ),
        ],
      ),
    );
  }
}