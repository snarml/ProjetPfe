import jwt from 'jsonwebtoken';
import RoleChangeRequest from '../models/roleChangeRequest.js';
import User from '../models/user.js';

export const requestRoleChange = async (req, res) => {
  const { requested_role } = req.body;

  // Récupération du token depuis les headers
  const authHeader = req.headers['authorization'];
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'تم الرفض. لم يتم توفير الرمز.' });
  }

  const token = authHeader.split(' ')[1];

  try {
    // Vérification du token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const userId = decoded.id; // Récupération de l'ID utilisateur depuis le token

    // Création de la demande de changement de rôle
    const request = await RoleChangeRequest.create({
      user_id: userId,
      requested_role,
    });

    res.status(201).json({ message: 'تم إرسال الطلب بنجاح.', request });
  } catch (error) {
    if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({ message: 'Token invalide.' });
    }
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({ message: 'Le token a expiré.' });
    }
    res.status(500).json({ error: error.message });
  }
};

// ➔ Admin voit toutes les demandes
export const listRoleChangeRequests = async (req, res) => {
  const { page = 1, limit = 10 } = req.query; // Pagination
  const offset = (page - 1) * limit;

  try {
    const requests = await RoleChangeRequest.findAndCountAll({
      include: [
        {
          model: User,
          as: 'user',
          attributes: { exclude: ['password', 'created_at', 'updated_at'] },
        },
      ],
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [['createdAt', 'DESC']], // Trie par date de création
    });

    res.status(200).json({
      total: requests.count,
      page: parseInt(page),
      limit: parseInt(limit),
      data: requests.rows,
    });
  } catch (error) {
    console.error('Erreur lors de la récupération des demandes de changement de rôle ❌:', error);
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};
// ➔ Admin accepte ou rejette une demande
export const updateRoleChangeRequest = async (req, res) => {
  const { id } = req.params;
  const { action } = req.body; // action = "approve" ou "reject"

  try {
    const request = await RoleChangeRequest.findByPk(id);
    if (!request) return res.status(404).json({ message: 'Demande introuvable.' });

    if (action === 'approve') {
      await User.update({ role: request.requested_role }, { where: { id: request.user_id } });
      request.status = 'approuvé';
    } else if (action === 'reject') {
      request.status = 'rejeté';
    } else {
      return res.status(400).json({ message: 'Action invalide.' });
    }

    await request.save();
    res.json({ message: 'Demande mise à jour.', request });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
