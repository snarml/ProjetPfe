import express from 'express';
import { addUser, getUser, verifyOTP, login, forgetPassword, listUsers ,deleteAccount } from '../Controllers/userController.js';
import verifyToken from '../middlewares/authMiddleware.js';
import { authAdmin } from '../middlewares/authAdmin.js';

const router = express.Router();

// Inscription: envoi un otp et creer un utilisateur
router.post('/add', addUser);

// Vérification de l'OTP
router.post('/verify', verifyOTP);

// Connexion de l'utilisateur
router.post('/login', login);

// Récupération de l'utilisateur par son ID
router.get('/user/:id', getUser);

// Mot de passe oublié
router.post('/forgot', forgetPassword);

// Lister les utilisateurs (Admin uniquement)
router.get('/admin/users', verifyToken, authAdmin, listUsers);

// Supprimer un utilisateur si nécessaire (Admin uniquement)
router.delete('/admin/user/:id', verifyToken, authAdmin, deleteAccount);

// Route pour obtenir l'utilisateur connecté
router.get('/me', verifyToken, (req, res) => {
  res.send(req.user);
});

export default router;
