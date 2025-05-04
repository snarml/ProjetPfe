import { DataTypes } from 'sequelize';
import { sequelize } from '../Config/database.js';

const Categorie = sequelize.define('Categorie', {
  nom: {
    type: DataTypes.STRING,
    allowNull: false
  }
}, {
  tableName: 'categories',
  timestamps: false,
  createdAt: 'created_at',
  updatedAt: 'updated_at'
});

export default Categorie;
