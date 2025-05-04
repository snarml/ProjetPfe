import express from 'express';
import { passerCommande, getCommandesUtilisateur, annulerCommande } from '../Controllers/commandeContoller.js';
import {verifyToken} from '../middlewares/authMiddleware.js'; // Assurez-vous d'importer le middleware d'authentification si nécessaire

const router = express.Router();
//router.use(verifyToken); // Appliquer le middleware d'authentification à toutes les routes de ce fichier
router.get('/commandes-produits/:id', getCommandesUtilisateur);
router.post('/passer-commande', passerCommande);
router.delete('/annuler-commande/:id', annulerCommande);


export default router;
