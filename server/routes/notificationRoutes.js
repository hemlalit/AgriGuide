const express = require('express');
const router = express.Router();
const { registerToken, sendPostNotification } = require('../controllers/notificationController');

router.post('/post', sendPostNotification);
router.post('/registerToken', registerToken);

module.exports = router;