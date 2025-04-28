import { Router } from 'express';
import { createActualite, getAllActualites, deleteActualite } from '../Controllers/newsController.js'; // Importation des fonctions du contrôleur
import { authAdmin } from '../middlewares/authAdmin.js';

const router = Router();

router.post('/actualites', createActualite);
router.get('/actualites', getAllActualites);
router.delete('/actualites/:id',authAdmin, deleteActualite);

export default router;
