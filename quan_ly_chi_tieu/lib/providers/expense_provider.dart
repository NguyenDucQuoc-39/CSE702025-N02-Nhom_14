import 'package:flutter/foundation.dart';
import 'package:quan_ly_chi_tieu/models/expense.dart';
import 'package:quan_ly_chi_tieu/services/api_service.dart';
import 'package:intl/intl.dart';

class ExpenseProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Expense> _expenses = [];
  List<Expense> _filteredExpenses = [];
  String? _email; // Thêm thuộc tính email

  ExpenseProvider() {
    fetchExpenses();
  }

  List<Expense> get expenses => _filteredExpenses;
  String? get email => _email; // Getter cho thuộc tính email

  Future<void> fetchExpenses() async {
    try {
      _expenses = await _apiService.getAllExpenses();
      _filteredExpenses = _expenses;
      _debugPrint("fetchExpenses successful: ${_expenses.length} expenses");
      notifyListeners();
    } catch (e) {
      _debugPrint("Error fetching expenses: $e");
      throw Exception("Failed to fetch expenses: $e");
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      final newExpense = await _apiService.addExpense(expense);
      _expenses.add(newExpense);
      _filteredExpenses = List.from(_expenses); // Create a new list
      _debugPrint("addExpense successful: ${newExpense.toMap()}"); // Debug print. Use toMap()
      notifyListeners();
    } catch (e) {
      _debugPrint("Error adding expense: $e");
      throw Exception("Failed to add expense: $e");
    }
  }

  Future<void> updateExpense(Expense updatedExpense) async {
    try {
      await _apiService.updateExpense(updatedExpense);
      // Find the index of the updated expense
      final index = _expenses.indexWhere((e) => e.id == updatedExpense.id);
      if (index != -1) {
        // Update the expense in both lists
        _expenses[index] = updatedExpense;
        // Find in filter list

        final filterIndex = _filteredExpenses.indexWhere((e) => e.id == updatedExpense.id);
        if(filterIndex != -1){
            _filteredExpenses[filterIndex] = updatedExpense;
        }

        _debugPrint("updateExpense successful: ${updatedExpense.toMap()}"); //Debug
        notifyListeners();
      } else {
        // Optional: Handle the case where the expense wasn't found (shouldn't happen normally)
        _debugPrint("Expense to update not found in list: ${updatedExpense.id}");
        throw Exception("Expense to update not found");
      }
    } catch (e) {
       _debugPrint("Error updating expense: $e");
      throw Exception("Failed to update expense: $e");
    }
  }

  Future<void> deleteExpense(Expense expense) async {
    try {
      await _apiService.deleteExpense(expense);
      _expenses.removeWhere((e) => e.id == expense.id);
      _filteredExpenses = List.from(_expenses); // Create a new list
      _debugPrint("deleteExpense successful: $expense"); //Debug print
      notifyListeners();
    } catch (e) {
      _debugPrint("Error deleting expenses: $e");
      throw Exception('Failed to delete expense: $e'); // Throw an exception
    }
  }

  void searchExpenses(String query) {
    final lowercaseQuery = query.toLowerCase();

    if (query.isEmpty) {
      _filteredExpenses = List.from(_expenses);
    } else {
      _filteredExpenses = _expenses.where((expense) {
        final title = expense.title.toLowerCase();
        final category = expense.category.toLowerCase();
        final amount = expense.amount.toString();
        final type = expense.type.toLowerCase();
        final date = DateFormat('dd/MM/yyyy').format(expense.date);

        return title.contains(lowercaseQuery) ||
            category.contains(lowercaseQuery) ||
            amount.contains(query) ||
            type.contains(lowercaseQuery) ||
            date.contains(lowercaseQuery);
      }).toList();
    }
    _debugPrint(
        "searchExpenses: query: $query, results: ${_filteredExpenses.length}");
    notifyListeners();
  }

  // Setter cho thuộc tính email
  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  // Helper function for debugging (only in debug mode)
  void _debugPrint(String message) {
    if (kDebugMode) {
      print(message);
    }
  }
}