import express from 'express';
import { getNotificationsForUser, markNotificationAsRead } from '../Controllers/notificationController.js'; // Importation des fonctions du contrôleur
import { verifyToken } from '../middlewares/authMiddleware.js'; // middleware pour vérifier JWT

const router = express.Router();

// Récupérer toutes les notifications de l'utilisateur connecté
router.get('/', verifyToken, getNotificationsForUser);

// Marquer une notification comme lue
router.put('/:id/read', verifyToken, markNotificationAsRead);

export default router;
