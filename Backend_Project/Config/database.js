import { Sequelize } from 'sequelize';
import dotenv from 'dotenv';

// Charge les variables d'environnement
dotenv.config({path: "./.env"});

// Crée une instance de Sequelize pour la connexion à la base de données
const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASSWORD,
  {
    host: process.env.DB_HOST,
    dialect: 'mysql',
    port: process.env.DB_PORT,
    dialectOptions: {
      charset: 'utf8mb4',
    },
    define: {
      charset: 'utf8mb4',// enregistrer les mots arabes
      collate: 'utf8mb4_0900_ai_ci', // même collation que ta base(encodage)
    },
  }
);


// Fonction pour se connecter à la base de données
export const connectDatabase = async () => {
  try {
    await sequelize.authenticate();  // Essaie de se connecter à la base de données
    console.log('Connexion à la base de données réussie ');
  } catch (error) {
    console.error('Erreur de connexion à la base de données ❌:', error);
  }
};

// Exportation de sequelize pour l'utiliser dans d'autres fichiers comme models
export { sequelize };
