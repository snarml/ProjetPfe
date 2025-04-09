import express from 'express';
import { connectDatabase } from './config/db.js';  // Import de ta connexion
import notificationRoutes from './routes/notificationRoutes.js';  // Tes routes

const app = express();
app.use(express.json());

// Connexion à la base de données
connectDatabase();

// Définition des routes
app.use('/api/notifications', notificationRoutes);

// Lancement du serveur
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Serveur lancé sur le port ${PORT} `);
});
