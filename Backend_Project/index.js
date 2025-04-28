// index.js
import express from 'express';  // Utilisation de 'import' pour Express
import { connectDatabase } from './Config/database.js';  // Utilisation de 'import' pour la fonction de connexion
import userRoutes from './routes/userRoute.js';
import dotenv from 'dotenv';
import profileRoutes from './routes/profileRoutes.js';
import commandeRoutes from './routes/commandeRoute.js'; // Importation des routes de commande
import cartRoutes from './routes/cartRoute.js'; // Importation des routes de panier
import initAssociations from './models/initAssociations.js';
import actualiteRoutes from './routes/newsRoutes.js'; // Importation des routes d'actualités

dotenv.config(); // Chargement des variables d'environnement
const app = express();

// Middleware pour analyser le corps des requêtes (pour JSON)
app.use(express.json());

// Connexion à la base de données
connectDatabase();

// Route de base pour vérifier si le serveur fonctionne
app.get('/', (req, res) => {
  res.send('Bienvenue sur l\'API');
});
// Utilisation des routes pour les commandes
app.use('/api', commandeRoutes);
// Utilisation des routes pour le panier
app.use('/api', cartRoutes);

// Utilisation des routes pour les utilisateurs
app.use('/api',userRoutes);
app.use('/api',profileRoutes);
// Utilisation des routes pour les actualités
app.use('/api', actualiteRoutes); 


// Initialisation des associations entre les modèles
initAssociations(); 

// Démarrage du serveur
const PORT = 4000;
app.listen(PORT, () => {
  console.log(`Serveur démarré sur le port ${PORT}`);
});

