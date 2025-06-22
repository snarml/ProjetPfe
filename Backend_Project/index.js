import express from 'express';
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';
import cors from 'cors';

import { connectDatabase } from './config/database.js';
import { initAssociations } from './models/initAssociations.js';

import userRoutes from './routes/userRoute.js';
import profileRoutes from './routes/profileRoutes.js';
import commandeRoutes from './routes/commandeRoute.js';
import cartRoutes from './routes/cartRoute.js';
import actualiteRoutes from './routes/newsRoutes.js';
import roleChangeRequestRoutes from './routes/roleChangeRequestRoutes.js';
import prestaRoutes from './routes/prestRoutes.js';
import messageRoutes from './routes/messageRoutes.js';
import uploadRoutes from './routes/uploadRoutes.js';

dotenv.config({ path: './.env' });

const app = express();
app.use(express.json());
app.use(cors());
// Pour lire les données x-www-form-urlencoded
app.use(express.urlencoded({ extended: true }));
// Middleware pour vérifier le token JWT sur toutes les routes
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Connexion à la base de données
connectDatabase();

// Initialisation des associations entre les modèles
initAssociations();

// Route de base
app.get('/', (req, res) => {
  res.send('Bienvenue sur l\'API');
});

// Définition des routes
app.use('/api/users', userRoutes);
app.use('/api/profiles', profileRoutes);
app.use('/api/commandes', commandeRoutes);
app.use('/api/panier', cartRoutes);
app.use('/api/actualites', actualiteRoutes);
app.use('/api/roles', roleChangeRequestRoutes);
app.use('/api/prestations', prestaRoutes);
app.use('/api/messages', messageRoutes);
app.use('/api/upload', uploadRoutes);

// Lancement du serveur
const PORT = process.env.PORT || 4000;
app.listen(PORT, '127.0.0.1', () => {
  console.log(`✅ Serveur démarré sur http://127.0.0.1:${PORT}`);
});


//app.listen(PORT, '192.168.1.20', () => {
