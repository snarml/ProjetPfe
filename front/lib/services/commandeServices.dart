import 'dart:convert';
import 'package:http/http.dart' as http;
class CommandeService {
  // L'URL de ton serveur backend
  static const String baseUrl = 'http://10.0.2.2:4000';
// Ajouter une commande
Future<Map<String, dynamic>> passerCommande(int userId, String token) async {
  final url = Uri.parse('$baseUrl/api/passer-commande');
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'user_id': userId}),
  );
  return json.decode(response.body);
}

// Récupérer les commandes d'un utilisateur
Future<List<dynamic>> getCommandesUtilisateur(int userId, String token) async {
  final url = Uri.parse('$baseUrl/api/commandes-produits/$userId');
  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $token'},
  );
  return json.decode(response.body);
}

// Annuler une commande
Future<Map<String, dynamic>> annulerCommande(int commandeId, String token) async {
  final url = Uri.parse('$baseUrl/api/annuler-commande/$commandeId');
  final response = await http.delete(
    url,
    headers: {'Authorization': 'Bearer $token'},
  );
  return json.decode(response.body);
}  

}