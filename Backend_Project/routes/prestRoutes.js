import express from 'express';
import {
  getAllServices,
  getAllProviders,
  createBooking,
  getAllBookings,
  getBookingById,
  deleteBooking,
} from '../Controllers/prestController.js';
const router = express.Router();

router.get('/services', getAllServices);
router.get('/providers', getAllProviders);
router.post('/bookings', createBooking);
router.get('/bookings', getAllBookings);
router.get('/bookings/:id', getBookingById);
router.delete('/bookings/:id', deleteBooking);

export default router;
