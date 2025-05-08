import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class MarcheService {
  // L'URL de ton serveur backend
  static const String baseUrl = 'http://172.16.53.58:4000';
  Future<Map<String, dynamic>> addProduct(
    String name,
    String description,
    double price,
    int quantity,
    int categoryId,
    File? imageFile,
    String? authToken, // Si votre API nécessite un token
  ) async {
    final Uri apiUrl = Uri.parse('$baseUrl/poster-produits');

    try {
      var request = http.MultipartRequest('POST', apiUrl);

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      }

      request.fields['nom'] = name;
      request.fields['description'] = description;
      request.fields['prix'] = price.toString();
      request.fields['quantite'] = quantity.toString();
      request.fields['categorie_id'] = categoryId.toString();

      if (authToken != null) {
        request.headers['Authorization'] = 'Bearer $authToken';
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);

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
}
