import { DataTypes } from 'sequelize';
import { sequelize } from '../Config/database.js';
import User from './user.js';

const Commande = sequelize.define('Commande', {
  id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },
  utilisateur_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id',
    },
  },
  total: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: false
  },
  status: {
    type: DataTypes.ENUM('en attente', 'confirmée', 'livrée', 'annulée'),
    defaultValue: 'en attente'
  }
}, {
  tableName: 'commandes',
  timestamps: false,
  createdAt: 'created_at',
  updatedAt: 'updated_at'
});

// Association avec le modèle User

Commande.belongsTo(User, { foreignKey: 'utilisateur_id' });

export default Commande;
