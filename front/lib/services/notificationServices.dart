import 'dart:convert';
import 'package:bitakati_app/models/newsModel.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static const String baseUrl = 'http://192.168.1.18:4000/api'; // adapte cette URL

  Future<List<News>> getNotifications() async {
    final response = await http.get(Uri.parse('$baseUrl/admin/actualites'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // Utilise News.fromJson pour créer une liste d'objets News
      return data.map((json) => News.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des notifications');
    }
  }
}
