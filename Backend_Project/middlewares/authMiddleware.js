//Middleware pour vérifier le token JWT
 import jwt from 'jsonwebtoken';  // Utilisation de 'import' pour jwt
import dotenv from 'dotenv';  // Utilisation de 'import' pour dotenv
dotenv.config();  // Chargement des variables d'environnement
 export const verifyToken = (req, res, next) => {
  const token = req.header('x-auth-token');  // Récupération du token JWT
  if (!token) return res.status(401).send('Accès non autorisé');
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);  // Vérification du token
    req.user = decoded;  // Ajout des informations de l'utilisateur à la requête
    next();  // Passe à la prochaine fonction middleware ou route
  } catch (ex) {
    res.status(400).send('Token invalide');  // Envoie une réponse d'erreur si le token est invalide
  }
}
// Exportation de la fonction middleware

