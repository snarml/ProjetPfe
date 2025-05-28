import 'package:bitakati_app/services/commandeServices.dart';
import 'package:get/get.dart';

class CommandeController extends GetxController {
  var commandes = <dynamic>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  // Récupérer les commandes de l'utilisateur
  Future<void> fetchCommandes(int userId, String token) async {
    try {
      isLoading.value = true;
      error.value = '';
      final result = await CommandeService().getCommandesUtilisateur(userId, token);
      commandes.value = result;
    } catch (e) {
      error.value = 'Erreur lors du chargement des commandes : $e';
      commandes.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Passer une commande (depuis le panier)
  Future<Map<String, dynamic>?> passerCommande(int userId, String token) async {
    try {
      isLoading.value = true;
      error.value = '';
      final result = await CommandeService().passerCommande(userId, token);
      // Rafraîchir la liste après ajout
      await fetchCommandes(userId, token);
      return result;
    } catch (e) {
      error.value = 'Erreur lors de la commande : $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Annuler une commande
  Future<Map<String, dynamic>?> annulerCommande(int commandeId, int userId, String token) async {
    try {
      isLoading.value = true;
      error.value = '';
      final result = await CommandeService().annulerCommande(commandeId, token);
      // Rafraîchir la liste après annulation
      await fetchCommandes(userId, token);
      return result;
    } catch (e) {
      error.value = 'Erreur lors de l\'annulation : $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}