import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';

import '../models/user_model.dart';

class AuthService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final _authStreamController = StreamController<String?>.broadcast();
  
  // Mock users for demo
  final List<UserModel> _mockUsers = [
    UserModel(
      id: '1',
      name: 'John Freelancer',
      email: 'freelancer@example.com',
      userType: 'freelancer',
      profileImageUrl: '',
      about: 'Experienced web developer with 5+ years of experience',
      location: 'New York, USA',
      skills: ['Flutter', 'Dart', 'Firebase', 'UI/UX Design'],
      hourlyRate: 25,
      joinDate: DateTime.now().subtract(Duration(days: 365)),
      careerGoals: 'Looking to expand my portfolio with mobile app projects',
      rating: 4.8,
    ),
    UserModel(
      id: '2',
      name: 'Jane Client',
      email: 'client@example.com',
      userType: 'client',
      profileImageUrl: '',
      about: 'Tech startup founder looking for talented developers',
      location: 'San Francisco, USA',
      joinDate: DateTime.now().subtract(Duration(days: 180)),
      rating: 4.9,
    ),
  ];

  // Get current authenticated user stream
  Stream<String?> get authStateChanges => _authStreamController.stream;

  // Register with email and password
  Future<UserModel> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required String userType,
  }) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    
    // Check if email already exists
    if (_mockUsers.any((user) => user.email == email)) {
      throw Exception('Email already in use');
    }
    
    final uuid = Uuid();
    final userId = uuid.v4();
    
    // Create new user
    UserModel newUser = UserModel(
      id: userId,
      name: name,
      email: email,
      userType: userType,
      profileImageUrl: '',
      joinDate: DateTime.now(),
    );
    
    // Add to mock users list
    _mockUsers.add(newUser);
    
    // Save user info to secure storage
    await _storage.write(key: 'userToken', value: 'mock-token-$userId');
    await _storage.write(key: 'userId', value: userId);
    await _storage.write(key: 'userType', value: userType);
    
    // Notify listeners
    _authStreamController.add(userId);
    
    return newUser;
  }

  // Login with email and password
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    
    // For demo purposes, accept any password for mock users
    final user = _mockUsers.firstWhere(
      (user) => user.email == email,
      orElse: () => throw Exception('User not found'),
    );
    
    // Save user info to secure storage
    await _storage.write(key: 'userToken', value: 'mock-token-${user.id}');
    await _storage.write(key: 'userId', value: user.id);
    await _storage.write(key: 'userType', value: user.userType);
    
    // Notify listeners
    _authStreamController.add(user.id);
    
    return user;
  }

  // Logout
  Future<void> logout() async {
    await _storage.deleteAll();
    _authStreamController.add(null);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'userToken');
    return token != null;
  }

  // Get user type
  Future<String?> getUserType() async {
    return await _storage.read(key: 'userType');
  }

  // Get user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: 'userId');
  }

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    await Future.delayed(Duration(milliseconds: 300)); // Simulate network delay
    try {
      return _mockUsers.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  // Password reset
  Future<void> resetPassword(String email) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    
    // Check if email exists
    final user = _mockUsers.firstWhere(
      (user) => user.email == email,
      orElse: () => throw Exception('Email not found'),
    );
    
    // In a real app, this would send an email
    print('Password reset email sent to ${user.email}');
  }
  
  // Dispose
  void dispose() {
    _authStreamController.close();
  }
}
