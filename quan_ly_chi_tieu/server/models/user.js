const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
  username: {
    type: String,
    unique: true, 
    default: null, 
  },
});

const User = mongoose.model('User', UserSchema);

module.exports = User;
