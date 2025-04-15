//login inscription
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // L'URL de ton serveur backend
  static const String baseUrl = 'http://10.0.2.2:4000'; // Remplace par l'URL de ton API

  // Fonction de Sign Up
  Future<Map<String, dynamic>> signUp(BuildContext context,String fullName, String numTel, String ville, String pays, String password) async {
    final url = Uri.parse('$baseUrl/api/add');
    try{
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'full_name': fullName,
        'num_tel': numTel,
        'ville': ville,
        'pays': pays,
        'password': password,
      }),
    );
    // Log de la réponse pour diagnostiquer l'erreur
    print('Réponse de l\'API : ${response.statusCode}');
    print('Corps de la réponse : ${response.body}');
    
final responseData = json.decode(response.body);
    if (response.statusCode == 201) {
      return responseData;
    } else {
      
      // Lis le message d'erreur retourné par l'API
      final errorMessage = responseData['message'] ?? 'Une erreur est survenue';
      throw Exception(errorMessage);
    }
  } catch (e) {
    // Ne pas montrer l'exception brute ici
    throw Exception(e.toString().replaceAll('Exception: ', ''));
  }
}
      
      
      
  // Fonction de Sign In
  Future<Map<String, dynamic>> signIn(String numTel, String password) async {
    final url = Uri.parse('$baseUrl/api/login');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'num_tel': numTel,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur lors de la connexion');
    }
  }
}
