import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quan_ly_chi_tieu/models/expense.dart';
import 'package:flutter/foundation.dart'; // Import for kDebugMode

class ApiService {
  // Your API URL  -  CHANGE THIS!
  final String baseUrl = 'http://10.173.143.39:3000'; // Thay đổi địa chỉ IP nếu cần

 
  Future<List<Expense>> getAllExpenses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/expenses'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((data) => Expense.fromMap(data)).toList();
      } else {
        throw Exception('Failed to load expenses: ${response.statusCode}');
      }
    } catch (e) {
      _debugPrint("getAllExpenses: Error: $e"); // Add this line
      throw Exception('Failed to load expenses: $e');
    }
  }

  Future<Expense> addExpense(Expense expense) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/expenses'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(expense.toMap()),
      );

      if (response.statusCode == 201) {
        return Expense.fromMap(jsonDecode(response.body));
      } else {
        final responseData = jsonDecode(response.body); // Attempt to decode
        throw Exception(responseData['message'] ??
            'Failed to add expense: ${response.statusCode}');
      }
    } catch (e) {
      _debugPrint("addExpense: Error: $e"); // Add this line
      throw Exception('Failed to add expense: $e');
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      _debugPrint("updateExpense: URL: $baseUrl/expenses/${expense.id}");
      _debugPrint("updateExpense: Headers: ${<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }}");
      _debugPrint(
          "updateExpense: Request Body: ${jsonEncode(expense.toMap())}");

      final response = await http.patch(
        Uri.parse('$baseUrl/expenses/${expense.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(expense.toMap()),
      );
      _debugPrint("updateExpense: Status Code: ${response.statusCode}");
      _debugPrint("updateExpense: Response Body: ${response.body}");

      if (response.statusCode != 200) {
        final responseData = jsonDecode(response.body); // Attempt to decode
        throw Exception(responseData['message'] ??
            'Failed to update expense: ${response.statusCode}');
      }
    } catch (e) {
      _debugPrint("updateExpense: Error: $e");
      throw Exception('Failed to update expense: $e');
    }
  }

  Future<void> deleteExpense(Expense expense) async {
    try {
      _debugPrint("deleteExpense: URL: $baseUrl/expenses/${expense.id}");
      _debugPrint("deleteExpense: Headers: ${<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }}");
      final response = await http.delete(
        Uri.parse('$baseUrl/expenses/${expense.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      _debugPrint("deleteExpense: Status Code: ${response.statusCode}");
      _debugPrint("deleteExpense: Response Body: ${response.body}");

      if (response.statusCode != 200) {
        final responseData = jsonDecode(response.body); // Attempt to decode
        throw Exception(responseData['message'] ??
            'Failed to delete expense: ${response.statusCode}');
      }
    } catch (e) {
      _debugPrint("deleteExpense: Error: $e");
      throw Exception('Failed to delete expense: $e');
    }
  }

  // Helper function for debugging (only in debug mode)
  void _debugPrint(String message) {
    if (kDebugMode) {
      print(message);
    }
  }
}