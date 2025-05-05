import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final _authStreamController = StreamController<String?>.broadcast();
  final _uuid = Uuid();

  AuthService() {
    // Listen to Firebase Auth state changes
    _auth.authStateChanges().listen((user) {
      _authStreamController.add(user?.uid);
    });
  }

  // Get current authenticated user stream
  Stream<String?> get authStateChanges => _authStreamController.stream;

  // Register with email and password
  Future<UserModel> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required String userType,
  }) async {
    try {
      print('Attempting to register user with email: $email');
      // Create user in Firebase Auth
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () =>
                throw Exception('Registration timeout. Please try again.'),
          );

      print('User created in Firebase Auth, ID: ${userCredential.user?.uid}');

      if (userCredential.user == null) {
        print('User credential is null after registration');
        throw Exception('Failed to create user account');
      }

      // Update the user's display name
      print('Updating user display name');
      await userCredential.user!.updateDisplayName(name).timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception(
                'Failed to update user profile. Please try again.'),
          );

      // Create user document in Firestore
      final user = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        userType: userType,
        profileImageUrl: '',
        about: '',
        location: '',
        skills: [],
        workExperience: [],
        education: [],
        certificates: [],
        projects: [],
        achievements: [],
        socialLinks: [],
        careerGoals: '',
        rating: 0.0,
        activityStreak: null,
        joinDate: DateTime.now(),
        hourlyRate: 0.0,
      );

      // Save user data to Firestore
      await _firestore
          .collection('users')
          .doc(user.id)
          .set(user.toJson())
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception(
                'Failed to create user profile. Please try again.'),
          );

      return user;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth error: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('Email is already registered');
        case 'invalid-email':
          throw Exception('Invalid email address');
        case 'operation-not-allowed':
          throw Exception('Email/password accounts are not enabled');
        case 'weak-password':
          throw Exception('Password is too weak');
        case 'network-request-failed':
          throw Exception('Network error. Please check your connection.');
        default:
          throw Exception('Registration failed: ${e.message}');
      }
    } catch (e) {
      print('Registration error: $e');
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  // Login with email and password
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print('Attempting to sign in with email: $email');
      // Sign in with Firebase Auth
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () =>
                throw Exception('Login timeout. Please try again.'),
          );

      print('Sign in successful, user ID: ${userCredential.user?.uid}');

      if (userCredential.user == null) {
        print('User credential is null after sign in');
        throw Exception('Failed to sign in');
      }

      // Get user data from Firestore
      print('Fetching user data from Firestore');
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get()
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () =>
                throw Exception('Failed to fetch user data. Please try again.'),
          );

      print('Firestore document exists: ${userDoc.exists}');

      if (!userDoc.exists) {
        // If user doesn't exist in Firestore, create a new user document
        final newUser = UserModel(
          id: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? '',
          email: email,
          userType: 'freelancer',
          joinDate: DateTime.now(),
          skills: [],
          workExperience: [],
          education: [],
          certificates: [],
          projects: [],
          achievements: [],
          socialLinks: [],
        );

        // Save the new user to Firestore
        final userData = newUser.toJson();
        await _firestore
            .collection('users')
            .doc(newUser.id)
            .set(userData)
            .timeout(
              const Duration(seconds: 30),
              onTimeout: () => throw Exception(
                  'Failed to create user profile. Please try again.'),
            );
        return newUser;
      }

      // Ensure we're working with a Map<String, dynamic>
      final data = Map<String, dynamic>.from(userDoc.data() ?? {});
      data['id'] = userCredential.user!.uid;

      // Handle potential type mismatches
      if (data['skills'] != null && data['skills'] is List) {
        data['skills'] =
            (data['skills'] as List).map((e) => e?.toString() ?? '').toList();
      }

      return UserModel.fromJson(data);
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth error: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found with this email');
        case 'wrong-password':
          throw Exception('Wrong password');
        case 'user-disabled':
          throw Exception('User account has been disabled');
        case 'invalid-email':
          throw Exception('Invalid email address');
        case 'network-request-failed':
          throw Exception('Network error. Please check your connection.');
        default:
          throw Exception('Login failed: ${e.message}');
      }
    } catch (e) {
      print('Login error: $e');
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists || userDoc.data() == null) return null;
      return UserModel.fromJson(userDoc.data()!);
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    return _auth.currentUser != null;
  }

  // Get current user ID
  Future<String?> getUserId() async {
    return _auth.currentUser?.uid;
  }

  // Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Logout error: $e');
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Password reset error: $e');
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }
}
