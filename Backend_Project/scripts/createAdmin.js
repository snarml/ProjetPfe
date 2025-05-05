

import bcrypt from 'bcrypt';
import { sequelize } from '../Config/database.js';
import User from '../models/user.js';
import dotenv from 'dotenv';
dotenv.config();

const createAdmin = async () => {
  try {
    await sequelize.authenticate();
    console.log('Connexion à la base de données réussie ✅');

    const hashedPassword = await bcrypt.hash('adminpassword', 10); // <-- choisis un vrai mot de passe sécurisé

    const admin = await User.create({
      full_name: 'Admin Principal',
      num_tel: '99999999', // numéro fictif
      ville: 'Tunis',
      pays: 'Tunisie',
      password: hashedPassword,
      role: 'admin',  // très important !
      is_verified: true
    });

    console.log('✅ Admin créé avec succès:', admin.toJSON());
    process.exit();
  } catch (error) {
    console.error('❌ Erreur lors de la création de l\'admin:', error.message);
    process.exit(1);
  }
};

createAdmin();
