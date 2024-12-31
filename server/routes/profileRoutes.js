const express = require('express');
const router = express.Router();
const authenticateToken = require('../middlewares/authenticateToken');
const { getUserProfile, getAnotherUserProfile, updateUserProfile } = require('../controllers/profileController');

// Get user profile
router.get('/', authenticateToken, getUserProfile);
router.get('/:userId', authenticateToken, getAnotherUserProfile);

// Update user profile
router.put('/update', authenticateToken, updateUserProfile);

router.get("/:userId", getUserProfile);

module.exports = router;
