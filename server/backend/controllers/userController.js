const User = require('../models/userModel');
const jwt = require('jsonwebtoken');

exports.getUserProfile = async (req, res) => {
    try {
        const user = await User.findById(req.userId).select('-password'); // Exclude password
        if (!user) return res.status(404).json({ message: 'User not found' });
        res.json(user);
    } catch (error) {
        res.status(500).json({ message: 'Server Error', error });
    }
};

exports.updateUserProfile = async (req, res) => {
    try {
      const { name, email, phone, profileImageUrl } = req.body; // Destructure updated values from request body
      const user = await User.findById(req.userId);
  
      if (!user) return res.status(404).json({ message: 'User not found' });
  
      // Update user fields
      user.name = name || user.name;
      user.email = email || user.email;
      user.phone = phone || user.phone;
      user.profileImageUrl = profileImageUrl || user.profileImageUrl;
  
      // Save updated user
      await user.save();
  
      res.json(user);
    } catch (error) {
      res.status(500).json({ message: 'Server Error', error });
    }
  };
  