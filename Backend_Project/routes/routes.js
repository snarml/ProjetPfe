import express from 'express';  // Utilisation de 'import' pour Express
import { addUser, getUsers } from '../Controllers/userController.js';   // Import de la fonction pour récupérer les utilisateurs

const router = express.Router();

// Route pour ajouter un utilisateur
router.post('/users', async (req, res) => {
  try {
    const { name, email, password } = req.body;  // Récupère les données de l'utilisateur depuis le body de la requête
    const user = await addUser(name, email, password);  // Appelle la fonction pour ajouter l'utilisateur
    res.status(201).json({ message: 'Utilisateur ajouté avec succès 📝', user });
  } catch (error) {
    res.status(500).json({ message: 'Erreur lors de l\'ajout de l\'utilisateur ❌', error });
  }
});

// Route pour obtenir tous les utilisateurs
router.get('/users', async (req, res) => {
  try {
    const users = await getUsers();  // Appelle la fonction pour récupérer tous les utilisateurs
    res.status(200).json({ message: 'Liste des utilisateurs', users });
  } catch (error) {
    res.status(500).json({ message: 'Erreur lors de la récupération des utilisateurs ❌', error });
  }
});

export default router;  // Exportation avec 'export default'
