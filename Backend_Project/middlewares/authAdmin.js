export const authAdmin = (req, res, next) => {
  const user = req.user; // tu dois extraire user de ton système d'authentification (par exemple après un JWT)

  if (user?.role !== 'admin') {
    return res.status(403).json({ message: 'Accès interdit: Administrateur uniquement.' });
  }

  next();
};
