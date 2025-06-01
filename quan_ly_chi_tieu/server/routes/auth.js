const express = require('express');
const router = express.Router();
const bodyParser = require('body-parser');
const bcrypt = require('bcryptjs');
const mongoose = require('mongoose');
const User = require('../models/user');
const Expense = require('../models/expense'); // Import model Expense
const config = require('../config');

router.use(bodyParser.json());

// Kết nối đến cơ sở dữ liệu chung
mongoose.connect(config.mongoURI, { useNewUrlParser: true, useUnifiedTopology: true })
  .catch(err => console.log(err));

router.post('/register', async (req, res) => {
  const { email, password, username } = req.body;

  try {
    let user = await User.findOne({ email });
    if (user) {
      console.error('Email already registered');
      return res.status(400).json({ message: 'Email already registered' });
    }

    user = new User({
      email,
      password: await bcrypt.hash(password, 10),
      username,
    });

    await user.save();
    console.log('User saved:', user);

    res.status(201).json({
      message: 'Registration successful',
      user: {
        _id: user._id.toString(),
        email: user.email,
        username: user.username,
      },
    });
  } catch (error) {
    console.error('Error during registration:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ email });
    if (!user) {
      console.error('Invalid email');
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      console.error('Invalid password');
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    res.status(200).json({ 
      message: 'Login successful', 
      user: { 
        id: user._id, 
        email: user.email, 
        username: user.username 
      } 
    });
  } catch (error) {
    console.error('Error during login:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

router.post('/forgot-password', async (req, res) => {
  const { email } = req.body;

  try {
    const user = await User.findOne({ email });
    if (!user) {
      console.error('Email not found');
      return res.status(404).json({ message: 'Email not found' });
    }

    res.status(200).json({ message: 'Password reset email sent' });
  } catch (error) {
    console.error('Error during password reset:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
