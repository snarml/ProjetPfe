import express from 'express';  // Utilisation de 'import' pour Express
import { addUser, getUser, verifyOTP, login} from '../Controllers/authController.js';   // Import de la fonction pour récupérer les utilisateurs

const router = express.Router();

// Inscription: envoi un otp et creer un utilisateur
router.post('/add', addUser);

// Vérification de l'OTP
router.post('/verify', verifyOTP);  // Route pour vérifier l'OTP

// Connexion de l'utilisateur
router.post('/login', login);  // Route pour la connexion

// Récupération de l'utilisateur par son ID
router.get('/user/:id', getUser);  // Correction de la route pour obtenir les utilisateurs





export default router;  
