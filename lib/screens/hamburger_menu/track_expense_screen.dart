// track_expenses_screen.dart
import 'package:AgriGuide/providers/expense_provider.dart';
import 'package:AgriGuide/services/message_service.dart';
import 'package:AgriGuide/utils/appColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:AgriGuide/models/expense_model.dart';

class TrackExpenseScreen extends StatefulWidget {
  const TrackExpenseScreen({Key? key}) : super(key: key);

  @override
  _TrackExpenseScreenState createState() => _TrackExpenseScreenState();
}

class _TrackExpenseScreenState extends State<TrackExpenseScreen> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionUpdateController = TextEditingController();
  final _amountUpdateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load expenses when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExpenseProvider>(context, listen: false).fetchExpenses();
    });
  }

  void _addExpense(BuildContext context) {
    final description = _descriptionController.text;
    final amount = double.tryParse(_amountController.text) ?? 0;

    if (description.isNotEmpty && amount > 0) {
      Provider.of<ExpenseProvider>(context, listen: false)
          .addExpense(description, amount);
      _descriptionController.clear();
      _amountController.clear();
    } else {
      MessageService.showSnackBar('fields are empty');
    }
  }

  void _deleteExpense(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure? '),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Provider.of<ExpenseProvider>(context, listen: false)
                    .deleteExpense(expense.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showUpdateDialog(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _descriptionUpdateController,
                decoration: const InputDecoration(labelText: 'New Description'),
              ),
              TextField(
                controller: _amountUpdateController,
                decoration: const InputDecoration(labelText: 'New Amount'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _descriptionUpdateController.clear();
                _amountUpdateController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                _updateExpense(context, expense);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateExpense(BuildContext context, Expense expense) {
    // print(_descriptionController.text+"***");
    // print(_descriptionUpdateController.text+"***");
    if (_descriptionUpdateController.text.isEmpty) {
      _descriptionUpdateController.text = expense.description;
    }else if(_amountUpdateController.text.isEmpty){
      _amountUpdateController.text = expense.amount.toString();
    }

    final description = _descriptionUpdateController.text;
    final amount = double.tryParse(_amountUpdateController.text) ?? 0;
    if (description.isNotEmpty && amount > 0) {
      Provider.of<ExpenseProvider>(context, listen: false)
          .updateExpense(expense.id, description, amount);
      _descriptionUpdateController.clear();
      _amountUpdateController.clear();
    } else {
      MessageService.showSnackBar('Fields are empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Expense'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ExpenseProvider>(
          builder: (context, expenseProvider, _) {
            return Column(
              children: [
                Text(
                  'Total Expense: ₹${expenseProvider.totalExpense}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Expense Description',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _addExpense(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.textColor,
                  ),
                  child: const Text('Add Expense'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: expenseProvider.expenses.length,
                    itemBuilder: (context, index) {
                      final Expense expense = expenseProvider.expenses[index];
                      return Card(
                          color: AppColors.backgroundColor,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(expense.description),
                            subtitle: Text(
                              DateFormat('MMM d, yyyy hh:mm')
                                  .format(expense.date),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('₹${expense.amount}'),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: Colors.green,
                                  onPressed: () {
                                    _showUpdateDialog(context, expense);
                                  },
                                ),
                                const VerticalDivider(
                                  color: Colors.grey,
                                  thickness: 1,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () {
                                    _deleteExpense(context, expense);
                                  },
                                ),
                              ],
                            ),
                          ));
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
