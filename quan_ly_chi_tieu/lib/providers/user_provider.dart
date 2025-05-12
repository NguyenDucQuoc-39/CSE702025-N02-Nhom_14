import 'package:flutter/foundation.dart';
import 'package:quan_ly_chi_tieu/services/auth_service.dart';
import 'package:quan_ly_chi_tieu/models/user.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<void> login(String email, String password) async {
    _currentUser = await _authService.login(email, password);
    notifyListeners();
  }

  Future<void> register(String email, String password, String username) async {
    _currentUser = await _authService.register(email, password, username);
    notifyListeners();
  }

  Future<void> getUserData() async {
    try {
      await _authService.getUserData();
      _currentUser = AuthService.currentUser;
      notifyListeners();
    } catch (e) {
      print('Lỗi getUserData: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    notifyListeners();
  }
}