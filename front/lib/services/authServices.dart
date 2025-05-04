//login inscription
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // L'URL de ton serveur backend
  static const String baseUrl = 'http://10.0.2.2:4000';

  // Fonction de Sign Up
  Future<Map<String, dynamic>> signUp(BuildContext context, String fullName,
      String numTel, String ville, String pays, String password) async {
    final url = Uri.parse('$baseUrl/api/add');
    try {
      print("Tentative envoyée");

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
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        // Lis le message d'erreur retourné par l'API
        final errorMessage =
            responseData['message'] ?? 'Une erreur est survenue';
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Ne pas montrer l'exception brute ici
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

//Fonction de vérification de code
  Future<Map<String, dynamic>> verifyCode(
      String token, String enteredCode) async {
    final url = Uri.parse('$baseUrl/api/verify');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      },
      body: json.encode({'otp_code': enteredCode}),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 201 && responseData['success'] == true) {
      print("success *****************");
      return {
        'token': responseData['token'],
        'user': responseData['user'],
        'success': true,
        'message': responseData['message'],
      };
    } else {
      print("error *****************");

      return responseData;
      // throw Exception(responseData['message'] ?? "رمز غير صحيح، حاول مرة أخرى");
    }
  }

// Fonction de Sign In
  Future<Map<String, dynamic>> signIn(String numTel, String password) async {
    final url = Uri.parse('$baseUrl/api/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'num_tel': numTel,
          'password': password,
        }),
      );
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['token'] != null) {
        return responseData;
      } else {
        throw Exception(responseData['error'] ?? 'حدث خطأ أثناء الاتصال');
      }   
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  //Fonction pour mot de passe oublié
  Future<Map<String, dynamic>> forgotPassword(String numTel) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/forgot'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'num_tel': numTel}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return {
        'message': data['message'],
        'numTel': data['num_tel'],
      };
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Erreur inconnu ');
    }
  }

  //Focntion de editProfile
  Future<Map<String, dynamic>> editProfile(
      String fullName,
      String numTel,
      String ville,
      String pays,
      String oldPassword,
      String newPassword,
      String confirmPassword) async {
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
    return jsonDecode(response.body);
  }
}
