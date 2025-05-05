import express from 'express';
import * as roleChangeRequestController from '../Controllers/roleChangeRequestController.js'; // Importation des fonctions du contrôleur
import {verifyToken} from '../middlewares/authMiddleware.js';
import { authAdmin } from '../middlewares/authAdmin.js';
const router = express.Router();

// ➔ L'utilisateur connecté envoie une demande
router.post('/role-change-request',verifyToken ,roleChangeRequestController.requestRoleChange);

// ➔ L'admin voit toutes les demandes
router.get('/admin/role-change-requests', verifyToken, authAdmin, roleChangeRequestController.listRoleChangeRequests);

// ➔ L'admin traite une demande
router.patch('/admin/role-change-requests/:id', verifyToken, authAdmin, roleChangeRequestController.updateRoleChangeRequest);

export default router;
