import 'package:bitakati_app/models/newsModel.dart';
import 'package:bitakati_app/services/notificationServices.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'notification_detail_page.dart'; // Import de la page de détails

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future<List<News>> _futureActualites;
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy - HH:mm');

  @override
  void initState() {
    super.initState();
    _futureActualites = NotificationService().getNotifications();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _futureActualites = NotificationService().getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إشعارات', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green.shade700,
                Colors.green.shade500,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder<List<News>>(
          future: _futureActualites,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingIndicator();
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error.toString());
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState();
            }

            final actualites = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: actualites.length,
                itemBuilder: (context, index) => _buildNotificationCard(actualites[index], theme),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text('جاري تحميل الإشعارات...',
              style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text('حدث خطأ أثناء التحميل',
              style: TextStyle(fontSize: 18, color: Colors.red.shade400)),
          const SizedBox(height: 8),
          Text(error,
              style: TextStyle(color: Colors.grey.shade600), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
            onPressed: _refreshData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text('لا توجد إشعارات حالية',
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 8),
          TextButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('تحديث'),
            onPressed: _refreshData,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(News actu, ThemeData theme) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Action lorsqu'on clique sur une notification
          Get.to(() => NotificationDetailPage(message: actu.description));
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon with agricultural theme
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getNotificationIcon(actu.titre),
                  color: Colors.green.shade800,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      actu.titre,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      actu.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _dateFormat.format(actu.datePublication.toLocal()),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (actu.imageUrl != null) ...[
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    actu.imageUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String title) {
    if (title.contains('مطر') || title.contains('طقس')) {
      return Icons.cloud;
    } else if (title.contains('سقي') || title.contains('ري')) {
      return Icons.water_drop;
    } else if (title.contains('محصول') || title.contains('حصاد')) {
      return Icons.eco;
    } else if (title.contains('سوق') || title.contains('سعر')) {
      return Icons.attach_money;
    } else {
      return Icons.notifications;
    }
  }
}
