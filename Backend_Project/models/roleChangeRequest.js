import { DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';  

const RoleChangeRequest = sequelize.define('RoleChangeRequest', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  user_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  requested_role: {
    type: DataTypes.ENUM('agriculteur', 'prestataire', 'citoyen'),
    allowNull: false,
  },
  status: {
    type: DataTypes.ENUM('en attente', 'approuvé', 'rejeté'),
  },
}, {
  timestamps: false,
  tableName: 'role_change_requests',
});

export default RoleChangeRequest;
