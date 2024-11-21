require('dotenv').config(); // Load environment variables
require('./config/passportConfig'); // Passport configuration

const express = require('express');
const { MongoClient, ServerApiVersion } = require("mongodb");
const passport = require('passport');
const cors = require('cors');

// Routes
const authRoutes = require('./routes/authRoutes');
const profileRoutes = require('./routes/profileRoutes');
const expenseRoutes = require('./routes/expenseRoutes');

// Initialize Express app
const app = express();

// MongoDB Connection
const uri = process.env.MONGO_URI || "mongodb+srv://onlyprogramming123:hemlalit15%40mongo@cluster0.fk6td3g.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";
const client = new MongoClient(uri, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  }
});

let isMongoConnected = false;

async function connectMongoDB() {
  try {
    if (!isMongoConnected) {
      await client.connect();
      isMongoConnected = true;
      console.log("MongoDB successfully connected!");
    }
  } catch (err) {
    console.error("MongoDB connection error:", err);
    throw new Error("Failed to connect to MongoDB");
  }
}

// Middleware
app.use(cors({ origin: "*", credentials: true, methods: ['GET', 'POST', 'PUT', 'DELETE'] }));
app.use(express.json());
app.use(passport.initialize());

// Ensure MongoDB is connected before handling requests
app.use(async (req, res, next) => {
  try {
    await connectMongoDB();
    next();
  } catch (err) {
    res.status(500).json({ message: "Database connection failed", error: err.message });
  }
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/profile', profileRoutes);
app.use('/api/expenses', expenseRoutes);

// Error Handling
app.use((err, req, res, next) => {
  console.error("Unhandled error:", err);
  res.status(500).json({ message: "Internal Server Error", error: err.message });
});

// 404 Handler
app.use((req, res) => {
  res.status(404).json({ message: "Route not found" });
});

module.exports = app; // Export for serverless deployment
