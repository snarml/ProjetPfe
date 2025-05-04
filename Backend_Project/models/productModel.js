import { DataTypes } from 'sequelize';
import { sequelize } from '../Config/database.js';
import User from './user.js';
import Categorie from './categorieModel.js';
import Commande from './commandeModel.js';
import CommandeProduit from './commande_produit.js';

const Produit = sequelize.define('Produit', {
  id: { 
    type: DataTypes.INTEGER, 
    autoIncrement: true, 
    primaryKey: true 
  },
  nom: {
    type: DataTypes.STRING,
    allowNull: false
  },
  description: DataTypes.TEXT,
  prix: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: false
  },
  quantite: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  image_url: { 
    type: DataTypes.STRING 
  }, 
  utilisateur_id: { type: DataTypes.INTEGER },
  categorie_id: { type: DataTypes.INTEGER }
}, {
  tableName: 'produits',
  timestamps: false,
  createdAt: 'created_at',
  updatedAt: 'updated_at'
});

// Relations directes

export default Produit;
