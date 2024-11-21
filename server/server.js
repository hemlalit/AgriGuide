require('dotenv').config();
require('./config/passportConfig');

const express = require('express');
const { MongoClient, ServerApiVersion } = require("mongodb");
// const mongoose = require('mongoose');
const passport = require('passport');
const cors = require('cors');

const corsConfig = {
  origin: "*",
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
};

const authRoutes = require('./routes/authRoutes');
const profileRoutes = require('./routes/profileRoutes');
const expenseRoutes = require('./routes/expenseRoutes');

const app = express();

const uri = process.env.MONGO_URI || "mongodb+srv://onlyprogramming123:hemlalit15%40mongo@cluster0.fk6td3g.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

const client = new MongoClient(uri, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  }
});

async function run() {
  try {
    // Connect the client to the server (optional starting in v4.7)
    await client.connect();
    // Send a ping to confirm a successful connection
    console.log("You successfully connected to MongoDB!");

    app.options("", cors(corsConfig));
    app.use(cors(corsConfig));

    // Middleware
    app.use(express.json());
    app.use(passport.initialize());

    // Routes
    app.use('/auth', authRoutes);
    app.use('/profile', profileRoutes);
    app.use('/expenses', expenseRoutes);

    // Start the server after a successful MongoDB connection
    app.listen(5000, () => console.log('Server started on port http://localhost:5000'));

  } catch (err) {
    console.error('Error connecting to MongoDB:', err);
  }
}
run().catch(console.dir);
