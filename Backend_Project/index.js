// index.js
import express from 'express';  // Utilisation de 'import' pour Express
import { connectDatabase } from './Config/database.js';  // Utilisation de 'import' pour la fonction de connexion
import userRoutes from './routes/authRoutes.js';
import dotenv from 'dotenv';
import profileRoutes from './routes/profileRoutes.js';
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


// Utilisation des routes pour les utilisateurs
app.use('/api',userRoutes);
app.use('/api',profileRoutes);

// Démarrage du serveur
const PORT = 4000;
app.listen(PORT, () => {
  console.log(`Serveur démarré sur le port ${PORT}`);
});

