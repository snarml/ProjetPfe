import 'dart:convert';
import 'dart:io';
import 'package:bitakati_app/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class MarcheService {
  // L'URL de ton serveur backend
  static const String baseUrl = 'http://10.0.2.2:4000';
  Future<Map<String, dynamic>> addProduct(
    String name,
    String description,
    double price,
    double quantity,
    int categoryId,
    String offerType,
    File? imageFile,
    String authToken, // Si votre API nécessite un token
  ) async {
    final Uri apiUrl = Uri.parse('$baseUrl/api/poster-produits');
    print(' Envoi du produit vers $baseUrl');
    print('Données : nom=$name, prix=$price, quantite=$quantity,   description=$description, categorie_id=$categoryId, type_offre=$offerType');

    try {
      var request = http.MultipartRequest('POST', apiUrl);
      request.headers['Authorization'] = 'Bearer $authToken';

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      request.fields['nom'] = name;
      request.fields['description'] = description;
      request.fields['prix'] = price.toString();
      request.fields['quantite'] = quantity.toString();
      request.fields['categorie_id'] = categoryId.toString();
      request.fields['type_offre'] = offerType;


      if (authToken.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $authToken';
      }

      var response = await request.send();
      print("requete envoye ");
      var responseBody = await response.stream.bytesToString();
      print(' Code status: ${response.statusCode}');
      print(' Réponse brute#""############: $responseBody');
      final jsonResponse = json.decode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(' Produit ajouté avec succès');
      } else {
        print(' Erreur lors de l\'ajout du produit: ${response.statusCode}');
      }
      return {
        'statusCode': response.statusCode,
        'body': jsonResponse,
      };
    } catch (error) {
      print('Erreur de connexion dans MarcheService.addProduct: $error');
      return {
        'statusCode': 500,
        'body': {'message': 'Erreur de connexion au serveur'},
      };
    }
  }

  // recuperer tous les produits
  Future<List<dynamic>> getProducts(String token) async {
  try {
    print("🔍 Tentative de récupération des produits");
    print("🔗 URL: $baseUrl/api/produits");
    print("🔑 Token utilisé: $token");

    final response = await http.get(
      Uri.parse('$baseUrl/api/produits'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print("📡 Status code: ${response.statusCode}");
    print("📦 Réponse: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // Extraire la liste des produits du champ 'data'
      final List<dynamic> products = jsonResponse['data'] ?? [];
      print("📦 Nombre de produits extraits: ${products.length}");
      return products;
    } else {
      print("❌ Erreur: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    print("🔥 Erreur: $e");
    return [];
  }
}

  // fonction pour supprimer un produit
  Future<bool> deleteProduct(String token, String productId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/supprimer-produits/$productId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        throw Exception('Produit non trouvé');
      } else {
        throw Exception('Échec de la suppression du produit');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // recuperer les détails d'un produit
  Future<Map<String, dynamic>?> getProductDetails(
      String productId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/produits/$productId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print("bonjour");
      if (response.statusCode == 200) {
        print('Réponse backend: ${response.body}');

        return json.decode(response.body);
      } else {
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      return null;
    }
  }

  /// Mettre à jour un produit
  Future<Map<String, dynamic>> updateProduct(
    String id,
    String name,
    String description,
    double price,
    double quantity,
    int categoryId,
    File? imageFile,
    String token,
    
  ) async {
    final Uri apiUrl = Uri.parse('$baseUrl/api/modifier-produits/$id');
    try {
      var request = http.MultipartRequest('PUT', apiUrl);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['nom'] = name;
      request.fields['description'] = description;
      request.fields['prix'] = price.toString();
      request.fields['quantite'] = quantity.toString();
      request.fields['categorie_id'] = categoryId.toString();

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      } else {
  print('Aucune image disponible');
}

      var response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);
      return {
        'statusCode': response.statusCode,
        'body': jsonResponse,
      };
    } else {
      print('Erreur update: ${response.statusCode}');
      final responseBody = await response.stream.bytesToString();
      return {
        'statusCode': response.statusCode,
        'body': {'message': 'Erreur de mise à jour', 'details': responseBody},
      };
    }
    } catch (e) {
      return {
        'statusCode': 500,
        'body': {'message': 'Erreur de mise à jour'},
      };
    }
  }

  /// Rechercher des produits
  Future<List<dynamic>> searchProducts(String query, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/produit/rechercher?q=$query'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results'] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
  Future<List<Product>> getProductsByCategory(String token, int categoryId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/produits/categorie/$categoryId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List products = data['products'];
      return products.map((e) => Product.fromMap(e)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des produits');
    }
  }
}
