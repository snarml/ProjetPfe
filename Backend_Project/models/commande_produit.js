import { DataTypes } from 'sequelize';
import { sequelize } from '../Config/database.js';
import Produit from './productModel.js';
import Commande from './commandeModel.js';

const CommandeProduit = sequelize.define('CommandeProduit', {
  commande_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: 'commandes',
      key: 'id'
    },
    onDelete: 'CASCADE',
    primaryKey: true
    
  },
  produit_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: 'produits',
      key: 'id'
    },
    onDelete: 'CASCADE',
    primaryKey: true
  },
  quantite: {
    type: DataTypes.INTEGER,
    allowNull: false
  }
}, {
  tableName: 'commande_produits',
  timestamps: false
});
// Association avec le modèle Commande


export default CommandeProduit;
