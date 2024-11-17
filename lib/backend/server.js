require('dotenv').config();
require('./config/passportConfig');

const express = require('express');
const mongoose = require('mongoose');
const passport = require('passport')

const authRoutes = require('./routes/authRoutes');
const profileRoutes = require('./routes/profileRoutes');
const expenseRoutes = require('./routes/expenseRoutes');
const router = express.Router();

const app = express();

router.get("/", (req, res) => {
  res.send("App is running..");
});

// Middleware
app.use(express.json());
app.use(passport.initialize());

// Routes
app.use('/auth', authRoutes);
app.use('/profile', profileRoutes);
app.use('/expenses', expenseRoutes);

// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
  .then(() => {
    console.log('MongoDB connected')
    app.listen(5000, () => console.log('Server started on port 5000')); // Start Server
  })
  .catch((err) => console.log(err));


