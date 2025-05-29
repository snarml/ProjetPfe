import Cart from "../models/cartModel.js";
import Produit from "../models/productModel.js";

export const ajouterProduit = async (req, res) => {
  const { user_id, produit_id, quantite } = req.body;

  try {
    // Vérifier si le produit existe
    const produit = await Produit.findByPk(produit_id);
    if (!produit) return res.status(404).json({ message: 'Produit non trouvé' });
 
    // Vérifier si la quantité est disponible
    if (produit.quantite < quantite) {
      return res.status(400).json({ message: 'Quantité non disponible en stock' });
    }

    // Vérifier si le produit est déjà dans le panier
    let cartItem = await Cart.findOne({ where: { user_id, produit_id } });

    if (cartItem) {
      cartItem.quantite += quantite;
      await cartItem.save();
      return res.status(200).json({ message: 'Quantité mise à jour dans le panier', item: cartItem });
    }

    // Sinon, créer une nouvelle ligne dans le panier
    cartItem = await Cart.create({ user_id, produit_id, quantite });
    res.status(201).json({ message: 'Produit ajouté au panier', item: cartItem });

  } catch (error) {
    console.error('Erreur dans ajouterProduit:', error);
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};


export const modifierQuantite = async (req, res) => {
  const { user_id, produit_id, quantite } = req.body;
  try {
    const item = await Cart.findOne({ where: { user_id, produit_id } });
    if (!item) return res.status(404).json({ message: 'Produit non trouvé dans le panier' });

    item.quantite = quantite;
    await item.save();
    res.status(200).json(item);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const supprimerProduit = async (req, res) => {
  const { user_id, produit_id } = req.body;
  try {
    await Cart.destroy({ where: { user_id, produit_id } });
    res.status(200).json({ message: 'Produit supprimé du panier' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const viderPanier = async (req, res) => {
  const { user_id } = req.body;
  try {
    await Cart.destroy({ where: { user_id } });
    res.status(200).json({ message: 'Panier vidé' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const afficherPanier = async (req, res) => {
  const { user_id } = req.params;
  try {
    const panier = await Cart.findAll({
      where: { user_id },
      include: Produit
    });
    res.status(200).json(panier);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};