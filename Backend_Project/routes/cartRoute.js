import express from "express";
import { ajouterProduit, modifierQuantite, supprimerProduit,afficherPanier, viderPanier,  } from "../Controllers/cartController.js";

const router = express.Router();
// Route pour ajouter un produit au panier
router.post("/ajouter-produit", ajouterProduit);
// Route pour modifier la quantité d'un produit dans le panier
router.put("/modifier-quantite", modifierQuantite);
// Route pour supprimer un produit du panier

router.delete("/supprimer-produit", supprimerProduit);
// Route pour vider le panier
router.delete("/vider-panier", viderPanier);
// Route pour afficher le panier
router.get("/afficher-panier/:user_id", afficherPanier);

export default router;