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
    const actualite = await Actualite.create({ titre, description, image_url, created_by: req.user.id });

    // Trouver tous les utilisateurs agriculteurs
    const agriculteurs = await User.findAll({ where: { role: 'agriculteur' } });

    if (agriculteurs.length > 0) {
      // Créer une notification pour chaque agriculteur
      const notifications = agriculteurs.map((agriculteur) => ({
        title: `Nouvelle opportunité : ${titre}`,
        content: description,
        user_id: agriculteur.id
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
          as: 'creator' // S'assurer que l'alias correspond à ton association belongsTo
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
  }
};
