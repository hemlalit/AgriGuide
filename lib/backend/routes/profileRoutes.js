const express = require('express');
const router = express.Router();
const authenticateToken = require('../middlewares/authenticateToken');
const { getUserProfile, updateUserProfile } = require('../controllers/userController');

// Get user profile
router.get('/', authenticateToken, getUserProfile);

// Update user profile
router.put('/update', authenticateToken, updateUserProfile);

module.exports = router;
