import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart'; // Updated import to UserModel

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  String? _error;
  UserModel? _currentUser; // Changed to UserModel
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  UserModel? get currentUser => _currentUser; // Changed to UserModel
  bool get isAuthenticated => _currentUser != null;
  
  AuthProvider() {
    _authService.authStateChanges.listen((userId) async {
      if (userId != null) {
        final user = await _authService.getUserById(userId);
        if (user != null) {
          _currentUser = user; // No cast needed
          notifyListeners();
        }
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<void> checkAuthState() async {
    _setLoading(true);
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        final userId = await _authService.getUserId();
        if (userId != null) {
          final user = await _authService.getUserById(userId);
          if (user != null) {
            _currentUser = user; // No cast needed
          }
        }
      }
      _setLoading(false);
    } catch (e) {
      _setError('Failed to check auth state: ${e.toString()}');
    }
  }
  
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String userType,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      _currentUser = await _authService.registerWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
        userType: userType,
      ); // No cast needed
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Registration failed: ${e.toString()}');
      return false;
    }
  }
  
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      _currentUser = await _authService.loginWithEmailAndPassword(
        email: email,
        password: password,
      ); // No cast needed
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Login failed: ${e.toString()}');
      return false;
    }
  }
  
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _currentUser = null;
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Logout failed: ${e.toString()}');
    }
  }
  
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();
    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Password reset failed: ${e.toString()}');
      return false;
    }
  }
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
    notifyListeners();
  }
}