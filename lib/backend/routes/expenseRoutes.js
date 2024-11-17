const express = require('express');
const router = express.Router();
const { addExpense, getExpenses, updateExpense, deleteExpense } = require('../controllers/expenseController');
const authenticateToken = require('../middlewares/authenticateToken');

router.post('/add', authenticateToken, addExpense);
router.get('/', authenticateToken, getExpenses);
router.put('/update/:id', authenticateToken, updateExpense);
router.delete('/delete/:id', authenticateToken, deleteExpense);

module.exports = router;
