import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quan_ly_chi_tieu/models/user.dart';

class AuthService {
  final String baseUrl = 'http://10.173.143.39:3000/auth'; // Thay đổi địa chỉ IP nếu cần


  static User? currentUser; // Thông tin người dùng hiện tại

  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('Login Response Status Code: ${response.statusCode}');
    print('Login Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      String userId = responseData['user']['id'] ?? '';
      String userEmail = responseData['user']['email'] ?? 'Unknown Email';
      String userUsername = responseData['user']['username'] ?? 'Unknown Username';
      currentUser = User(
        id: userId,
        email: userEmail,
        username: userUsername,
        password: password,
      );
      return currentUser!;
    } else {
      try {
        final responseData = jsonDecode(response.body);
        throw Exception(responseData['message']);
      } catch (e) {
        throw Exception('Failed to login');
      }
    }
  }

  Future<User> register(String email, String password, String username) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'email': email, 'password': password, 'username': username}),
    );

    print('Register Response Status Code: ${response.statusCode}');
    print('Register Response Body: ${response.body}');

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      String userId = responseData['user']['id'] ?? '';
      String userEmail = responseData['user']['email'] ?? 'Unknown Email';
      String userUsername = responseData['user']['username'] ?? 'Unknown Username';
      currentUser = User(
        id: userId,
        email: userEmail,
        username: userUsername,
        password: password,
      );
      return currentUser!;
    } else {
      try {
        final responseData = jsonDecode(response.body);
        throw Exception(responseData['message']);
      } catch (e) {
        throw Exception('Failed to register');
      }
    }
  }

  Future<void> getUserData() async {
    try {
      print('User ID for getUserData: ${currentUser?.id}');
      final response = await http.get(
        Uri.parse('$baseUrl/user/${currentUser?.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('Get User Data Response Status Code: ${response.statusCode}');
      print('Get User Data Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['user'] == null) {
          throw Exception('No user data found');
        }
        currentUser = User.fromJson(responseData['user']);
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      print('Error in getUserData: $e');
      rethrow;
    }
  }
  
  Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'email': email}),
    );

    print('Forgot Password Response Status Code: ${response.statusCode}');
    print('Forgot Password Response Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to send reset email');
    }
  }

  Future<void> logout() async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'userId': currentUser?.id}),
    );

    print('Logout Response Status Code: ${response.statusCode}');
    print('Logout Response Body: ${response.body}');

    if (response.statusCode == 200) {
      currentUser = null;
    } else {
      try {
        final responseBody = response.body;
        if (responseBody.startsWith('<!DOCTYPE html>')) {
          throw Exception('Server returned an HTML response');
        }
        final responseData = jsonDecode(response.body);
        throw Exception('Failed to logout: ${responseData['message']} - Response: $responseBody');
      } catch (e) {
        throw Exception('Failed to logout: $e');
      }
    }
  }
}