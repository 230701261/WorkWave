import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

import 'app_themes.dart';
import 'routes.dart';
import 'providers/auth_provider.dart';
import 'providers/job_provider.dart';
import 'providers/message_provider.dart';
import 'providers/proposal_provider.dart';

// For demo purposes, we're using a mock Firebase setup
// with local data to simulate the backend

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase only if it hasn't been initialized yet
  if (Firebase.apps.isEmpty) {
    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDpenY26nzCWjtc9QJoAWRGrWpumtEdwwU",
          projectId: "workwave-232323",
          storageBucket: "workwave-232323.firebasestorage.app",
          messagingSenderId: "1064692670801",
          appId: "1:1064692670801:android:e028d7cf8c00488132f370",
        ),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Firebase initialization timeout');
        },
      );
    } catch (e) {
      debugPrint('Firebase initialization error: $e');
      // Continue with the app, as we might be using emulators
    }
  }

  // Connect to Firebase emulators in debug mode
  if (kDebugMode) {
    try {
      // For web, use localhost, for Android emulator use 10.0.2.2
      final String host = kIsWeb
          ? 'localhost'
          : (Platform.isAndroid ? '10.0.2.2' : 'localhost');

      // Connect to emulators
      await firebase_auth.FirebaseAuth.instance.useAuthEmulator(host, 9099);
      FirebaseFirestore.instance.useFirestoreEmulator(host, 8089);
      FirebaseStorage.instance.useStorageEmulator(host, 9199);

      // Clear any cached Firebase Auth state
      await firebase_auth.FirebaseAuth.instance.signOut();

      debugPrint('Successfully connected to Firebase emulators at $host');
    } catch (e) {
      debugPrint('Error connecting to emulators: $e');
      Future.delayed(Duration.zero, () {
        Get.snackbar(
          'Emulator Connection Error',
          'Failed to connect to Firebase emulators. Please check if emulators are running.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      });
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  String initialRoute = Routes.login;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final authProvider = AuthProvider();
      await authProvider.checkAuthState();

      if (authProvider.isAuthenticated) {
        if (authProvider.currentUser?.userType == 'freelancer') {
          initialRoute = Routes.freelancerDashboard;
        } else if (authProvider.currentUser?.userType == 'client') {
          initialRoute = Routes.clientDashboard;
        }
      }
    } catch (e) {
      print('App initialization error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading...', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        ChangeNotifierProvider(create: (_) => ProposalProvider()),
      ],
      child: GetMaterialApp(
        title: 'WorkWave',
        theme: AppThemes.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: initialRoute,
        getPages: Routes.pages,
      ),
    );
  }
}
