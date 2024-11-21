const mongoose = require('mongoose');

const expenseSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    ref: 'User',
  },
  description: {
    type: String,
    required: true,
  },
  amount: {
    type: Number,
    required: true,
  },
  date: {
    type: Date,
    default: () => {
      const date = new Date();
      return new Date(date.getTime() + (5.5 * 60 * 60 * 1000)); // Set to IST
    },
  },
});

module.exports = mongoose.model('Expense', expenseSchema);
