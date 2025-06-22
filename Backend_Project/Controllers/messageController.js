import multer from 'multer';
import path from 'path';
import fs from 'fs';
import { promisify } from 'util';
import sanitizeFilename from 'sanitize-filename';
//import { Message, User, sequelize } from '../models/index.js';
import AppError from '../utils/appError.js';
import { User } from '../models/initAssociations.js';
import {Message} from '../models/initAssociations.js';
import sequelize from '../config/database.js';
import { Op } from 'sequelize';

// Configuration sécurisée de multer
const storage = multer.diskStorage({
  destination: async (req, file, cb) => {
    try {
      const uploadDir = path.join(process.cwd(), 'uploads');
      
      // Vérifier/Créer le répertoire de manière asynchrone
      await promisify(fs.mkdir)(uploadDir, { recursive: true });
      
      cb(null, uploadDir);
    } catch (err) {
      cb(err);
    }
  },
  filename: (req, file, cb) => {
    try {
      const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
      const ext = path.extname(file.originalname);
      const sanitizedFilename = sanitizeFilename(
        path.basename(file.originalname, ext) + 
        '-' + uniqueSuffix + ext
      );
      
      cb(null, sanitizedFilename);
    } catch (err) {
      cb(err);
    }
  }
});

// Filtrage des types de fichiers autorisés
const fileFilter = (req, file, cb) => {
  const allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'application/pdf', 'audio/mpeg'];
  if (allowedTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new AppError('Type de fichier non supporté', 400), false);
  }
};

// Limite de taille de fichier (10MB)
const upload = multer({ 
  storage,
  fileFilter,
  limits: { fileSize: 10 * 1024 * 1024 } 
});

// Middleware pour le téléchargement de fichiers
export const uploadFile = upload.single('file');

// Fonction améliorée pour envoyer un message avec fichier
export const sendFileMessage = async (req, res, next) => {
  try {
    // Vérification du fichier
    if (!req.file) {
      return next(new AppError('Aucun fichier fourni', 400));
    }

    const { receiverId, type = req.file.mimetype.split('/')[0], content = '' } = req.body;
    
    // Validation des données
    if (!receiverId) {
      return next(new AppError('Destinataire manquant', 400));
    }

    // Vérifier si le destinataire existe
    const receiver = await User.findByPk(receiverId);
    if (!receiver) {
      return next(new AppError('Destinataire introuvable', 404));
    }

    // Créer l'URL sécurisée du fichier
    const fileUrl = `${req.protocol}://${req.get('host')}/uploads/${req.file.filename}`;
    
    // Créer le message avec transaction
    const transaction = await sequelize.transaction();
    
    try {
      const message = await Message.create({
        content: content || `Fichier ${type}`,
        type,
        fileUrl,
        senderId: req.user.id,
        receiverId
      }, { transaction });

      const newMessage = await Message.findByPk(message.id, {
        include: [
          { 
            model: User, 
            as: 'sender', 
            attributes: ['id', 'full_name'] 
          },
          { 
            model: User, 
            as: 'receiver', 
            attributes: ['id', 'full_name'] 
          }
        ],
        transaction
      });

      await transaction.commit();

      // Émettre l'événement via Socket.io
      req.io.to(receiverId.toString()).emit('newMessage', newMessage);
      req.io.to(req.user.id.toString()).emit('messageSent', newMessage);

      res.status(201).json({
        status: 'success',
        data: { message: newMessage }
      });
    } catch (err) {
      await transaction.rollback();
      throw err;
    }
  } catch (err) {
    // Supprimer le fichier uploadé en cas d'erreur
    if (req.file) {
      const filePath = path.join(process.cwd(), 'uploads', req.file.filename);
      if (fs.existsSync(filePath)) {
        await promisify(fs.unlink)(filePath);
      }
    }
    next(err);
  }
};

// Récupérer les messages entre l'utilisateur connecté et un destinataire
export const getMessages = async (req, res, next) => {
  try {
    const receiverId = req.params.receiverId;
    const userId = req.user.id;

    // Récupère tous les messages entre userId et receiverId, triés par date
    const messages = await Message.findAll({
      where: {
        [Op.or]: [
          { senderId: userId, receiverId: receiverId },
          { senderId: receiverId, receiverId: userId }
        ]
      },
      order: [['createdAt', 'ASC']],
      include: [
        { model: User, as: 'sender', attributes: ['id', 'full_name'] },
        { model: User, as: 'receiver', attributes: ['id', 'full_name'] }
      ]
    });

    res.status(200).json({ status: 'success', data: { messages } });
  } catch (err) {
    next(err);
  }
};

// Envoyer un message texte simple
export const sendMessage = async (req, res, next) => {
  try {
    const { receiverId, content, type = 'text' } = req.body;
    const userId = req.user.id;

    if (!receiverId || !content) {
      return next(new AppError('Destinataire ou contenu manquant', 400));
    }

    // Vérifier si le destinataire existe
    const receiver = await User.findByPk(receiverId);
    if (!receiver) {
      return next(new AppError('Destinataire introuvable', 404));
    }

    const message = await Message.create({
      content,
      type,
      senderId: userId,
      receiverId
    });

    const newMessage = await Message.findByPk(message.id, {
      include: [
        { model: User, as: 'sender', attributes: ['id', 'full_name'] },
        { model: User, as: 'receiver', attributes: ['id', 'full_name'] }
      ]
    });

    // Émettre l'événement via Socket.io
    req.io.to(receiverId.toString()).emit('newMessage', newMessage);
    req.io.to(userId.toString()).emit('messageSent', newMessage);

    res.status(201).json({ status: 'success', data: { message: newMessage } });
  } catch (err) {
    next(err);
  }
};