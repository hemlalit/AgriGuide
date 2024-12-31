import 'dart:convert';
import 'package:AgriGuide/models/expense_model.dart';
import 'package:AgriGuide/services/message_service.dart';
import 'package:AgriGuide/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  double _totalExpense = 0;
  bool _isLoading = true;

  List<Expense> get expenses => _expenses;
  double get totalExpense => _totalExpense;
  bool get isLoading => _isLoading;

  final String expenseApiUrl = '$baseUrl/expenses';
  static const storage = FlutterSecureStorage();

  Future<void> fetchExpenses() async {
    final String? token = await storage.read(key: 'token');

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(expenseApiUrl),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _expenses = data.map((item) => Expense.fromJson(item)).toList();
        print('hii');
        _totalExpense = _expenses.fold(0, (sum, item) => sum + item.amount);
      } else {
        // response.error.isEmpty
        //     ? MessageService.showSnackBar('Failed to fetch expenses')
        //     : MessageService.showSnackBar(response.error);
      }
    } catch (error) {
      MessageService.showSnackBar('Can not fetch expenses');
      print('Error fetching expenses: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addExpense(String description, double amount) async {
    final String? token = await storage.read(key: 'token');

    try {
      final response = await http.post(
        Uri.parse('$expenseApiUrl/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'description': description,
          'amount': amount,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> newExpenseData = json.decode(response.body);
        final Expense newExpense = Expense.fromJson(newExpenseData);
        _expenses.add(newExpense);
        _totalExpense += newExpense.amount;
        notifyListeners();
      }
    } catch (error) {
      MessageService.showSnackBar('Can not add expense');
      print('Error adding expense: $error');
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    final String? token = await storage.read(key: 'token');

    try {
      final response = await http.delete(
        Uri.parse('$expenseApiUrl/delete/$expenseId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _expenses.removeWhere((expense) => expense.id == expenseId);
        _totalExpense = _expenses.fold(0, (sum, item) => sum + item.amount);
        notifyListeners();
      } else {
        MessageService.showSnackBar('Failed to delete expense');
      }
    } catch (e) {
      MessageService.showSnackBar('Error deleting expenses');
      print('Error deleting expense: $e');
    }
  }

  Future<void> updateExpense(
      String expenseId, String description, double amount) async {
    final String? token = await storage.read(key: 'token');

    print(expenseId);
    try {
      final response = await http.put(
        Uri.parse('$expenseApiUrl/update/$expenseId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'description': description,
          'amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> updatedExpenseData =
            json.decode(response.body);
        final Expense updatedExpense = Expense.fromJson(updatedExpenseData);
        final int index =
            _expenses.indexWhere((expense) => expense.id == expenseId);
        if (index != -1) {
          _expenses[index] = updatedExpense;
          _totalExpense = _expenses.fold(0, (sum, item) => sum + item.amount);
          notifyListeners();
        }
        MessageService.showSnackBar('Updated Successfully');
      } else {
        MessageService.showSnackBar('Failed to update expense');
      }
    } catch (e) {
      MessageService.showSnackBar('Error updating expense');
      print('Error updating expense: $e');
    }
  }
}
