import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiChangeRoleService {
  static const String _baseUrl = 'http://172.16.53.58:4000'; // Remplacez par votre URL réelle

  // Fonction pour envoyer une demande de changement de rôle
  Future<Map<String, dynamic>> requestRoleChange({
    required String token,
    required String requestedRole,
  }) async {
    final url = Uri.parse('$_baseUrl/api/role-change-request'); 
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'requested_role': requestedRole, // Correspond au nom dans votre API
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Demande envoyée avec succès',
          'request': responseData['request'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Erreur inconnue',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur réseau: ${e.toString()}',
      };
    }
  }
}