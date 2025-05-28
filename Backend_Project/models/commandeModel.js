import { DataTypes } from 'sequelize';
import { sequelize } from '../Config/database.js';
import User from './user.js';
import Produit from './productModel.js';
import CommandeProduit from './commande_produit.js';

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
    allowNull: false,
    defaultValue: 0
  },
  status: {
    type: DataTypes.ENUM('en attente', 'confirmée', 'livrée', 'annulée'),
    defaultValue: 'en attente'
  }
}, {
  tableName: 'commandes',
  timestamps: false,
  
});

// Association avec le modèle User

Commande.belongsTo(User, { foreignKey: 'utilisateur_id' });
// association avec le modèle Produit
Commande.belongsToMany(Produit, { through: CommandeProduit, foreignKey: 'commande_id' });



export default Commande;
