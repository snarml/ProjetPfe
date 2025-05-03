import express from 'express';
import { editProfile } from '../Controllers/editProfileController.js';
import verifyToken from '../middlewares/authMiddleware.js';

const router = express.Router();

router.put('/editProfile',verifyToken, editProfile);

export default router;
