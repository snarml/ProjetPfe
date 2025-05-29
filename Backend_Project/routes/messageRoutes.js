import express from 'express';
import protect from '../middlewares/authMiddleware.js';
import * as messageController from '../Controllers/messageController.js';

const router = express.Router();

// Routes protégées
router.get('/:receiverId', protect, messageController.getMessages);
router.post('/upload', protect, messageController.uploadFile, messageController.sendFileMessage);
router.post('/', protect, messageController.sendMessage);

export default router;