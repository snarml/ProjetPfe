import { Service, Provider, Booking } from '../models/prestModel.js';

// --------- Services ----------
export const getAllServices = async (req, res) => {
  try {
    const services = await Service.findAll();
    res.json(services);
  } catch (err) {
    res.status(500).json({ error: 'Erreur lors de la récupération des services' });
  }
};

// --------- Providers ----------
export const getAllProviders = async (req, res) => {
  try {
    const providers = await Provider.findAll();
    res.json(providers);
  } catch (err) {
    res.status(500).json({ error: 'Erreur lors de la récupération des prestataires' });
  }
};

// --------- Bookings ----------
export const createBooking = async (req, res) => {
  try {
    const { serviceId, providerId, date, time, quantity } = req.body;
    const booking = await Booking.create({
      serviceId,
      providerId,
      date,
      time,
      quantity,
    });
    res.status(201).json(booking);
  } catch (err) {
    res.status(500).json({ error: 'Erreur lors de la création de la réservation' });
  }
};

export const getAllBookings = async (req, res) => {
  try {
    const bookings = await Booking.findAll({
      include: [Service, Provider],
    });
    res.json(bookings);
  } catch (err) {
    res.status(500).json({ error: 'Erreur lors de la récupération des réservations' });
  }
};

export const getBookingById = async (req, res) => {
  try {
    const booking = await Booking.findByPk(req.params.id, {
      include: [Service, Provider],
    });
    if (!booking) {
      return res.status(404).json({ error: 'Réservation non trouvée' });
    }
    res.json(booking);
  } catch (err) {
    res.status(500).json({ error: 'Erreur lors de la récupération de la réservation' });
  }
};

export const deleteBooking = async (req, res) => {
  try {
    const id = req.params.id;
    const deleted = await Booking.destroy({ where: { id } });
    if (!deleted) {
      return res.status(404).json({ error: 'Réservation non trouvée' });
    }
    res.json({ message: 'Réservation annulée avec succès' });
  } catch (err) {
    res.status(500).json({ error: 'Erreur lors de l\'annulation de la réservation' });
  }
};
