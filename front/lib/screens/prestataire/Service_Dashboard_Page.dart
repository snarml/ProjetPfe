import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceDashboardPage extends StatelessWidget {
  const ServiceDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'لوحة متابعة الخدمات',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[400],
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.green[400]!,
                Colors.teal[400]!,
              ],
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.r),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            // Header Stats
            _buildStatsHeader(),
            SizedBox(height: 20.h),
            // Services List
            Column(
              children: [
                _buildServiceCard(
                  context,
                  "خدمة تقليم الأشجار",
                  "في الانتظار",
                  Colors.orange,
                  Icons.access_time,
                  "25 مايو 2023",
                  "مزارع الواحة",
                ),
                _buildServiceCard(
                  context,
                  "خدمة رش المبيدات",
                  "مقبولة",
                  Colors.green,
                  Icons.check_circle,
                  "22 مايو 2023",
                  "شركة الحماية الزراعية",
                ),
                _buildServiceCard(
                  context,
                  "خدمة حرث الأرض",
                  "مرفوضة",
                  Colors.red,
                  Icons.cancel,
                  "20 مايو 2023",
                  "مزارع الواحة",
                ),
                _buildServiceCard(
                  context,
                  "خدمة جمع المحصول",
                  "تم التنفيذ",
                  Colors.blue,
                  Icons.done_all,
                  "15 مايو 2023",
                  "فريق الحصاد",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsHeader() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.pending_actions, "في الانتظار", 2, Colors.orange),
          _buildStatItem(Icons.check_circle, "مقبولة", 5, Colors.green),
          _buildStatItem(Icons.cancel, "مرفوضة", 1, Colors.red),
          _buildStatItem(Icons.done_all, "منفذة", 8, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String title, int count, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20.r, color: color),
        ),
        SizedBox(height: 4.h),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String service,
    String status,
    Color color,
    IconData statusIcon,
    String date,
    String provider,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 16.r, color: color),
                        SizedBox(width: 4.w),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                service,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 16.r, color: Colors.grey[600]),
                  SizedBox(width: 4.w),
                  Text(
                    provider,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Divider(height: 1.h, color: Colors.grey[200]),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      _showDetailsDialog(context, service, status, date, provider);
                    },
                    child: Text(
                      'التفاصيل',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.green[400],
                      ),
                    ),
                  ),
                  if (status == "في الانتظار")
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            _showCancelDialog(context, service);
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'إلغاء',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, String service, String status, String date, String provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تفاصيل الخدمة',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
                SizedBox(height: 16.h),
                _buildDetailRow('الخدمة:', service),
                _buildDetailRow('الحالة:', status),
                _buildDetailRow('التاريخ:', date),
                _buildDetailRow('مقدم الخدمة:', provider),
                SizedBox(height: 24.h),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'إغلاق',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.green[400],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, String service) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 48.r, color: Colors.green),
                SizedBox(height: 16.h),
                Text(
                  'تم الإلغاء بنجاح',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'تم إلغاء خدمة "$service" بنجاح',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    minimumSize: Size(double.infinity, 40.h),
                  ),
                  child: Text(
                    'حسناً',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}