import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

// Service
const Service = sequelize.define('Service', {
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  category: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  price: {
    type: DataTypes.FLOAT,
    allowNull: false,
  },
  description: {
    type: DataTypes.TEXT,
  },
  imageUrl: {
    type: DataTypes.STRING,
  },
});

// Provider
const Provider = sequelize.define('Provider', {
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  verified: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
});

// Booking
const Booking = sequelize.define('Booking', {
  date: {
    type: DataTypes.DATEONLY,
    allowNull: false,
  },
  time: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  quantity: {
    type: DataTypes.INTEGER,
    defaultValue: 1,
  },
});

// Associations
Service.hasMany(Booking, { onDelete: 'CASCADE' });
Booking.belongsTo(Service);

Provider.hasMany(Booking, { onDelete: 'CASCADE' });
Booking.belongsTo(Provider);

// Exporter avec ES Module
export { Service, Provider, Booking };
