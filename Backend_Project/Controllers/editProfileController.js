import User from '../models/user.js';
import bcrypt from 'bcrypt';

export const editProfile = async (req, res) => {
  const userId = req.user.id;
  const { full_name, num_tel, ville, pays, old_password, new_password, confirm_password } = req.body;
  
  try {
    // 1. Trouver l'utilisateur
    const user = await User.findByPk(userId);
    if (!user) {
      return res.status(404).json({ 
        success: false,
        message: "Utilisateur non trouvé"
      });
    }

    // 2. Préparer les modifications
    const updates = {};
    if (full_name) updates.full_name = full_name;
    if (num_tel) updates.num_tel = num_tel;
    if (ville) updates.ville = ville;
    if (pays) updates.pays = pays;

    // 3. Gestion du mot de passe
    if (old_password || new_password || confirm_password) {
      // Validation des champs de mot de passe
      if (!old_password || !new_password || !confirm_password) {
        return res.status(400).json({ 
          success: false,
          message: "Tous les champs de mot de passe sont requis pour la mise à jour"
        });
      }
      
      // Vérification de l'ancien mot de passe
      const isMatch = await bcrypt.compare(old_password, user.password);
      if (!isMatch) {
        return res.status(400).json({ 
          success: false,
          message: "كلمة المرور القديمة غير صحيحة"
        });
      }

      if (new_password !== confirm_password) {
        return res.status(400).json({
          success: false,
          message: "كلمات المرور الجديدة لا تتطابق"
        });
      }

      updates.password = await bcrypt.hash(new_password, 10);
    }

    // Vérifier s'il y a des modifications
    if (Object.keys(updates).length === 0) {
      return res.status(400).json({
        success: false,
        message: "لم يتم إجراء أي تغييرات على الملف الشخصي"
      });
    }

    // Mettre à jour l'utilisateur
    await user.update(updates);
    
    // Ne pas renvoyer le mot de passe dans la réponse
    const userData = user.get({ plain: true });
    delete userData.password;

    res.status(200).json({ 
      success: true,
      message: "تم تحديث الملف الشخصي بنجاح",
      user: userData
    });

  } catch (error) {
    console.error('Erreur lors de la mise à jour du profil:', error);
    
    // Gestion spécifique des erreurs de validation Sequelize
    if (error.name === 'SequelizeUniqueConstraintError') {
      return res.status(400).json({ 
        success: false,
        message: "رقم الهاتف هذا قيد الاستخدام بالفعل",
        field: error.errors[0].path
      });
    }
    
    res.status(500).json({ 
      success: false,
      message: "خطأ في الخادم أثناء تحديث الملف الشخصي"
    });
  }
};