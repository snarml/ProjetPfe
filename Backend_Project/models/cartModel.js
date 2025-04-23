import { DataTypes } from 'sequelize';
import { sequelize } from '../Config/database.js';

const Cart = sequelize.define('Cart', {
  user_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: 'users',
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
  tableName: 'carts',
  timestamps: false
});
//définie la relation entre les models
Cart.associate = (models) => {
  Cart.belongsTo(models.User, { foreignKey: 'user_id' });
  Cart.belongsTo(models.Produit, { foreignKey: 'Produit_id' });
}

export default Cart;
