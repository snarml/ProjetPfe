import { DataTypes } from 'sequelize';
import { sequelize } from '../Config/database.js';

const Categorie = sequelize.define('Categorie', {
  id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true
  },
  nom: {
    type: DataTypes.STRING,
    allowNull: false
  },
   type: {
    type: DataTypes.STRING,
    allowNull: false
  }
}, {
  tableName: 'categories',
  timestamps: false,
  
});

export default Categorie;
