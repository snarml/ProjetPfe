import express from 'express';
import { passerCommande, getCommandesUtilisateur, annulerCommande } from '../Controllers/commandeContoller.js';
const router = express.Router();

router.get('/commandes-produits', getCommandesUtilisateur);
router.post('/passer-commande', passerCommande);
router.delete('/annuler-commande/:id', annulerCommande);


export default router;
