import 'package:flutter/material.dart';

class DiseasesPage extends StatelessWidget {
  const DiseasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أمراض النباتات'),
        backgroundColor: Colors.green[700],
      ),
      body: const Center(
        child: Text( 'محتوى الأمراض سيتم إضافته هنا'),
      ),
    );
  }
}
