// gérer les routes des produits 
 import express from 'express'; // Importation d'Express
import { addProduct, updateProduct, deleteProduct, getAllProducts, getProductById, getAvailableProducts, getUnavailableProducts, updateProductQuantityAfterPurchase, restoreProduct, searchProductByName, getProductsByCategory, markProductAsFavorite } from '../Controllers/gérerPrdouit.js'; // Importation des fonctions du contrôleur
import { verifyToken } from '../middlewares/authMiddleware.js'; // Middleware pour vérifier le token
import upload from '../middlewares/upload.js';

const router = express.Router();
router.post('/poster-produits', verifyToken, upload.single('image'), addProduct); 
router.put('/modifier-produits/:id', verifyToken,upload.single('image') ,updateProduct);
router.delete('/supprimer-produits/:id', verifyToken, deleteProduct);
router.get('/produits', verifyToken, getAllProducts); // Route pour obtenir tous les produits
router.get('/produits/:id', verifyToken, getProductById); // Route pour obtenir un produit par son ID
router.get('/produits-disponibles', verifyToken, getAvailableProducts); // Route pour obtenir les produits disponibles
router.get('/produits-indisponibles', verifyToken, getUnavailableProducts); // Route pour obtenir les produits indisponibles
router.put('/modifier-quantite/:id', verifyToken, updateProductQuantityAfterPurchase); // Route pour mettre à jour la quantité d'un produit après achat 
router.put('/produits/:id/restaurer', verifyToken, restoreProduct);// Route pour restaurer un produit supprimé(rendre disponible à nouveau )
router.get('/produit/rechercher', verifyToken, searchProductByName); // Route pour rechercher un produit par son nom
router.get('/produits/categorie/:categorie_id', verifyToken, getProductsByCategory); // Route pour obtenir les produits par catégorie
router.post('/produits/:id/favoris', verifyToken, markProductAsFavorite); // Route pour marquer un produit comme favori

export default router; 