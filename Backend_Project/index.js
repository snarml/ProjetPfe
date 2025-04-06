// index.js
import express from 'express';  // Utilisation de 'import' pour Express
import { connectDatabase } from './Config/database.js';  // Utilisation de 'import' pour la fonction de connexion
import userRoutes from './routes/routes.js';

const app = express();

// Middleware pour analyser le corps des requêtes (pour JSON)
app.use(express.json());

// Connexion à la base de données
connectDatabase();

// Utilisation des routes pour les utilisateurs
app.use('/api', userRoutes);

// Démarrage du serveur
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Serveur démarré sur le port ${PORT}`);
});
