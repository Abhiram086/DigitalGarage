import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  // 1. Checks device storage for a token when the app boots
  Future<void> checkAuthStatus() async {
    final token = await ApiService.getToken();
    if (token != null && token.isNotEmpty) {
      _isAuthenticated = true;
    } else {
      _isAuthenticated = false;
    }
    notifyListeners();
  }

  // 2. Registration passes directly to API
  Future<bool> register(String username, String email, String password) async {
    return await ApiService.register(username, email, password);
  }

  // 3. Login sets the authenticated state to true if successful
  Future<bool> login(String username, String password) async {
    final success = await ApiService.login(username, password);
    if (success) {
      _isAuthenticated = true;
      notifyListeners();
    }
    return success;
  }

  // 4. Logout clears tokens and resets state
  Future<void> logout() async {
    await ApiService.clearTokens();
    _isAuthenticated = false;
    notifyListeners();
  }
}