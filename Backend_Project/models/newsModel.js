import { DataTypes } from "sequelize";
import { sequelize } from  "../Config/database.js";
import User from  "./user.js";

const Actualite = sequelize.define("Actualite", {
  id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },
  titre: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  description :{
    type: DataTypes.TEXT,
    allowNull: false,
  },
  image_url: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  created_by: {
    type: DataTypes.INTEGER,
    allowNull: false,
  }
}, {
  tableName: "actualites",
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: false,
});
 


export default Actualite;
