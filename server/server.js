const { MongoClient, ServerApiVersion } = require("mongodb");
const express = require('express');
const passport = require('passport');
const cors = require('cors');

require('dotenv').config();
require('./config/passportConfig');

const authRoutes = require('./routes/authRoutes');
const profileRoutes = require('./routes/profileRoutes');
const expenseRoutes = require('./routes/expenseRoutes');

const app = express();

const corsConfig = {
  origin: "*",
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
};

const uri = process.env.MONGO_URI || "your_default_uri_here";

const client = new MongoClient(uri, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  }
});

async function connectMongoDB() {
  try {
    await client.connect();
    console.log("You successfully connected to MongoDB!");
  } catch (err) {
    console.error("Error connecting to MongoDB:", err);
    throw err; // Exit if MongoDB connection fails
  }
}

app.use(cors(corsConfig));
app.use(express.json());
app.use(passport.initialize());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/profile', profileRoutes);
app.use('/api/expenses', expenseRoutes);

connectMongoDB();

// Export for Vercel
module.exports = app;
