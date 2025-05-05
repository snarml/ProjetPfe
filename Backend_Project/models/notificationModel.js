import { DataTypes } from 'sequelize';
import { sequelize } from '../Config/database.js';
import User from './user.js'

const Notification = sequelize.define('Notification', {
  titre: {
    type: DataTypes.STRING,
    allowNull: false
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  utilisateur_id: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  is_read: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  }
}, {
  tableName: 'notifications',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at'
});

// Association
Notification.belongsTo(User, { foreignKey: 'user_id' , as: 'user' });

export default Notification;
