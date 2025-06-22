import Actualite from "../models/newsModel.js";
import User from "../models/user.js";
import Notification from "../models/notificationModel.js";

export const createActualite = async (req, res) => {
  try {
    const { titre, description, image_url } = req.body;
    

    if (!titre || !description) {
      return res.status(400).json({ message: "Titre et la description sont obligatoires." });
    }

    const created_by = req.user.id;

    // Créer l'actualité
    const actualite = await Actualite.create({ titre, description, image_url, created_by });

    // Trouver tous les utilisateurs agriculteurs
    const agriculteurs = await User.findAll({ where: { role: 'agriculteur' } });

    if (agriculteurs.length > 0) {
      // Créer une notification pour chaque agriculteur
      const notifications = agriculteurs.map((agriculteur) => ({
        titre: `Nouvelle opportunité : ${titre}`,
        description: description,
        utilisateur_id: agriculteur.id
      }));

      await Notification.bulkCreate(notifications);
    }

    res.status(201).json({ 
      message: "Actualité ajoutée avec succès !",
      actualite
    });

  } catch (error) {
    console.error("Erreur createActualite:", error);
    res.status(500).json({ message: "Erreur serveur lors de la création de l'actualité.", error: error.message });
  }
};

export const getAllActualites = async (req, res) => {
  try {
    const actualites = await Actualite.findAll({
      order: [['created_at', 'DESC']],
      include: [
        {
          model: User,
          attributes: ['id', 'full_name'],
          as: 'creator' 
        }
      ]
    });

    res.status(200).json(actualites);

  } catch (error) {
    console.error("Erreur getAllActualites:", error);
    res.status(500).json({ message: "Erreur serveur lors de la récupération des actualités.", error: error.message });
  }
};

export const deleteActualite = async (req, res) => {
  try {
    const { id } = req.params;

    const deleted = await Actualite.destroy({ where: { id } });

    if (!deleted) {
      return res.status(404).json({ message: "Actualité non trouvée." });
    }

    res.status(200).json({ message: "Actualité supprimée avec succès !" });

  } catch (error) {
    console.error("Erreur deleteActualite:", error);
    res.status(500).json({ message: "Erreur serveur lors de la suppression de l'actualité.", error: error.message });
  }};
  // fonction pour modifier une actualité
  export const updateActualite = async (req, res) => {
    try {
      const { id } = req.params;
      const { titre, description, image_url } = req.body;
  
      const actualite = await Actualite.findByPk(id);
      if (!actualite) {
        return res.status(404).json({ message: "Actualité non trouvée." });
      }
  
      // Contrôle d'accès (optionnel mais recommandé)
      if (req.user.id !== actualite.created_by) {
        return res.status(403).json({ message: "Non autorisé à modifier cette actualité." });
      }
  
      if (titre !== undefined) actualite.titre = titre;
      if (description !== undefined) actualite.description = description;
      if (image_url !== undefined) actualite.image_url = image_url;
  
      await actualite.save();
      // Envoyer une notification à tous les agriculteurs
    const agriculteurs = await User.findAll({ where: { role: 'agriculteur' } });

    if (agriculteurs.length > 0) {
      const notifications = agriculteurs.map((agriculteur) => ({
        titre: `Mise à jour : ${actualite.titre}`,
        description: `L'actualité "${actualite.titre}" a été mise à jour. Consultez les nouveautés.`,
        utilisateur_id: agriculteur.id
      }));

      await Notification.bulkCreate(notifications);
    }
  
      res.status(200).json({ message: "Actualité mise à jour avec succès !", actualite });
  
    } catch (error) {
      console.error("Erreur updateActualite:", error);
      res.status(500).json({ message: "Erreur serveur lors de la mise à jour de l'actualité.", error: error.message });
    } 
  };
  

