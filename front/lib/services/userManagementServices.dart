import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserManagementServices {
  static const String baseUrl = 'http://172.16.53.58:4000';

  Future<Map<String, dynamic>> editProfile(
    String? fullName,
    String? numTel,
    String? ville,
    String? pays,
    String? oldPassword,
    String? newPassword,
    String? confirmPassword,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    // Crée dynamiquement un body sans les champs null ou vides
    final Map<String, dynamic> requestBody = {};
    if (fullName != null && fullName.trim().isNotEmpty)
      requestBody['full_name'] = fullName;
    if (numTel != null && numTel.trim().isNotEmpty)
      requestBody['num_tel'] = numTel;
    if (ville != null && ville.trim().isNotEmpty) requestBody['ville'] = ville;
    if (pays != null && pays.trim().isNotEmpty) requestBody['pays'] = pays;
    if (oldPassword != null && oldPassword.trim().isNotEmpty)
      requestBody['old_password'] = oldPassword;
    if (newPassword != null && newPassword.trim().isNotEmpty)
      requestBody['new_password'] = newPassword;
    if (confirmPassword != null && confirmPassword.trim().isNotEmpty)
      requestBody['confirm_password'] = confirmPassword;

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/editProfile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // recharger les nouvelles données après update
        return jsonDecode( response.body);
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message':
              error['message'] ?? 'Erreur lors de la mise à jour du profil.'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur réseau ou serveur: ${e.toString()}',
      };
    }
  }
}
