import { DataTypes } from 'sequelize';  // Utilisation de l'import pour DataTypes
import { sequelize } from '../Config/database.js';  // Assure-toi que l'import est correct

const User = sequelize.define('User', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false
  },
  email: {
    type: DataTypes.STRING,
    unique: true,
    allowNull: false
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false
  },
  created_at: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  }
}, {
  tableName: 'users',  // Nom de la table dans la base de données
  timestamps: false  // Désactiver les timestamps automatiques
});

// Exportation par défaut pour que l'import fonctionne correctement
export default User;
