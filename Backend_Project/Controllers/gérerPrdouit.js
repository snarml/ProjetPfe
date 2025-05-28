import Produit from '../models/productModel.js';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { Op } from 'sequelize'; 
import Sequelize from 'sequelize';
import Categorie from '../models/categorieModel.js';


export const addProduct = async (req, res) => {
  try {
    console.log('--- [API] addProduct appelée ---');
    console.log('Champs reçus dans req.body:', req.body);
    console.log('Fichier reçu dans req.file:', req.file);
    console.log('Utilisateur connecté (req.user):', req.user);

    const { nom, description, prix, quantite, categorie_id, type_offre } = req.body;
    console.log('Type d\'offre reçu:', type_offre);

    const utilisateur_id = req.user?.id;
    const image_url = req.file ? req.file.filename : null;

    // Vérifications de base
    if (!nom || !prix || !quantite || !categorie_id) {
      return res.status(400).json({ message: 'Champs obligatoires manquants.' });
    }

    // Créer l'objet produit
    const productData = {
      nom,
      description,
      prix,
      quantite,
      image_url,
      utilisateur_id,
      categorie_id,
      disponible: quantite > 0
    };

    // Ajouter type_offre seulement s'il est fourni
    if (type_offre) {
      productData.type_offre = type_offre;
    } else {
      productData.type_offre = null; // Utiliser null au lieu de chaîne vide
    }

    const product = await Produit.create(productData);
    
    res.status(201).json({ 
      message: 'Produit ajouté avec succès.',
      product 
    });

  } catch (error) {
    console.error('Erreur lors de l\'ajout du produit :', error);
    res.status(500).json({ 
      message: 'Erreur lors de l\'ajout du produit.',
      error: error.message 
    });
  }
};

export const updateProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const { nom, description, prix, quantite, categorie_id ,type_offre } = req.body;
    console.log('Type d\'offre reçu:', type_offre); // Ajoute ce log pour vérifier
    // Validation des données (ajoutez plus de validations si nécessaire)
    if (!nom || !prix || !quantite) {
      return res.status(400).json({ message: 'Les champs obligatoires sont manquants.' });
    }
    const image_url = req.file ? `/uploads/${req.file.filename}` : null;

    console.log('Données reçues dans req.body:', req.body);

    const product = await Produit.findByPk(id);
    if (!product) {
      return res.status(404).json({ message: 'Produit non trouvé.' });
    }
    const disponible = quantite > 0 ? true : false; // produit disponible si la quantité est supérieure à 0
    //mise à jour du produit
    await product.update({
      nom,
      description,
      prix,
      quantite,
      categorie_id,
      type_offre ,
      image_url: image_url || product.image_url,
      disponible // produit disponible si la quantité est supérieure à 0
    });
    // Recharger les données depuis la base pour avoir les champs à jour
    const updatedProduct = await Produit.findByPk(id, {
        include: [{
        model: Categorie,
        as: 'category',
        attributes: ['id','nom']
  }]
});

    res.status(200).json({ message: 'Produit mis à jour avec succès.', updatedProduct });
  } catch (error) {
    res.status(500).json({ message: 'Erreur lors de la mise à jour du produit.', error: error.message });
  }
};

export const deleteProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Produit.findByPk(id);
    if (!product) {
      return res.status(404).json({ message: 'Produit non trouvé.' });
    }

    await product.destroy();

    if (product.image_url) {
      const __filename = fileURLToPath(import.meta.url);
      const __dirname = path.dirname(__filename);
      const imagePath = path.join(__dirname, '../uploads', product.image_url);
      fs.unlink(imagePath, (err) => {
        if (err) console.error('Erreur lors de la suppression de l\'image:', err);
      });
    }

    res.status(200).json({ message: 'Produit supprimé avec succès.' });
  } catch (error) {
    res.status(500).json({ message: 'Erreur lors de la suppression du produit.', error });
  }
};

export const getAllProducts = async (req, res) => {
  try {
    const { page = 1, limit = 10 } = req.query;
    const offset = (page - 1) * limit;

    const products = await Produit.findAndCountAll({
      //where: { disponible: true }, //  Ne montrer que les produits disponibles aux utilisateurs
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [['createdAt', 'DESC']],
      include: [{
        model: Categorie,
        as: 'category',
        attributes: ['nom'] // on ne veut que le nom de la catégorie
      }]
    });

    res.status(200).json({
      total: products.count,
      page: parseInt(page),
      limit: parseInt(limit),
      data: products.rows,
    });
  } catch (error) {
    res.status(500).json({ message: 'Erreur lors de la récupération des produits.', error });
  }
};
//fonction pour recuperer un produit par son id (les details d'un produit)
export const getProductById = async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Produit.findByPk(id, {
      attributes: { exclude: ['categorie_id'] },
      include: [
        {
          model: Categorie,
          as: 'category',
          attributes: ['nom']
        }
      ]
    });
    if (!product) {
      return res.status(404).json({ message: 'Produit non trouvé.' });
    }
    

    res.status(200).json({ product });
  } catch (error) {
    res.status(500).json({ message: 'Erreur lors de la récupération du produit.', error });
  }
};

// Fonction pour récupérer les produits disponibles (quantité > 0)
export const getAvailableProducts = async (req, res) => {
  try {
    const utilisateur_id = req.user.id; // Récupère l'ID du vendeur (utilisateur connecté)

    // Récupérer les produits du vendeur dont la quantité est supérieure à 0
    const availableProducts = await Produit.findAll({
      where: {
        utilisateur_id: utilisateur_id,
        quantite: { [Sequelize.Op.gt]: 0 }, // Quantité > 0
      },
      order: [['createdAt', 'DESC']],
    });

    res.status(200).json({ products: availableProducts });
  } catch (error) {
    console.error('Erreur lors de la récupération des produits disponibles :', error);
    res.status(500).json({
      message: 'Erreur lors de la récupération des produits disponibles.',
      error: error.message || error.toString(),
    });
  }
};

// Fonction pour récupérer les produits indisponibles (quantité = 0)
export const getUnavailableProducts = async (req, res) => {
  try {
    const utilisateur_id = req.user.id; // Récupère l'ID du vendeur (utilisateur connecté)

    // Récupérer les produits du vendeur dont la quantité est égale à 0
    const unavailableProducts = await Produit.findAll({
      where: {
        utilisateur_id: utilisateur_id,
        quantite: 0 // Quantité = 0
      }
    });

    res.status(200).json({ products: unavailableProducts });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur lors de la récupération des produits indisponibles.', error });
  }
};

// Fonction pour mettre a jour la quantite d'un produit après un achat 
export const updateProductQuantityAfterPurchase = async (req, res) => {
  try {
    const { id } = req.params; // ID du produit
    const { quantityPurchased } = req.body; // Quantité achetée (transmise dans le corps de la requête)

    // Récupérer le produit
    const product = await Produit.findByPk(id);
    if (!product) {
      return res.status(404).json({ message: 'Produit non trouvé.' });
    }

    // Mettre à jour la quantité du produit
    const newQuantity = product.quantite - quantityPurchased;
    if (newQuantity < 0) {
      return res.status(400).json({ message: 'Quantité insuffisante.' });
    }

    await product.update({ quantite: newQuantity });

    // Si la quantité devient 0, le produit devient indisponible
    if (newQuantity === 0) {
      await product.update({ disponible: false });
    }

    res.status(200).json({ message: 'Quantité mise à jour avec succès.', product });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur lors de la mise à jour de la quantité du produit.', error });
  }
};

// fonction pour recuperer le produit d'un vendeur qui devenu indisponible
export const restoreProduct = async (req, res) => {
  try {
    const { id } = req.params; // ID du produit
    const { newQuantity } = req.body;
    if (newQuantity <= 0) {
      return res.status(400).json({ message: 'La quantité doit etre superieur à 0.' });
    }
    // Récupérer le produit
    const product = await Produit.findByPk(id);
    if (!product) {
      return res.status(404).json({ message: 'Produit non trouvé.' });
    }

     await product.update({
      quantite: newQuantity,
      disponible: true
    });

    res.status(200).json({ message: 'Produit restauré avec succès.', product });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur lors de la restauration du produit.', error });
  }
};
// fonction pour rechercher un produit par son nom
export const searchProductByName = async (req, res) => {
  try {
    const { nom } = req.query; // Récupérer le nom du produit depuis la requête

    // Rechercher le produit par son nom
    const product = await Produit.findAll({
      where: {
        nom: {
          [Op.like]: `%${nom}%` // Utiliser l'opérateur LIKE pour la recherche
        }
      }
    });

    if (product.length === 0) {
      return res.status(404).json({ message: 'Aucun produit trouvé.' });
    }

    res.status(200).json({ products: product });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur lors de la recherche du produit.', error });
  }
};
// fonction pour lister les produits par catégorie
export const getProductsByCategory = async (req, res) => {
  try {
    const { categorie_id } = req.params; // ID de la catégorie

    // Récupérer les produits par catégorie
    const products = await Produit.findAll({
      where: {
        categorie_id: categorie_id
      }
    });

    if (products.length === 0) {
      return res.status(404).json({ message: 'Aucun produit trouvé dans cette catégorie.' });
    }

    res.status(200).json({ products });
    
  } catch (error) {
    console.error("Erreur complète :", error);
    res.status(500).json({ message: 'Erreur lors de la récupération des produits par catégorie.', error: error.message || error });
  }
};
// focntion pour marquer un produit comme favoris
export const markProductAsFavorite = async (req, res) => {
  try {
    const { productId } = req.params; // ID du produit
    const utilisateur_id = req.user.id; // Récupérer l'ID de l'utilisateur connecté

    // Vérifier si le produit existe
    const product = await Produit.findByPk(productId);
    if (!product) {
      return res.status(404).json({ message: 'Produit non trouvé.' });
    }

    // Ajouter le produit aux favoris de l'utilisateur
    await product.addFavori(utilisateur_id);

    res.status(200).json({ message: 'Produit marqué comme favori avec succès.' });
    
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur lors de la mise à jour du produit.', error });
  }
};