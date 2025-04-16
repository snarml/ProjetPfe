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
const serviceSid = process.env.TWILIO_VERIFY_SERVICE_SID; // SID du service d'authentification Twilio

// fonction de validation de numéro de telephone 
const validatePhoneNumber = (num_tel) => {
  const phoneRegex = /^\+216\d{8}$/;  // Ex. : pour la Tunisie, le numéro doit commencer par +216 et avoir 8 chiffres
  return phoneRegex.test(num_tel);
};
// 🔹 Enregistrer un utilisateur (version avec Sequelize + OTP)
// 🔹 Fonction d'ajout d'un utilisateur (envoie d'otp + JWT)
export const addUser = async (req, res) => {
  const { full_name, num_tel, ville, pays, password } = req.body;

  if (!full_name || !num_tel || !ville || !pays || !password) {
    return res.status(400).json({
      status: 'فشل',
      message: 'جميع الحقول مطلوبة',
    });
  }

  // Validation du numéro de téléphone
  if (!validatePhoneNumber(num_tel)) {
    return res.status(400).json({ message: 'رقم الهاتف غير صالح' });
  }

  // Vérification de la longueur du mot de passe
  if (password.length < 8) {
    return res.status(400).json({ message: 'كلمة المرور يجب أن تحتوي على 8 أحرف على الأقل' });
  }

  try {
    // Vérifier si l'utilisateur existe déjà
    const existingUser = await User.findOne({ where: { num_tel } });
    if (existingUser) {
      return res.status(400).json({ message: 'المستخدم موجود بالفعل ' });
    }
    // Envoyer OTP
    try{ 
      await sendOtp(num_tel);
      // Générer token temporaire avec les infos utilisateur
    const token = jwt.sign(
      { full_name, num_tel, ville, pays, password },
      process.env.JWT_SECRET,
      { expiresIn: '10m' } // expire dans 10 minutes
    );

    return res.status(200).json({
      message: 'تم إرسال رمز التحقق عبر الرسائل القصيرة ',
      token, // à utiliser dans la vérification OTP
    });

  } catch(otpError){
    console.error('Erreur Twilio  ', otpError);
    return res.status(500).json({message: 'حدث خطأ أثناء إرسال رمز التحقق '});
  }
  } catch (error) {
    console.error('خطأ أثناء التسجيل :', error);
    res.status(500).json({
      status: 'فشل',
      message: 'خطأ في الخادم',
      error: error.message,
    });
  }
};

// 🔹 Fonction d'envoi d'OTP via Twilio
async function sendOtp(num_tel) {
  try {
    const verification = await client.verify.services(serviceSid)
      .verifications
      .create({ to: num_tel, channel: 'sms' });
    return verification;
  } catch (error) {
    console.error('خطأ أثناء إرسال OTP :', error);
    throw new Error('فشل في إرسال رمز التحقق');
  }
}
// 🔹 Vérifier le code OTP et enregistrer l'utilisateur
export const verifyOTP = async (req, res) => {
  const { otp_code } = req.body;
  const token = req.headers['x-auth-token'];

  // Validation des entrées
  if (!token) {
    return res.status(401).json({ 
      success: false,
      message: 'Token d\'authentification manquant' 
    });
  }

  if (!otp_code || otp_code.length !== 6) {
    return res.status(400).json({ 
      success: false,
      message: 'Le code OTP doit contenir 6 chiffres' 
    });
  }

  try {
    // Vérification du token JWT
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const { num_tel, password } = decoded;

    // Vérification OTP avec Twilio
    const verificationCheck = await client.verify.v2.services(process.env.TWILIO_VERIFY_SERVICE_SID)
      .verificationChecks
      .create({ to: num_tel, code: otp_code });

    if (verificationCheck.status !== 'approved') {
      return res.status(400).json({ 
        success: false,
        message: 'Code OTP incorrect ou expiré' 
      });
    }

    // Vérifier si l'utilisateur existe déjà
    const existingUser = await User.findOne({ where: { num_tel } });
    if (existingUser) {
      return res.status(409).json({ 
        success: false,
        message: 'Ce numéro est déjà enregistré' 
      });
    }

    // Création de l'utilisateur
    const hashedPassword = await bcrypt.hash(password, 12);
    const newUser = await User.create({
      ...decoded,
      password: hashedPassword,
      is_verified: true,
    });

    // Générer un nouveau token pour la session
    const authToken = jwt.sign(
      { id: newUser.id, num_tel: newUser.num_tel },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    return res.status(201).json({
      success: true,
      message: 'Compte vérifié et créé avec succès',
      token: authToken,
      user: {
        id: newUser.id,
        num_tel: newUser.num_tel,
        is_verified: newUser.is_verified
      }
    });

  } catch (error) {
    console.error('Erreur OTP:', error);

    // Gestion spécifique des erreurs JWT
    if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({ 
        success: false,
        message: 'Token invalide' 
      });
    }

    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({ 
        success: false,
        message: 'Token expiré' 
      });
    }

    return res.status(500).json({
      success: false,
      message: 'Erreur serveur',
      error: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
};



// 🔹 Connexion utilisateur
export const login = async (req, res) => {
  const { num_tel, password } = req.body;
  

  try {
    const user = await User.findOne({ where: { num_tel } });
    if (!user) return res.status(404).json({ error: 'لم يتم العثور على المستخدم' });

    if (!user.is_verified) {
      return res.status(401).json({ error: 'لم يتم التحقق من الحساب. يرجى التحقق من رقمك' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(401).json({ error: 'كلمة مرور غير صحيحة' });

    const payload = { id: user.id, num_tel: user.num_tel };
    const token = jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '24h' });

    res.status(200).json({
      message: 'تم الاتصال بنجاح',
      token
    });
  } catch (err) {
    console.error(' :خطأ في الاتصال ', err);
    res.status(500).json({ error: 'خطأ في الخادم' });
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
  if(!num_tel) {
    return res.status(400).json({ 
      success: false,
      message: 'Numéro de téléphone obligatoire ❌' });
  }
  try {
    //verifier si l'utilisateur existe 
    const user = await User.findOne({ where: { num_tel } });
    if (!user) return res.status(404).json({ message: 'Utilisateur non trouvé ❌' });
    //envoyer un otp via TWilio verify pour la réinitalisation
    await client.verify.services(serviceSid)
      .verifications
      .create({ to: num_tel, channel: 'sms' });
    res.status(200).json({
      message: 'Un code de vérification a été envoyé par SMS pour réinitialiser le mot de passe ✅',
    });
    } catch (err) {
    console.error('Erreur lors de l\'envoi de l\'OTP ❌:', err);
    res.status(500).json({
      status: 'FAILED',
      message: 'Erreur serveur',
      error: err.message
    });
  }
};
// fonction de réinitialisation du mot de passe
export const resetPassword = async (req, res) => {
  const { num_tel, otp_code, new_password } = req.body;
  // Vérification des champs requis
  if (!num_tel || !otp_code || !new_password) {
    return res.status(400).json({ message: 'Tous les champs sont obligatoires ❌' });
  }


  try {
    const user = await User.findOne({ where: { num_tel } });
    if (!user) return res.status(404).json({ message: 'Utilisateur non trouvé ❌' });

    if (user.otp_code !== otp_code) {
      return res.status(400).json({ message: 'Code OTP incorrect ❌' });
    }
    //vérifier si le code otp est correct via twilio 
    const verificationCheck = await client.verify.services(serviceSid)
      .verificationChecks
      .create({ to: num_tel, code: otp_code });
    if (verificationCheck.status === 'approved') {
      // Mise à jour du mot de passe
      const hashedPassword = await bcrypt.hash(new_password, 10);
      user.password = hashedPassword;
      await user.save();
      res.status(200).json({
        message: 'Mot de passe réinitialisé avec succès ✅',
      });
      } else {
      return res.status(400).json({ message: 'Code OTP incorrect ❌' });
      }
      } catch (err) {
        console.error('Erreur lors de la réinitialisation du mot de passe ❌:', err);
        res.status(500).json({
          status: 'FAILED',
          message: 'Erreur serveur',
          error: err.message
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



