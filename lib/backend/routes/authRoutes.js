const express = require('express');
const router = express.Router();
const { registerUser, loginUser, googleLogin, facebookLogin, instaLogin } = require('../controllers/authController');
const authenticateToken = require('../middlewares/authenticateToken');
const { getUserProfile, updateUserProfile } = require('../controllers/userController');

// Register
router.post('/register', registerUser);

// Login
router.post('/login', loginUser);

// other auth
router.post('/google', googleLogin);
router.post('/facebook', facebookLogin);
router.post('/instagram', instaLogin);

// Get user profile
router.get('/profile', authenticateToken, getUserProfile);

// Update user profile
router.put('/profile/update', authenticateToken, updateUserProfile);

module.exports = router;
