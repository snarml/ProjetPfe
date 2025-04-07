import { Sequelize } from 'sequelize';
import dotenv from 'dotenv';

// Charge les variables d'environnement
dotenv.config();

// Crée une instance de Sequelize pour la connexion à la base de données
const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASSWORD,
  {
    host: process.env.DB_HOST,
    dialect: 'mysql',
    port: process.env.DB_PORT
  }
);

// Fonction pour se connecter à la base de données
export const connectDatabase = async () => {
  try {
    await sequelize.authenticate();  // Essaie de se connecter à la base de données
    console.log('Connexion à la base de données réussie ✅');
  } catch (error) {
    console.error('Erreur de connexion à la base de données ❌:', error);
  }
};

// Exportation de sequelize pour l'utiliser dans d'autres fichiers comme models
export { sequelize };
