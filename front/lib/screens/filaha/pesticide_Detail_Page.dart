import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PesticideDetailPage extends StatelessWidget {
  final Map<String, String> pesticideData;

  const PesticideDetailPage({super.key, required this.pesticideData});

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(pesticideData['color'] ?? '0xFF4CAF50'));
    final isDangerous = pesticideData['type'] == 'chemical';
    final lightColor = color.withOpacity(0.1);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 280.0,
              pinned: true,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    pesticideData['name'] ?? 'تفاصيل المبيد',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                centerTitle: true,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: pesticideData['name'] ?? 'pesticide',
                      child: Image.asset(
                        pesticideData['image'] ?? 'images/pesticide_placeholder.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  color.withOpacity(0.8),
                                  color.withOpacity(0.4),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                isDangerous 
                                  ? Icons.warning_amber_rounded
                                  : Icons.eco,
                                size: 80,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: const [0.0, 0.3],
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: color,
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.share, color: Colors.white),
                  ),
                  onPressed: () {
                    // Implement share functionality
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: AnimationLimiter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 500),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(child: widget),
                      ),
                      children: [
                        const SizedBox(height: 16),
                        if (isDangerous) _buildDangerWarning(color),
                        _buildSectionTitle('معلومات عامة', color),
                        _buildModernInfoCard(
                          icon: Icons.info_outline_rounded,
                          content: pesticideData['description'] ?? 'لا يوجد وصف متوفر',
                          color: color,
                        ),
                        _buildSectionTitle('طريقة الاستخدام', color),
                        _buildModernInfoCard(
                          icon: Icons.grass_rounded,
                          content: pesticideData['usage'] ?? 'لم يتم توفير طريقة الاستخدام بعد.',
                          color: color,
                        ),
                        _buildSectionTitle('احتياطات الأمان', color),
                        _buildModernInfoCard(
                          icon: Icons.warning_rounded,
                          content: pesticideData['precautions'] ?? 'لم يتم توفير احتياطات الاستخدام بعد.',
                          color: Colors.redAccent,
                          isImportant: true,
                        ),
                        _buildSectionTitle('المحاصيل المستهدفة', color),
                        _buildModernInfoCard(
                          icon: Icons.agriculture_rounded,
                          content: pesticideData['target_crops'] ?? 'تنطبق على جميع المحاصيل',
                          color: color,
                        ),
                        const SizedBox(height: 24),
                        _buildModernActionButton(
                          context,
                          'جدول الرش الموصى به',
                          Icons.calendar_month_rounded,
                          color,
                        ),
                        const SizedBox(height: 12),
                        _buildModernActionButton(
                          context,
                          'حاسبة الكميات',
                          Icons.calculate_rounded,
                          color,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add to favorites functionality
        },
        backgroundColor: color,
        elevation: 4,
        child: const Icon(Icons.favorite_rounded, color: Colors.white),
      ),
    );

  }
  Widget _buildDangerWarning(Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[100]!, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.warning_rounded, color: Colors.red[800]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'تحذير: هذا مبيد كيميائي. يرجى اتباع إرشادات السلامة بدقة.',
              style: TextStyle(
                color: Colors.red[800],
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            height: 24,
            width: 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernInfoCard({
    required IconData icon,
    required String content,
    required Color color,
    bool isImportant = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isImportant ? Colors.red[50] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isImportant ? Colors.red[100]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isImportant 
                  ? Colors.red.withOpacity(0.1)
                  : color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 22,
                color: isImportant ? Colors.red : color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: isImportant ? Colors.red[800] : Colors.grey[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernActionButton(
      BuildContext context, String text, IconData icon, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          foregroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
        onPressed: () {
          // Implement button functionality
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}