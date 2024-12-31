const jwt = require('jsonwebtoken');
const User = require('../models/profileModel');

const postMiddleware = async (req, res, next) => {
  const token = req.header('Authorization').replace('Bearer ', '');

  if (!token) {
    return res.status(401).json({ error: 'Access denied. No token provided(post).' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await User.findById(decoded.id).populate('following');

    if (!user) {
      return res.status(404).json({ error: 'User not found.' });
    }

    req.user = user;
    req.userId = user.id;
    next();
  } catch (err) {
    res.status(400).json({ error: 'Invalid token.' });
  }
};

module.exports = postMiddleware;
