const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// Tạo schema cho Expense
const ExpenseSchema = new Schema({
  title: {
    type: String,
    required: true
  },
  amount: {
    type: Number,
    required: true
  },
  date: {
    type: Date,
    default: Date.now
  },
  category: {
    type: String,
    required: true
  },
  type: {
    type: String,
    required: true
  }
});

module.exports = mongoose.model('Expense', ExpenseSchema);
