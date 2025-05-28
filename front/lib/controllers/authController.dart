import 'package:bitakati_app/services/authServices.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';



class User {
  final String id;
  final String fullName;
  final String numTel;
  final String ville;
  final String pays;
  final String role; // 'vendeur', 'acheteur', 'admin', etc.
  
  User({
    required this.id,
    required this.fullName,
    required this.numTel,
    required this.ville,
    required this.pays,
    required this.role,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      numTel: json['num_tel'] ?? '',
      ville: json['ville'] ?? '',
      pays: json['pays'] ?? '',
      role: json['role'] ?? 'acheteur',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'num_tel': numTel,
      'ville': ville,
      'pays': pays,
      'role': role,
    };
  }
}

class AuthController extends GetxController {
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  
  final ApiService _apiService = ApiService();
  
  @override
  void onInit() {
    super.onInit();
    loadUserFromStorage();
  }
  
  // Charger les informations de l'utilisateur depuis le stockage local
  Future<void> loadUserFromStorage() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token != null) {
        // Récupérer les informations utilisateur depuis SharedPreferences
        final userData = {
          'id': prefs.getString('id') ?? '',
          'full_name': prefs.getString('full_name') ?? '',
          'num_tel': prefs.getString('num_tel') ?? '',
          'ville': prefs.getString('ville') ?? '',
          'pays': prefs.getString('pays') ?? '',
          'role': prefs.getString('role') ?? 'acheteur',
        };
        
        currentUser.value = User.fromJson(userData);
        isLoggedIn.value = true;
      }
    } catch (e) {
      print('Erreur lors du chargement des données utilisateur: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Se connecter en utilisant ApiService
  Future<bool> login(String numTel, String password) async {
    isLoading.value = true;
    try {
      final response = await _apiService.signIn(numTel, password);
      
      if (response['token'] != null && response['user'] != null) {
        final user = User.fromJson(response['user']);
        currentUser.value = user;
        isLoggedIn.value = true;
        
        // Les données sont déjà sauvegardées dans SharedPreferences par ApiService
        
        return true;
      }
      return false;
    } catch (e) {
      print('Erreur de connexion: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  
  // S'inscrire en utilisant ApiService
  Future<Map<String, dynamic>> signUp(String fullName, String numTel, String ville, String pays, String password) async {
    isLoading.value = true;
    try {
      final response = await _apiService.signUp(Get.context!, fullName, numTel, ville, pays, password);
      isLoading.value = false;
      return response;
    } catch (e) {
      isLoading.value = false;
      print('Erreur d\'inscription: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
  
  // Vérifier le code OTP
  Future<Map<String, dynamic>> verifyCode(String token, String code) async {
    isLoading.value = true;
    try {
      final response = await _apiService.verifyCode(token, code);
      
      if (response['success'] == true && response['user'] != null) {
        final user = User.fromJson(response['user']);
        currentUser.value = user;
        isLoggedIn.value = true;
      }
      
      isLoading.value = false;
      return response;
    } catch (e) {
      isLoading.value = false;
      print('Erreur de vérification: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
  
  // Se déconnecter
  Future<void> logout() async {
    try {
      // Effacer les données du stockage local
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('full_name');
      await prefs.remove('num_tel');
      await prefs.remove('ville');
      await prefs.remove('pays');
      await prefs.remove('role');
      
      // Réinitialiser l'état
      currentUser.value = null;
      isLoggedIn.value = false;
    } catch (e) {
      print('Erreur de déconnexion: $e');
    }
  }
  
  // Récupérer le token d'authentification
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  
  // Vérifier si l'utilisateur est un vendeur
  bool isVendeur() {
    return currentUser.value?.role == 'vendeur';
  }
  
  // Vérifier si l'utilisateur est un acheteur
  bool isAcheteur() {
    return currentUser.value?.role == 'acheteur';
  }
  
  // Vérifier si l'utilisateur est propriétaire d'un produit spécifique
  bool isProductOwner(String vendeurId) {
    return currentUser.value?.id == vendeurId;
  }
  
  // Obtenir l'ID de l'utilisateur actuel
  String? getCurrentUserId() {
    return currentUser.value?.id;
  }
}