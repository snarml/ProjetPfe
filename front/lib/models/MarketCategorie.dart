import 'package:flutter/material.dart';

const List<Map<String, dynamic>> supplyCategories = [
  {
    'id': 'sup1',
    'name': 'أدوية ومواد زراعية',
    'icon': Icons.medical_services,
    'subcategories': ['مبيدات', 'أسمدة', 'منشطات نمو']
  },
  // ... autres catégories fournitures
];

const List<Map<String, dynamic>> productCategories = [
  {
    'id': 'prod1',
    'name': 'خضروات وفواكه',
    'icon': Icons.spa,
    'subcategories': ['طماطم', 'بطاطس', 'حمضيات']
  },
  // ... autres catégories produits
];