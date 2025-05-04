import Produit from './productModel.js';
import Commande from './commandeModel.js';
import CommandeProduit from './commande_produit.js';
import User from './user.js';
import Categorie from './categorieModel.js';
import Actualite from './newsModel.js';

// Association Commande ↔ Produit (many-to-many via commande_produits)
Commande.belongsToMany(Produit, {
  through: CommandeProduit,
  foreignKey: 'commande_id'
});

Produit.belongsToMany(Commande, {
  through: CommandeProduit,
  foreignKey: 'produit_id'
});

// Relations supplémentaires
Commande.belongsTo(User, { foreignKey: 'utilisateur_id' });
Produit.belongsTo(User, { foreignKey: 'utilisateur_id' });
Produit.belongsTo(Categorie, { foreignKey: 'categorie_id' });

User.hasMany(Actualite, {foreignKey: 'created_by'});
Actualite.belongsTo(User, {foreignKey: 'created_by'});

export default function initAssociations() {
  // Ce fichier fait juste les belongsTo et belongsToMany entre les modèles déjà importés
}
