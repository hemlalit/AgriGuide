const axios = require('axios');
const User = require("../models/profileModel");
const Vendor = require("../models/vendorModel");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");

exports.registerUser = async (req, res) => {
  const { name, email, phone, password } = req.body;

  try {
    const userName = name.toLowerCase().replace(/\s+/g, '');
    await User.create({ name, email, phone, password, "username": userName });
    res.status(201).json({ message: "User registered successfully!" });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.registerVendor = async (req, res) => {
  const { name, email, phone, password } = req.body;

  try {
    const userName = name.toLowerCase().replace(/\s+/g, '');
    await Vendor.create({ name, email, phone, password, "username": userName });
    res.status(201).json({ message: "User registered successfully!" });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.loginUser = async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ email })
    if (!user) return res.status(404).json({ message: "User not found" });
    console.log(user);

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(400).json({ message: "Invalid credentials" });

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: "1d" });
    res.json({ token, user });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.loginVendor = async (req, res) => {
  const { email, password } = req.body;

  try {
    const vendor = await Vendor.findOne({ email });
    if (!vendor) return res.status(404).json({ message: "User not found" });
    console.log(vendor);

    const isMatch = await bcrypt.compare(password, vendor.password);
    if (!isMatch) return res.status(400).json({ message: "Invalid credentials" });

    const token = jwt.sign({ id: vendor._id }, process.env.JWT_SECRET, { expiresIn: "1d" });
    res.json({ token, vendor });
  } catch (err) {
    res.status(500).json({ error: err.message });
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