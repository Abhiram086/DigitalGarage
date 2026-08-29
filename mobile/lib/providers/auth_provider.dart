import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  // Runs when the splash screen loads to check if a token exists in memory
  Future<void> checkAuthStatus() async {
    final token = await ApiService.getToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    final success = await ApiService.login(username, password);
    if (success) {
      _isAuthenticated = true;
      notifyListeners();
    }
    return success;
  }

  Future<bool> register(String username, String email, String password) async {
    // We don't log them in automatically after registration per your current flow,
    // we just return whether the registration was successful.
    return await ApiService.register(username, email, password);
  }

  Future<void> logout() async {
    await ApiService.clearTokens();
    _isAuthenticated = false;
    notifyListeners();
  }
}