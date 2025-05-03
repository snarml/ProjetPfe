import { Router } from 'express';
import { createActualite, getAllActualites, deleteActualite } from '../Controllers/newsController.js'; // Importation des fonctions du contrôleur
import { authAdmin } from '../middlewares/authAdmin.js';
import verifyToken from '../middlewares/authMiddleware.js';

const router = Router();

router.post('/admin/actualites',verifyToken , authAdmin,createActualite);
router.get('/admin/actualites', getAllActualites);
router.delete('/admin/actualites/:id',verifyToken,authAdmin, deleteActualite);

export default router;
