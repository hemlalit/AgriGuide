import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/providers/expense_provider.dart';
import 'package:AgriGuide/services/message_service.dart';
import 'package:AgriGuide/utils/appColors.dart';
import 'package:AgriGuide/widgets/divider_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:AgriGuide/models/expense_model.dart';

class TrackExpenseScreen extends StatefulWidget {
  const TrackExpenseScreen({super.key});

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExpenseProvider>(context, listen: false).fetchExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleData.trackEx.getString(context)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Color.fromARGB(255, 1, 128, 5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ExpenseProvider>(
          builder: (context, expenseProvider, _) {
            return expenseProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.green[50],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            context.formatString(LocaleData.totalExpense.getString(context), ['₹${expenseProvider.totalExpense}']) ,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: LocaleData.expenseDesc.getString(context),
                          filled: true,
                          fillColor: Colors.green[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: LocaleData.amount.getString(context),
                          filled: true,
                          fillColor: Colors.green[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => _addExpense(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(LocaleData.addExpense.getString(context)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DividerLine().horizontalDividerLine(context),
                      Expanded(
                        child: ListView.builder(
                          itemCount: expenseProvider.expenses.length,
                          itemBuilder: (context, index) {
                            final Expense expense =
                                expenseProvider.expenses[index];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
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
                              ),
                            );
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

  void _addExpense(BuildContext context) {
    final description = _descriptionController.text;
    final amount = double.tryParse(_amountController.text) ?? 0;

    if (description.isNotEmpty && amount > 0) {
      Provider.of<ExpenseProvider>(context, listen: false)
          .addExpense(description, amount);
      _descriptionController.clear();
      _amountController.clear();
    } else {
      MessageService.showSnackBar(LocaleData.fielsAreEmpty.getString(context));
    }
  }

  void _deleteExpense(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(LocaleData.areYouSure.getString(context)),
          actions: [
            TextButton(
              child: Text(LocaleData.cancel.getString(context)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(LocaleData.yes.getString(context)),
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
    _descriptionUpdateController.text = expense.description;
    _amountUpdateController.text = expense.amount.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(LocaleData.updateExpense.getString(context)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _descriptionUpdateController,
                decoration: InputDecoration(labelText: LocaleData.newDesc.getString(context)),
              ),
              TextField(
                controller: _amountUpdateController,
                decoration: InputDecoration(labelText: LocaleData.newAmt.getString(context)),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(LocaleData.cancel.getString(context)),
              onPressed: () {
                _descriptionUpdateController.clear();
                _amountUpdateController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(LocaleData.update.getString(context)),
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
    if (_descriptionUpdateController.text.isEmpty) {
      _descriptionUpdateController.text = expense.description;
    }
    if (_amountUpdateController.text.isEmpty) {
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
      MessageService.showSnackBar(LocaleData.fielsAreEmpty.getString(context));
    }
  }
}
