import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _error;
  UserModel? _currentUser;
  bool _isInitialized = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isInitialized => _isInitialized;

  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Listen to auth state changes
      _authService.authStateChanges.listen((userId) async {
        if (userId != null) {
          final user = await _authService.getUserById(userId);
          _currentUser = user;
        } else {
          _currentUser = null;
        }
        notifyListeners();
      });
    } catch (e) {
      _setError('Failed to initialize auth provider: ${e.toString()}');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> checkAuthState() async {
    if (!_isInitialized) {
      await _initialize();
    }

    _setLoading(true);
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        final userId = await _authService.getUserId();
        if (userId != null) {
          _currentUser = await _authService.getUserById(userId);
          notifyListeners();
        }
      }
    } catch (e) {
      _setError('Failed to check auth state: ${e.toString()}');
    } finally {
      _setLoading(false);
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
      print('AuthProvider: Attempting registration with email: $email');
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        throw Exception('All fields are required');
      }

      _currentUser = await _authService.registerWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
        userType: userType,
      );
      print(
          'AuthProvider: Registration successful, user: ${_currentUser?.email}');
      notifyListeners();
      return true;
    } catch (e) {
      print('AuthProvider: Registration error: $e');
      _setError('Registration failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _clearError();
    try {
      print('AuthProvider: Attempting login with email: $email');
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password are required');
      }

      _currentUser = await _authService.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('AuthProvider: Login successful, user: ${_currentUser?.email}');
      notifyListeners();
      return true;
    } catch (e) {
      print('AuthProvider: Login error: $e');
      _setError('Login failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _setError('Logout failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();
    try {
      if (email.isEmpty) {
        throw Exception('Email is required');
      }

      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _setError('Password reset failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
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
