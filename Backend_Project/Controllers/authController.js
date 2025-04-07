import User from '../models/user.js';
import twilio from 'twilio';
import dotenv from 'dotenv';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

// Charger les variables d'environnement
dotenv.config();

// Configurer Twilio
const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const client = twilio(accountSid, authToken);

// Générer un OTP aléatoire
const generateOTP = () => Math.floor(100000 + Math.random() * 900000).toString();

// fonction de validation de numéro de telephone 
const validatePhoneNumber = (num_tel) => {
  const phoneRegex = /^\+216\d{8}$/;  // Ex. : pour la Tunisie, le numéro doit commencer par +216 et avoir 8 chiffres
  return phoneRegex.test(num_tel);
};
// 🔹 Enregistrer un utilisateur (version avec Sequelize + OTP)
export const addUser = async (req, res) => {
  const { full_name, num_tel, ville, pays, password } = req.body;

  if (!full_name || !num_tel || !ville || !pays || !password) {
    return res.status(400).json({
      status: 'FAILED',
      message: 'Tous les champs sont obligatoires',
    });
  }
  // Validation du numéro de téléphone
  if (!validatePhoneNumber(num_tel)) {
    return res.status(400).json({ message: 'Numéro de téléphone invalide' });
  }
  // Vérification de la longueur du mot de passe
  if (password.length < 8) {
    return res.status(400).json({ message: 'Le mot de passe doit contenir au moins 8 caractères' });
  }
  

  try {
    const existingUser = await User.findOne({ where: { num_tel } });
    if (existingUser) {
      return res.status(400).json({ message: 'Utilisateur déjà existant ❌' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const otp = generateOTP();
    const otpExpires = new Date();
    otpExpires.setMinutes(otpExpires.getMinutes() + 10);

    const newUser = await User.create({
      full_name,
      num_tel,
      ville,
      pays,
      password: hashedPassword,
      otp_code: otp,
      otp_expires: otpExpires,
      is_verified: false
    });

    await client.messages.create({
      body: `Votre code de vérification est : ${otp}`,
      from: process.env.TWILIO_PHONE_NUMBER,
      to: num_tel
    });

    res.status(201).json({
      status: 'SUCCESS',
      message: 'Inscription réussie. Un OTP a été envoyé par SMS.',
    });

  } catch (error) {
    console.error('Erreur lors de l’inscription ❌:', error);
    res.status(500).json({
      status: 'FAILED',
      message: 'Erreur serveur',
      error: error.message
    });
  }

};


// 🔹 Vérifier le code OTP
export const verifyOTP = async (req, res) => {
  const { num_tel, otp_code } = req.body;

  try {
    const user = await User.findOne({ where: { num_tel } });
    if (!user) return res.status(404).json({ error: 'Utilisateur non trouvé' });
    const now = new Date();

    //Si le code expire , on génère un nouveau code
    if (user.otp_expires && now > user.otp_expires) {
      const newOTP = generateOTP();
      const newExpires = new Date();
      newExpires.setMinutes(newExpires.getMinutes() + 10);

      // Mise à jour de l'utilisateur avec le nouveau OTP
      await User.update(
        { otp_code: newOTP, otp_expires: newExpires },
        { where: { num_tel } }
      );
      // Envoi du nouveau OTP par SMS
      await client.messages.create({
        body: `Votre nouveau code de vérification est : ${newOTP}`,
        from: process.env.TWILIO_PHONE_NUMBER,
        to: num_tel
      });

      return res.status(400).json({
        message: 'Le code OTP a expiré. Un nouveau code a été envoyé.',
      });
    }
    // Vérification du code OTP

    if (user.otp_code !== otp_code) {
      return res.status(400).json({ error: 'Code OTP incorrect' });
    }

    //Validation du compte 

    await User.update({ is_verified: true, otp_code: null, otp_expires: null }, { where: { num_tel } });

    res.status(200).json({ message: 'Compte vérifié avec succès ✅' });
  } catch (err) {
    console.error('Erreur OTP ❌:', err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
};


// 🔹 Connexion utilisateur
export const login = async (req, res) => {
  const { num_tel, password } = req.body;

  try {
    const user = await User.findOne({ where: { num_tel } });
    if (!user) return res.status(404).json({ error: 'Utilisateur non trouvé' });

    if (!user.is_verified) {
      return res.status(401).json({ error: 'Compte non vérifié. Veuillez vérifier votre numéro.' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(401).json({ error: 'Mot de passe incorrect' });

    const payload = { id: user.id, num_tel: user.num_tel };
    const token = jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '1h' });

    res.status(200).json({
      message: 'Connexion réussie ✅',
      token
    });
  } catch (err) {
    console.error('Erreur de connexion ❌:', err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
};


// 🔹 Récupérer un utilisateur par ID
export const getUser = async (req, res) => {
  const { id } = req.params;

  try {
    const user = await User.findByPk(id,{
      attributes: { exclude: ['password', 'otp_code', 'otp_expires'] } // Masquer ces champs sensibles
    });
    if (!user) return res.status(404).json({ message: 'Utilisateur non trouvé ❌' });

    user.password = undefined;
    res.status(200).json({
      message: 'Utilisateur récupéré avec succès ✅',
      user
    });
  } catch (err) {
    console.error('Erreur lors de la récupération ❌:', err);
    res.status(500).json({ message: 'Erreur serveur', error: err.message });
  }
};


