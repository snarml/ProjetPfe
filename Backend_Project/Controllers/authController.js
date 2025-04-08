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

// fonction d'oublier le mot de passe
export const forgetPassword = async (req, res) => {
  const { num_tel } = req.body;
  try {
    const user = await User.findOne({ where: { num_tel } });
    if (!user) return res.status(404).json({ message: 'Utilisateur non trouvé ❌' });

    const otp = generateOTP();
    const otpExpires = new Date();
    otpExpires.setMinutes(otpExpires.getMinutes() + 10);

    await User.update({ otp_code: otp, otp_expires: otpExpires }, { where: { num_tel } });

    await client.messages.create({
      body: `Votre code de réinitialisation de mot de passe est : ${otp}`,
      from: process.env.TWILIO_PHONE_NUMBER,
      to: num_tel
    });

    res.status(200).json({
      message: 'Un code a été envoyé pour réinitialiser le mot de passe ✅',
    });
  } catch (error) {
    console.error('Erreur lors de l’envoi du code ❌:', error);
    res.status(500).json({
      status: 'FAILED',
      message: 'Erreur serveur',
      error: error.message
    });
  }
};
// fonction de réinitialisation du mot de passe
export const resetPassword = async (req, res) => {
  const { num_tel, otp_code, new_password } = req.body;

  try {
    const user = await User.findOne({ where: { num_tel } });
    if (!user) return res.status(404).json({ message: 'Utilisateur non trouvé ❌' });

    if (user.otp_code !== otp_code) {
      return res.status(400).json({ message: 'Code OTP incorrect ❌' });
    }

    const hashedPassword = await bcrypt.hash(new_password, 10);
    await User.update({ password: hashedPassword, otp_code: null, otp_expires: null }, { where: { num_tel } });

    res.status(200).json({
      message: 'Mot de passe réinitialisé avec succès ✅',
    });
  } catch (error) {
    console.error('Erreur lors de la réinitialisation du mot de passe ❌:', error);
    res.status(500).json({
      status: 'FAILED',
      message: 'Erreur serveur',
      error: error.message
    });
  }
};
// fonction de suppression de compte  
export const deleteAccount = async (req, res) => {
  const { id } = req.params;

  try {
    const user = await User.findByPk(id);
    if (!user) return res.status(404).json({ message: 'Utilisateur non trouvé ❌' });

    await User.destroy({ where: { id } });
    res.status(200).json({
      message: 'Compte supprimé avec succès ✅',
    });
  } catch (error) {
    console.error('Erreur lors de la suppression du compte ❌:', error);
    res.status(500).json({
      status: 'FAILED',
      message: 'Erreur serveur',
      error: error.message
    });
  }
};
// fonction de mise à jour de compte  
export const updateAccount = async (req, res) => {
  const { id } = req.params;
  const { full_name, num_tel, ville, pays, password } = req.body;

  try {
    const user = await User.findByPk(id);
    if (!user) return res.status(404).json({ message: 'Utilisateur non trouvé ❌' });

    await User.update({ full_name, num_tel, ville, pays, password }, { where: { id } });
    res.status(200).json({
      message: 'Compte mis à jour avec succès ✅',
    });
  } catch (error) {
    console.error('Erreur lors de la mise à jour du compte ❌:', error);
    res.status(500).json({
      status: 'FAILED',
      message: 'Erreur serveur',
      error: error.message
    });
  }
};
// fonction de mise à jour de mot de passe
export const updatePassword = async (req, res) => {
  const { id } = req.params;
  const { password } = req.body;

  try {
    const user = await User.findByPk(id);
    if (!user) return res.status(404).json({ message: 'Utilisateur non trouvé ❌' });

    const hashedPassword = await bcrypt.hash(password, 10);
    await User.update({ password: hashedPassword }, { where: { id } });
    res.status(200).json({
      message: 'Mot de passe mis à jour avec succès ✅',
    });
  } catch (error) {
    console.error('Erreur lors de la mise à jour du mot de passe ❌:', error);
    res.status(500).json({
      status: 'FAILED',
      message: 'Erreur serveur',
      error: error.message
    });
  }
};
// Fonction de déconnexion
export const logout = (req, res) => {
  req.session.destroy((err) => {
    if (err) {
      console.error('Erreur lors de la déconnexion ❌:', err);
      return res.status(500).json({ message: 'Erreur serveur' });
    }

    // Réponse de déconnexion réussie après avoir détruit la session
    res.status(200).json({ message: 'Déconnexion réussie ✅' });
  });
};

// fonction de changement de numéro de téléphone
export const changePhone = async (req, res) => {
  const { id } = req.params;
  const { new_num_tel } = req.body; 

  try {
    const user = await User.findByPk(id);
    if (!user) return res.status(404).json({ message: 'Utilisateur non trouvé ❌' });

    // Vérification du format du nouveau numéro de téléphone
    if (!validatePhoneNumber(new_num_tel)) {
      return res.status(400).json({ message: 'Numéro de téléphone invalide' });
    }

    await User.update({ num_tel: new_num_tel }, { where: { id } });
    res.status(200).json({
      message: 'Numéro de téléphone mis à jour avec succès ✅',
    });
  } catch (error) {
    console.error('Erreur lors de la mise à jour du numéro de téléphone ❌:', error);
    res.status(500).json({
      status: 'FAILED',
      message: 'Erreur serveur',
      error: error.message
    });
  }
}
// fonction de changement de ville
export const changeCity = async (req, res) => {
  const { id } = req.params;
  const { new_ville } = req.body;

  try {
    const user = await User.findByPk(id);
    if (!user) return res.status(404).json({ message: 'Utilisateur non trouvé ❌' });

    await User.update({ ville: new_ville }, { where: { id } });
    res.status(200).json({
      message: 'Ville mise à jour avec succès ✅',
    });
  } catch (error) {
    console.error('Erreur lors de la mise à jour de la ville ❌:', error);
    res.status(500).json({
      status: 'FAILED',
      message: 'Erreur serveur',
      error: error.message
    });
  }
}
// fonction de changement de pays
export const changeCountry = async (req, res) => {
  const { id } = req.params;
  const { new_pays } = req.body;

  try {
    const user = await User.findByPk(id);
    if (!user) return res.status(404).json({ message: 'Utilisateur non trouvé ❌' });

    await User.update({ pays: new_pays }, { where: { id } });
    res.status(200).json({
      message: 'Pays mis à jour avec succès ✅',
    });
  } catch (error) {
    console.error('Erreur lors de la mise à jour du pays ❌:', error);
    res.status(500).json({
      status: 'FAILED',
      message: 'Erreur serveur',
      error: error.message
    });
  }
}
// fonction de changement de nom
export const changeName = async (req, res) => {
  const { id } = req.params;
  const { new_full_name } = req.body;

  try {
    const user = await User.findByPk(id);
    if (!user) return res.status(404).json({ message: 'Utilisateur non trouvé ❌' });

    await User.update({ full_name: new_full_name }, { where: { id } });
    res.status(200).json({
      message: 'Nom mis à jour avec succès ✅',
    });
  } catch (error) {
    console.error('Erreur lors de la mise à jour du nom ❌:', error);
    res.status(500).json({
      status: 'FAILED',
      message: 'Erreur serveur',
      error: error.message
    });
  }
}

// fonction de récupération de tous les utilisateurs
export const getAllUsers = async (req, res) => {
  try {
    const users = await User.findAll({
      attributes: { exclude: ['password', 'otp_code', 'otp_expires'] } // Masquer ces champs sensibles
    });
    res.status(200).json({
      message: 'Tous les utilisateurs récupérés avec succès ✅',
      users
    });
  } catch (err) {
    console.error('Erreur lors de la récupération des utilisateurs ❌:', err);
    res.status(500).json({ message: 'Erreur serveur', error: err.message });
  }
};
// fonction de récupération de l'utilisateur connecté
export const getConnectedUser = async (req, res) => {
  try {
    const user = await User.findByPk(req.user.id, {
      attributes: { exclude: ['password', 'otp_code', 'otp_expires'] } // Masquer ces champs sensibles
    });
    if (!user) return res.status(404).json({ message: 'Utilisateur non trouvé ❌' });

    res.status(200).json({
      message: 'Utilisateur connecté récupéré avec succès ✅',
      user
    });
  }
  catch (err) {
    console.error('Erreur lors de la récupération de l’utilisateur connecté ❌:', err);
    res.status(500).json({ message: 'Erreur serveur', error: err.message });
  }
}



