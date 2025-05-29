//const Message = db.Message;
//const User = db.User;

const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { promisify } = require('util');
const sanitizeFilename = require('sanitize-filename');
const { Message, User } = require('../models');
const AppError = require('../utils/appError');

// Configuration sécurisée de multer
const storage = multer.diskStorage({
  destination: async (req, file, cb) => {
    try {
      const uploadDir = path.join(__dirname, '../uploads');
      
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
exports.uploadFile = upload.single('file');

// Fonction améliorée pour envoyer un message avec fichier
exports.sendFileMessage = async (req, res, next) => {
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
            attributes: ['id', 'username', 'profileImage'] 
          },
          { 
            model: User, 
            as: 'receiver', 
            attributes: ['id', 'username', 'profileImage'] 
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
      const filePath = path.join(__dirname, '../uploads', req.file.filename);
      if (fs.existsSync(filePath)) {
        await promisify(fs.unlink)(filePath);
      }
    }
    next(err);
  }
};