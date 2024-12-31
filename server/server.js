require('dotenv').config();

const express = require('express');
const mongoose = require('mongoose');
const passport = require('passport');
const bodyParser = require('body-parser');
const http = require('http');
const { Server } = require('socket.io');

require('./config/passportConfig');

const authRoutes = require('./routes/authRoutes');
const profileRoutes = require('./routes/profileRoutes');
const expenseRoutes = require('./routes/expenseRoutes');
const tweetRoutes = require('./routes/postRoutes'); // New tweet routes
const cropRoutes = require('./routes/cropRoutes'); 
// const chatbotRoutes = require('./routes/chatBotRoutes'); 
const marketplaceRoutes = require('./routes/marketplaceRoutes'); 
const notificationRoutes = require('./routes/notificationRoutes'); 

const app = express();

app.use(bodyParser.json());

// Middleware
app.use(express.json());
app.use(passport.initialize());

// Routes
app.use('/auth', authRoutes);
app.use('/profile', profileRoutes);
app.use('/expenses', expenseRoutes);
app.use('/post', tweetRoutes); // Integrate tweet routes
app.use('/crop', cropRoutes);
// app.use("/chatbot", chatbotRoutes);
app.use('/marketplace', marketplaceRoutes);
app.use('/sendNotification', notificationRoutes);

// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI)
  .then(() => {
    console.log('MongoDB connected');

    // Create HTTP server
    const server = http.createServer(app);
    server.listen(5000, () => console.log("Server running on port 5000"));
  })
  .catch((err) => console.error(err));
