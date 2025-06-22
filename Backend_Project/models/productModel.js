import { DataTypes } from 'sequelize';
import { sequelize } from '../Config/database.js';


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
    type: DataTypes.DOUBLE,
    allowNull: false
  },
  quantite: {
    type: DataTypes.DOUBLE,
    allowNull: false
  },
  image_url: { 
    type: DataTypes.STRING 
  }, 
  disponible: { 
    type: DataTypes.BOOLEAN, 
    defaultValue: true 
  },
  type_offre: {
    type: DataTypes.STRING,
    allowNull: false,
    defaultValue: 'vente',
    allowNull: true // Permettre les valeurs nulles

    
  },
  utilisateur_id: { type: DataTypes.INTEGER },
  categorie_id: { type: DataTypes.INTEGER , allowNull: false,references: {
      model: 'Categorie',
      key: 'id'
    }}
}, {
  tableName: 'produits',
  timestamps: true,

});

// Relations directes

export default Produit;
