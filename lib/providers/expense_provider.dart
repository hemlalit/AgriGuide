import 'dart:convert';
import 'package:AgriGuide/models/expense_model.dart'; // Ensure this is your Expense model
import 'package:AgriGuide/services/message_service.dart';
import 'package:AgriGuide/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ExpenseProvider with ChangeNotifier {
  final storage = const FlutterSecureStorage();

  List<Expense> _expenses = [];
  double _totalExpense = 0;
  List<Expense> get expenses => _expenses;
  double get totalExpense => _totalExpense;

  final String expenseApiUrl = '$baseUrl/expenses';

  Future<void> fetchExpenses() async {
    try {
      final String? token = await storage.read(key: 'token');
      final response = await http.get(
        Uri.parse(expenseApiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _expenses = data.map((item) => Expense.fromJson(item)).toList();
        _totalExpense = _expenses.fold(0, (sum, item) => sum + item.amount);
        notifyListeners();
      }
    } catch (error) {
      print('Error fetching expenses: $error');
    }
  }

  Future<void> addExpense(String description, double amount) async {
    try {
      final String? token = await storage.read(key: 'token');
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
      print('Error adding expense: $error');
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      final String? token = await storage.read(key: 'token');
      final response = await http.delete(
        Uri.parse('$expenseApiUrl/delete/$expenseId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        _expenses.removeWhere((expense) => expense.id == expenseId);
        _totalExpense = _expenses.fold(0, (sum, item) => sum + item.amount);
        notifyListeners();
      } else {
        MessageService.showSnackBar('Failed to delete expense');
        // print('Failed to delete expense');
      }
    } catch (e) {
      print('Error deleting expense: $e');
    }
  }

  Future<void> updateExpense(
      String expenseId, String description, double amount) async {
    try {
      final String? token = await storage.read(key: 'token');
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
