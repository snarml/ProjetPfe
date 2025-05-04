import Commande from '../models/commandeModel.js';
import Produit from '../models/productModel.js';
import CommandeProduit from '../models/commande_produit.js';
import Cart from '../models/cartModel.js';

export const passerCommande = async (req, res) => {
  try {
    const utilisateur_id = req.body.user_id;

    const panier = await Cart.findAll({ where: { user_id: utilisateur_id } });

    if (!panier || panier.length === 0) {
      return res.status(400).json({ message: 'Panier vide' });
    }

    const commande = await Commande.create({ utilisateur_id, total: 0 });
    let total = 0;

    for (const item of panier) {
      const produit = await Produit.findByPk(item.produit_id);

      if (!produit || produit.quantite < item.quantite) {
        continue;
      }

      await CommandeProduit.create({
        commande_id: commande.id,
        produit_id: item.produit_id,
        quantite: item.quantite
      });

      total += produit.prix * item.quantite;

      // Met à jour le stock du produit
      await produit.update({ quantite: produit.quantite - item.quantite });
    }

    // Met à jour le total de la commande
    await commande.update({ total });

    // Vide le panier après commande
    await Cart.destroy({ where: { user_id: utilisateur_id } });

    res.status(201).json({ message: 'Commande passée avec succès', commande });
  } catch (error) {
    console.error(error);
    console.error("Erreur dans passerCommande:", error); 

    res.status(500).json({ message: 'Erreur serveur', error });
  }
};

export const getCommandesUtilisateur = async (req, res) => {
  const utilisateurId = req.params.id;

  if (!utilisateurId) {
    return res.status(400).json({ message: 'ID utilisateur manquant' });
  }

  try {
    const commandes = await Commande.findAll({
      where: { utilisateur_id: utilisateurId },
      include: [{
        model: Produit,
        through: { attributes: ['quantite'] } // depuis table pivot commande_produits
      }]
    });

    res.status(200).json(commandes);
  } catch (error) {
    console.error('Erreur lors de la récupération des commandes :', error);
    res.status(500).json({ message: 'Erreur serveur', error });
  }
};

export const annulerCommande = async (req, res) => {
  try {
    const commande = await Commande.findByPk(req.params.id);
    if (!commande) {
      return res.status(404).json({ message: 'Commande introuvable' });
    }

    await commande.update({ status: 'annulée' });
    res.status(200).json({ message: 'Commande annulée' });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error });
  }
};
