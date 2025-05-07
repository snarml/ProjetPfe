import Produit from '../models/productModel.js'
import fs from 'fs'; // Importation de fs pour gérer les fichiers
import path from 'path'; // Importation de path pour gérer les chemins de fichiers
import { fileURLToPath } from 'url'; // Importation de fileURLToPath pour gérer les URLs de fichiers
 
export const addProduct = async (req, res) => {
  try {
    console.log("req.body:", req.body); // Ajout de ce log
    console.log("req.body (form-data):", req.body); // Ajoutez ceci

    const { nom, description, prix, quantite, categorie_id } = req.body;
    const utilisateur_id = req.user.id; 
    const image_url = req.file ? req.file.filename : null;

    // Vérification si le produit existe déjà
    const existingProduct = await Produit.findOne({ where: { nom } });
    if (existingProduct) {
      return res.status(400).json({ message: 'Le produit existe déjà.' });
    }

    // Création du produit
    const product = await Produit.create({
      nom,
      description,
      prix,
      quantite,
      image_url,
      utilisateur_id,
      categorie_id
      // created_at sera automatiquement ajouté par MySQL
    });

    res.status(201).json({ message: 'Produit ajouté avec succès.', product });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur lors de l\'ajout du produit.'
      , error : error.message 
    });
  }
};
// fonction pour modifier un produit
export const updateProduct = async (req, res) => {
  try {
    const { id } = req.params; // Récupération de l'ID du produit depuis les paramètres de la requête
    const { name, description, price, quantity } = req.body; // Récupération des données du produit depuis le corps de la requête
    const image = req.file ? req.file.filename : null; // Récupération du nom de l'image

    // Vérification si le produit existe
    const product = await Produit.findByPk(id);
    if (!product) {
      return res.status(404).json({ message: 'Produit non trouvé.' });
    }

    // Mise à jour du produit
    await product.update({
      name,
      description,
      price,
      quantity,
      image,
    });

    res.status(200).json({ message: 'Produit mis à jour avec succès.', product });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur lors de la mise à jour du produit.', error });
  }
};
// fonction pour supprimer un produit
export const deleteProduct = async (req, res) => {
  try {
    const { id } = req.params; // Récupération de l'ID du produit depuis les paramètres de la requête

    // Vérification si le produit existe
    const product = await Produit.findByPk(id);
    if (!product) {
      return res.status(404).json({ message: 'Produit non trouvé.' });
    }

    // Suppression du produit
    await product.destroy();

    // Suppression de l'image associée au produit
    if (product.image) {
      const __filename = fileURLToPath(import.meta.url); // Récupération du nom de fichier actuel
      const __dirname = path.dirname(__filename); // Récupération du répertoire actuel
      const imagePath = path.join(__dirname, '../uploads', product.image); // Construction du chemin de l'image
      fs.unlink(imagePath, (err) => { // Suppression de l'image
        if (err) console.error('Erreur lors de la suppression de l\'image:', err);
      });
    }

    res.status(200).json({ message: 'Produit supprimé avec succès.' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur lors de la suppression du produit.', error });
  }
};
// fonction pour afficher tous les produits
export const getAllProducts = async (req, res) => {
  try {
    const { page = 1, limit = 10 } = req.query; // Pagination
    const offset = (page - 1) * limit;

    // Récupération de tous les produits avec pagination
    const products = await Produit.findAndCountAll({
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [['createdAt', 'DESC']], // Trie par date de création
    });

    res.status(200).json({
      total: products.count,
      page: parseInt(page),
      limit: parseInt(limit),
      data: products.rows,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur lors de la récupération des produits.', error });
  }
};
// fonction pour afficher un produit par id
export const getProductById = async (req, res) => {
  try {
    const { id } = req.params; // Récupération de l'ID du produit depuis les paramètres de la requête

    // Vérification si le produit existe
    const product = await Produit.findByPk(id);
    if (!product) {
      return res.status(404).json({ message: 'Produit non trouvé.' });
    }

    res.status(200).json({ product });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur lors de la récupération du produit.', error });
  }
};
