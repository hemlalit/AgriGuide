const express = require('express');
const router = express.Router();
const { registerUser, loginUser, googleLogin, facebookLogin, instaLogin } = require('../controllers/authController');
const authenticateToken = require('../middlewares/authenticateToken');

// Register
router.post('/register', registerUser);

// Login
router.post('/login', loginUser);

// other auth
router.post('/google', googleLogin);
router.post('/facebook', facebookLogin);
router.post('/instagram', instaLogin);

module.exports = router;
