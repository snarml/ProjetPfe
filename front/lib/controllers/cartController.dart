import 'package:bitakati_app/services/cartService.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItems = [].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  Future<void> fetchCart(int userId, String token) async {
    try {
      isLoading.value = true;
      cartItems.value = await CartService().afficherPanier(userId, token);
    } catch (e) {
      error.value = 'Erreur lors du chargement du panier : $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> ajouterProduit(int userId, int produitId, int quantity, String token) async {
    try {
      isLoading.value = true;
      print('🛒 Ajout au panier...');
      print('Données: userId=$userId, produitId=$produitId, quantity=$quantity');
      
      final success = await CartService().ajouterProduit(
        userId,
        produitId,
        quantity,
        token
      );
      
    
      if (success) {
        print('✅ Produit ajouté au panier');
        await fetchCart(userId, token); // Recharger le panier
        return true;
      }else {
        print('❌ Erreur lors de l\'ajout au panier');
        error.value = 'Erreur lors de l\'ajout au panier';
        return false;
      }
    } catch (e) {
      print('❌ Erreur ajouterProduit: $e');
      error.value = 'Erreur lors de l\'ajout au panier';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateQuantity(int userId, int produitId, int quantity, String token) async {
    try {
      final result = await CartService().modifierQuantite(userId, produitId, quantity, token);
      return result['success'] ?? false;
    } catch (e) {
      error.value = e.toString();
      return false;
    }
  }

  Future<bool> removeItem(int userId, int produitId, String token) async {
    try {
      final result = await CartService().supprimerProduit(userId, produitId, token);
      return result['success'] ?? false;
    } catch (e) {
      error.value = e.toString();
      return false;
    }
  }

  Future<bool> clearCart(int userId, String token) async {
    try {
      final result = await CartService().viderPanier(userId, token);
      return result['success'] ?? false;
    } catch (e) {
      error.value = e.toString();
      return false;
    }
  }
}