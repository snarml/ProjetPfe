import 'dart:convert';
import 'package:http/http.dart' as http;

class CartService {
  final String baseUrl = 'http://10.0.2.2:4000'; // adapte selon ton backend

  // Ajouter un produit au panier
  Future<bool> ajouterProduit(int userId, int produitId, int quantite, String token) async {
    try {
      print('🔄 Tentative d\'ajout au panier');
      print('📤 Données: userId=$userId, produitId=$produitId, quantite=$quantite');
      
      final url = Uri.parse('$baseUrl/api/ajouter-produit-panier');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'produit_id': produitId,
          'quantite': quantite,
        }),
      );

      print('📥 Status code: ${response.statusCode}');
      print('📦 Réponse: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('❌ Erreur: $e');
      return false;
    }
  }

  // Modifier la quantité d'un produit
  Future<Map<String, dynamic>> modifierQuantite(int userId, int produitId, int quantite, String token) async {
    final url = Uri.parse('$baseUrl/api/modifier-quantite');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'produit_id': produitId,
        'quantite': quantite,
      }),
    );
    return json.decode(response.body);
  }

  // Supprimer un produit du panier
  Future<Map<String, dynamic>> supprimerProduit(int userId, int produitId, String token) async {
    final url = Uri.parse('$baseUrl/api/supprimer-produit');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'produit_id': produitId,
      }),
    );
    return json.decode(response.body);
  }

  // Vider le panier
  Future<Map<String, dynamic>> viderPanier(int userId, String token) async {
    final url = Uri.parse('$baseUrl/api/vider-panier');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'user_id': userId}),
    );
    return json.decode(response.body);
  }

  // Afficher le panier
  Future<List<dynamic>> afficherPanier(int userId, String token) async {
    final url = Uri.parse('$baseUrl/api/afficher-panier/$userId');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return json.decode(response.body);
  }
}