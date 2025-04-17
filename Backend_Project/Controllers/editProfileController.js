import User from '../models/user.js';

import bcrypt from 'bcrypt';



// fonction pour editProfile
export const editProfile = async (req, res) => {
  const userId= req.User.id;
  const { full_name, num_tel , ville ,pays, old_password, new_password, confirm_password} = req.body;
  try{
    const user = await User.findById(userId);
    if(!user) return res.status(404).json({ msg: "User not found" });
    const fields = [];
    const values = [];
    if(full_name ){
      fields.push('full_name = ?');
      values.push(full_name);
    }
    if(num_tel ){
      fields.push('num_tel = ?');
      values.push(num_tel);
      }
      if(ville ){
        fields.push('ville = ?');
        values.push(ville);
        }
        if(pays ){
          fields.push('pays = ?');
          values.push(pays);
          }
          if(old_password || new_password || confirm_password ){
            if(!old_password || !new_password || !confirm_password){
              return res.status(400).json({ msg: "Please enter all fields" });
            }
            const isMatch = await bcrypt.compare(old_password, user[0].password);
            if(!isMatch){
              return res.status(400).json({ msg: "Old password is incorrect" });

            }
            if (new_password !== confirm_password){
              return res.status(400).json({ msg: "Passwords do not match" });
            }
            const hashedPassword = await bcrypt.hash(new_password, 10);
            fields.push('password = ?');
            values.push(hashedPassword);
          }
      
          if (fields.length === 0) {
            return res.status(400).json({ message: "Aucune donnée à mettre à jour." });
          }
      
          values.push(userId);
          const updateQuery = `UPDATE users SET ${fields.join(', ')} WHERE id = ?`;
      
          await db.query(updateQuery, values);
          res.status(200).json({ message: "Profil mis à jour avec succès." });
      
        } catch (error) {
          console.error(error);
          res.status(500).json({ message: "Erreur serveur." });
        }
      };
