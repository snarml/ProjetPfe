import express from 'express';
import { getNotificationsForUser, markNotificationAsRead } from '../Controllers/notificationController.js'; // Importation des fonctions du contrôleur
import { authenticateUser } from '../middlewares/authMiddleware.js'; // middleware pour vérifier JWT

const router = express.Router();

// Récupérer toutes les notifications de l'utilisateur connecté
router.get('/', authenticateUser, getNotificationsForUser);

// Marquer une notification comme lue
router.put('/:id/read', authenticateUser, markNotificationAsRead);

export default router;
