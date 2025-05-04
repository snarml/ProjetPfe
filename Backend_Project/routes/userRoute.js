import express from 'express';  // Utilisation de 'import' pour Express
import { addUser, getUser, verifyOTP, login, forgetPassword, listUsers, deleteAccount} from '../Controllers/userController.js';   // Import de la fonction pour récupérer les utilisateurs

const router = express.Router();

// Inscription: envoi un otp et creer un utilisateur
router.post('/add', addUser);

// Vérification de l'OTP
router.post('/verify', verifyOTP);  // Route pour vérifier l'OTP

// Connexion de l'utilisateur
router.post('/login', login);  // Route pour la connexion

// Récupération de l'utilisateur par son ID
router.get('/user/:id', getUser);  

// mot de passe oublié 
router.post('/forgot', forgetPassword);
// lister les utilisateurs(Admin)
router.get('/users',listUsers);
// suppprimer un utilisateur si nécessaire(Admin)
router.delete('/user/:id',deleteAccount);

//vérification de token jwt
router.use((req, res, next) => {
  const token = req.header('x-auth-token');
  if (!token) return res.status(401).send('Access denied. No token provided.');
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();  // Passe à la prochaine fonction middleware ou route
  } catch (ex) {
    res.status(400).send('Invalid token.');  // Envoie une réponse d'erreur si le token est invalide
  }
}
);
// Route pour obtenir l'utilisateur connecté
router.get('/me', (req, res) => {
  res.send(req.user);  // Envoie les informations de l'utilisateur connecté
});
// Route pour obtenir tous les utilisateurs
router.get('/users', async (req, res) => {
  try {
    const users = await User.findAll();  // Récupère tous les utilisateurs de la base de données
    res.json(users);  // Envoie la liste des utilisateurs en réponse
  } catch (error) {
    res.status(500).json({ message: 'Erreur lors de la récupération des utilisateurs' });  // Envoie une réponse d'erreur si une erreur se produit
  }
});



export default router;  
