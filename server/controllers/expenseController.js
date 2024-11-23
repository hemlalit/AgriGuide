const Expense = require('../models/expenseModel');

// Add new expense
exports.addExpense = async (req, res) => {
  try {
    const { description, amount } = req.body;
    const newExpense = new Expense({
      userId: req.userId,
      description,
      amount,
      // date: req.body.date || Date.now(),
    });
    await newExpense.save();
    res.status(201).json(newExpense);
  } catch (error) {
    res.status(500).json({ error: 'Error adding expense' });
  }
};

// Get expenses by user
exports.getExpenses = async (req, res) => {
  try {
    const expenses = await Expense.find({ userId: req.userId });
    res.status(200).json(expenses);
  } catch (error) {
    res.status(500).json({ error: 'Error retrieving expenses' });
  }
};

// Update an expense
exports.updateExpense = async (req, res) => {
  try {
    const { description, amount } = req.body;
    const updatedExpense = await Expense.findByIdAndUpdate(
      req.params.id,
      { description, amount },
      { new: true }
    );
    res.status(200).json(updatedExpense);
  } catch (error) {
    res.status(500).json({ error: 'Error updating expense' });
  }
};

// Delete an expense
exports.deleteExpense = async (req, res) => {
  try {
    const expense = await Expense.findByIdAndDelete(req.params.id);
    if (!expense) {
      return res.status(404).json({ error: 'Expense not found' });
    }
    res.status(200).json({ message: 'Expense deleted successfully' });
  } catch (error) {
    console.error('Error deleting expense:', error);
    res.status(500).json({ error: 'Error deleting expense', details: error.message });
  }
};