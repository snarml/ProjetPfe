import express from 'express';
import { editProfile } from '../Controllers/editProfileController.js';

const router = express.Router();

router.put('/editProfile', editProfile);

export default router;
