import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class UserManagementServices {
  // L'URL de ton serveur backend
  static const String baseUrl = 'http://10.0.2.2:4000';
  // Function to edit user profile
  Future<Map<String, dynamic>> editProfile(
      String? fullName,
      String? numTel,
      String? ville,
      String? pays,
      String? oldPassword,
      String? newPassword,
      String? confirmPassword) async {
    // Récupérer le token de l'utilisateur depuis SharedPreferences ou un autre moyen
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.put(
      Uri.parse('$baseUrl/api/editProfile'),
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      },
      body: json.encode({
        'full_name': fullName,
        'num_tel': numTel,
        'ville': ville,
        'pays': pays,
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      }),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Si la réponse est réussie, on peut traiter les données
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to edit profile: ${response.body}');
    }
  }
}
