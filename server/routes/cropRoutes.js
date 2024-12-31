const express = require('express');
const router = express.Router();
const { upload, analyzeCropImage } = require('../controllers/cropController');

router.post('/analyze', upload, analyzeCropImage);

module.exports = router;
