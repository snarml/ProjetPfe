// gérer les routes des produits 
 import express from 'express'; // Importation d'Express
import { addProduct, updateProduct, deleteProduct, getAllProducts, getProductById } from '../Controllers/gérerPrdouit.js'; // Importation des fonctions du contrôleur
import { verifyToken } from '../middlewares/authMiddleware.js'; // Middleware pour vérifier le token
import upload from '../middlewares/upload.js';

const router = express.Router();
router.post('/poster-produits', verifyToken, upload.single('image'), addProduct); 
router.put('/modifier-produits/:id', verifyToken, updateProduct);
router.delete('/supprimer-produits/:id', verifyToken, deleteProduct);
router.get('/produits', verifyToken, getAllProducts); // Route pour obtenir tous les produits
router.get('/produits/:id', verifyToken, getProductById); // Route pour obtenir un produit par son ID

export default router; 