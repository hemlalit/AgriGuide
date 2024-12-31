const express = require('express');
const router = express.Router();
const { registerUser, registerVendor, loginUser, loginVendor, googleLogin, facebookLogin, instaLogin } = require('../controllers/authController');
const authenticateToken = require('../middlewares/authenticateToken');

// Register
router.post('/register', registerUser);
router.post('/vendor/register', registerVendor);

// Login
router.post('/login', loginUser);
router.post('/vendor/login', loginVendor);

// other auth
router.post('/google', googleLogin);
router.post('/facebook', facebookLogin);
router.post('/instagram', instaLogin);

module.exports = router;
