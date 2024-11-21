require('dotenv').config();
require('./config/passportConfig');

const express = require('express');
const mongoose = require('mongoose');
const passport = require('passport')
const cors = require('cors');

const corsConfig = {
  origin: "*",
  credential: "true",
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
}

const authRoutes = require('./routes/authRoutes');
const profileRoutes = require('./routes/profileRoutes');
const expenseRoutes = require('./routes/expenseRoutes');

const app = express();

app.options("", cors(corsConfig))
app.use(cors(corsConfig))

// Middleware
app.use(express.json());
app.use(passport.initialize());

// Routes
app.use('/auth', authRoutes);
app.use('/profile', profileRoutes);
app.use('/expenses', expenseRoutes);

// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI)
  .then(() => {
    console.log('MongoDB connected')
    app.listen(5000, () => console.log('Server started on port http://localhost:5000')); // Start Server
  })
  .catch((err) => console.log(err));


