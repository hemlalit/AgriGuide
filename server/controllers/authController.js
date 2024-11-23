const User = require('../models/userModel');
const bcrypt = require('bcryptjs');
const axios = require('axios');
const jwt = require('jsonwebtoken');

// Register User
exports.registerUser = async (req, res) => {
  const { name, email, phone, password } = req.body;
  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = new User({ name, email, phone, password: hashedPassword });
    await newUser.save();
    res.status(201).json({ message: 'User registered successfully' });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// Login User
exports.loginUser = async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await User.findOne({ email });
    if (!user) return res.status(400).json({ message: 'User not found' });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(400).json({ message: 'Invalid credentials' });

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '1d' });
    res.json({ token, userId: user._id });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Google Login
exports.googleLogin = async (req, res) => {
  const { token } = req.body;
  try {
    const response = await axios.get(`https://oauth2.googleapis.com/tokeninfo?id_token=${token}`);
    const { email, name } = response.data;

    let user = await User.findOne({ email });
    if (!user) {
      user = new User({ email, name, googleId: response.data.sub });
      await user.save();
    }

    const jwtToken = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, { expiresIn: '1d' });
    res.json({ message: 'Google token verified', token: jwtToken, user });
  } catch (error) {
    res.status(400).json({ error: 'Invalid Google token' });
  }
};

// Facebook Login
exports.facebookLogin = async (req, res) => {
  const { token } = req.body;
  try {
    const response = await axios.get(`https://graph.facebook.com/me?access_token=${token}&fields=id,name,email`);
    const { email, name } = response.data;

    let user = await User.findOne({ email });
    if (!user) {
      user = new User({ email, name, facebookId: response.data.id });
      await user.save();
    }

    const jwtToken = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, { expiresIn: '1d' });
    res.json({ message: 'Facebook token verified', token: jwtToken, user });
  } catch (error) {
    res.status(400).json({ error: 'Invalid Facebook token' });
  }
};

// Instagram Login
exports.instaLogin = async (req, res) => {
  const { code } = req.body;
  const clientId = process.env.INSTAGRAM_CLIENT_ID;
  const clientSecret = process.env.INSTAGRAM_CLIENT_SECRET;
  const redirectUri = process.env.INSTAGRAM_REDIRECT_URI;

  try {
    const response = await axios.post(`https://api.instagram.com/oauth/access_token`, {
      client_id: clientId,
      client_secret: clientSecret,
      grant_type: 'authorization_code',
      redirect_uri: redirectUri,
      code: code,
    });
    const { user_id } = response.data;

    let user = await User.findOne({ instagramId: user_id });
    if (!user) {
      user = new User({ instagramId: user_id, name: response.data.user.full_name });
      await user.save();
    }

    const jwtToken = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, { expiresIn: '1d' });
    res.json({ message: 'Instagram token verified', token: jwtToken, user });
  } catch (error) {
    res.status(400).json({ error: 'Invalid Instagram token' });
  }
};