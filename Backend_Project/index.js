import express from 'express';  // Utilisation de 'import' pour Express
import { connectDatabase } from './Config/database.js';  // Utilisation de 'import' pour la fonction de connexion
import userRoutes from './routes/userRoute.js';
import dotenv from 'dotenv';
import profileRoutes from './routes/profileRoutes.js';
import commandeRoutes from './routes/commandeRoute.js'; // Importation des routes de commande
import cartRoutes from './routes/cartRoute.js'; // Importation des routes de panier
import { initAssociations } from './models/initAssociations.js';
import actualiteRoutes from './routes/newsRoutes.js'; // Importation des routes d'actualités
import cors from 'cors'; // Importation de CORS pour gérer les requêtes cross-origin
import gererProduitsRoutes from './routes/gérerProduitsRoutes.js'; // Importation des routes de gestion des produits

import path from 'path';
import { fileURLToPath } from 'url';
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config({path: "./.env"}); // Chargement des variables d'environnement
const app = express();

// Middleware pour analyser le corps des requêtes (pour JSON)
app.use(express.json());
app.use(cors());
// Pour lire les données x-www-form-urlencoded
app.use(express.urlencoded({ extended: true }));
// Middleware pour vérifier le token JWT sur toutes les routes
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

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
app.use('/api', userRoutes);
app.use('/api', profileRoutes);
// Utilisation des routes pour les actualités
app.use('/api', actualiteRoutes); 
// Utilisation des routes pour les demandes de changement de rôle

// Utilisation des routes pour la gestion des produits
app.use('/api', gererProduitsRoutes);

// Initialisation des associations entre les modèles
initAssociations(); 

// Démarrage du serveur
const PORT = 4000;

app.listen(PORT,'0.0.0.0' ,() => {
  console.log(`Serveur démarré sur le port ${PORT}`);

});

