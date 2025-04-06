import User from '../models/user.js';  // Assure-toi que l'import de User est correct

// Fonction pour ajouter un utilisateur
export async function addUser(name, email, password) {
  try {
    const user = await User.create({
      name,
      email,
      password
    });
    return user;
  } catch (error) {
    throw new Error('Erreur lors de l\'ajout de l\'utilisateur');
  }
}

// Fonction pour obtenir tous les utilisateurs
export async function getUsers() {
  try {
    const users = await User.findAll();
    return users;
  } catch (error) {
    throw new Error('Erreur lors de la récupération des utilisateurs');
  }
}
