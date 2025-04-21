import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';

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
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = FlutterSecureStorage();
  bool isLoading = true;
  String initialRoute = Routes.login;

  @override
  void initState() {
    super.initState();
    _checkUserAuthentication();
  }

  Future<void> _checkUserAuthentication() async {
    try {
      final token = await storage.read(key: 'userToken');
      final userType = await storage.read(key: 'userType');

      if (token != null) {
        if (userType == 'freelancer') {
          initialRoute = Routes.freelancerDashboard;
        } else if (userType == 'client') {
          initialRoute = Routes.clientDashboard;
        }
      }
    } catch (e) {
      print('Authentication check error: $e');
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
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
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
