const multer = require('multer');
const path = require('path');

// Configure Multer for file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, './uploads');
  },
  filename: (req, file, cb) => {
    cb(null, `${Date.now()}-${file.originalname}`);
  },
});

const upload = multer({ storage });

exports.upload = upload.single('image');

exports.analyzeCropImage = async (req, res) => {
    try {
      const imagePath = req.file.path;
  
      // Interact with Python Flask AI Model
      const pythonAPI = 'http://localhost:5000/analyze';
      const response = await axios.post(pythonAPI, {
        headers: { 'Content-Type': 'multipart/form-data' },
        data: fs.createReadStream(imagePath),
      });
  
      res.json(response.data);
    } catch (err) {
      res.status(500).json({ error: 'Failed to analyze image' });
    }
  };
  
