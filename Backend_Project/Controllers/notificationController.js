import Notification from "../models/notificationModel.js";

export const getNotificationsForUser = async (req, res) => {
  try {
    const userId = req.user.id;

    const notifications = await Notification.findAll({
      where: { user_id: userId },
      order: [['created_at', 'DESC']]
    });

    res.status(200).json(notifications);

  } catch (error) {
    console.error("Erreur getNotificationsForUser:", error);
    res.status(500).json({ message: "Erreur serveur lors de la récupération des notifications.", error: error.message });
  }
};

export const markNotificationAsRead = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;

    const notification = await Notification.findOne({ where: { id, user_id: userId } });

    if (!notification) {
      return res.status(404).json({ message: "Notification non trouvée." });
    }

    notification.is_read = true;
    await notification.save();

    res.status(200).json({ message: "Notification marquée comme lue." });

  } catch (error) {
    console.error("Erreur markNotificationAsRead:", error);
    res.status(500).json({ message: "Erreur serveur lors de la mise à jour de la notification.", error: error.message });
  }
};
