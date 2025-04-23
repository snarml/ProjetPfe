import jwt from 'jsonwebtoken';  
import dotenv from 'dotenv';  

dotenv.config();

export const verifyToken = (req, res, next) => {
  const token = req.header('x-auth-token');
  
  // Vérification de l'existence du token
  if (!token) {
    return res.status(401).json({
      success: false,
      message: 'Accès refusé - Aucun token fourni'
    });
  }

  try {
    // Vérification et décodage du token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    // Vérification que le token contient bien un ID utilisateur
    if (!decoded.id && !decoded.num_tel) {
      return res.status(401).json({
        success: false,
        message: 'Token invalide - Informations utilisateur manquantes'
      });
    }
    
    // Ajout des informations utilisateur à la requête
    req.user = {
      id: decoded.id,
      num_tel: decoded.num_tel,  // Ajout du numéro de téléphone décodé
      
    };
    
    next();
    
  } catch (error) {
    // Gestion différenciée des erreurs JWT
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