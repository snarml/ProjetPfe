import jwt from 'jsonwebtoken';  
import dotenv from 'dotenv';  // Importation de dotenv pour gérer les variables d'environnement

dotenv.config();

export const verifyToken = (req, res, next) => {
  console.log(' Headers:', req.headers); // ← Affiche tous les headers

  const authHeader = req.header('Authorization');
  console.log('Received Authorization Header:', authHeader); // 🔥 Ajoute ça


  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    console.log('No token provided or incorrect format');  // 🔥 Ajouter ce log

    return res.status(401).json({
      success: false,
      message: 'Accès refusé - Aucun token fourni'
    });
  }

  const token = authHeader.split(' ')[1]; // récupérer seulement le token sans "Bearer "
  console.log('Token récupéré:', token);

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    if (!decoded.id && !decoded.num_tel) {
      return res.status(401).json({
        success: false,
        message: 'Token invalide - Informations utilisateur manquantes'
      });
    }

    req.user = {
      id: decoded.id,
      num_tel: decoded.num_tel,
      role: decoded.role, 
    };

    next();

  } catch (error) {
    let message = 'Token invalide';

    if (error.name === 'TokenExpiredError') {
      message = 'Token expiré';
    } else if (error.name === 'JsonWebTokenError') {
      message = 'Token JWT malformé';
    }

    return res.status(401).json({
      success: false,
      message: `Erreur d'authentification - ${message}`
    });
  }
};
export default verifyToken; // Exportation de la fonction pour l'utiliser dans d'autres fichiers
