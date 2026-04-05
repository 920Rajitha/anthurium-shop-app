import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const AnthuriumApp());
}

class AnthuriumApp extends StatelessWidget {
  const AnthuriumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🔥 AUTO LOGIN CHECK
      home: const AuthCheck(),

      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => DashboardScreen(),
      },
    );
  }
}

// 🔐 AUTH CHECK SCREEN
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    // ✅ Already logged
    if (user != null) {
      return DashboardScreen();
    }

    // ❌ Not logged
    return const LoginScreen();
  }
}