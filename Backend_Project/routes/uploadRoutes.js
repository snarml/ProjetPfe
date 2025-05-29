import express from 'express';
import { verifyToken } from '../middlewares/authMiddleware.js';
import multer from 'multer';

const router = express.Router();

// Configuration Multer
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + '-' + file.originalname);
  },
});

const upload = multer({ storage });

router.use(verifyToken); // Middleware d'auth

router.post('/', upload.single('image'), (req, res) => {
  try {
    res.status(200).json({
      imageUrl: `/uploads/${req.file.filename}`,
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

export default router; 