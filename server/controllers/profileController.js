const User = require('../models/profileModel');
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

exports.getAnotherUserProfile = async (req, res) => {
  try {
    const user = await User.findById(req.params.userId).select('-password'); // Exclude password
    if (!user) return res.status(404).json({ message: 'User not found' });
    res.json(user);
  } catch (error) {
    res.status(500).json({ message: 'Server Error', error });
  }
};

exports.updateUserProfile = async (req, res) => {
  try {
    const { name, username, email, bio, phone, profileImage, bannerImage } = req.body; // Destructure updated values from request body
    const user = await User.findById(req.userId);

    if (!user) return res.status(404).json({ message: 'User not found' });

    // Update user fields
    user.name = name || user.name;
    user.email = email || user.email;
    user.phone = phone || user.phone;
    user.bio = bio || user.bio;
    user.username = username || user.username;
    user.profileImage = profileImage || user.profileImage;
    user.bannerImage = bannerImage || user.bannerImage;

    // Save updated user
    await user.save();

    res.json(user);
  } catch (error) {
    res.status(500).json({ message: 'Server Error', error });
  }
};
