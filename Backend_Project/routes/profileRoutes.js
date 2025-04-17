import express from 'express';
import { editProfile } from '../Controllers/editProfileController.js';
import { verifyToken} from '../middlewares/authMiddleware.js';

const router = express.Router();

// Route : PUT /api/profile/edit
router.put('/editProfile', verifyToken, editProfile);

export default router;
