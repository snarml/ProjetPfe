import { DataTypes } from 'sequelize';  // Utilisation de l'import pour DataTypes
import { sequelize } from '../Config/database.js';  // Assure-toi que l'import est correct

const User = sequelize.define('User', {
  
  full_name: {
    type: DataTypes.STRING,
    allowNull: false
  },
  
  num_tel: { 
    type: DataTypes.STRING, 
    allowNull: false, 
    unique: true
   },
    ville: { 
      type: DataTypes.STRING, 
      allowNull: false 
    },
    pays: { 
      type: DataTypes.STRING, 
      allowNull: false 
    },
    password: { 
      type: DataTypes.STRING, 
      allowNull: false 
    },
    otp_code: { 
      type: DataTypes.STRING 
    },
    is_verified: { 
      type: DataTypes.BOOLEAN,
       defaultValue: false 
      }
}, {
  tableName: 'users',  // Nom de la table dans la base de données
  timestamps: false  // Désactiver les timestamps automatiques
});

// Exportation par défaut pour que l'import fonctionne correctement
export default User;
