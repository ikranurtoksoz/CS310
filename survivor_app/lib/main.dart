
import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(const SurvivorApp());
}

class SurvivorApp extends StatelessWidget {
  const SurvivorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUrvivor',
      debugShowCheckedModeBanner: false,

      // Common application theme
      theme: AppTheme.lightTheme,

      // First screen
      initialRoute: '/',

      // Application navigation routes
      routes: {
        '/': (context) => const SplashScreen(),

        '/welcome': (context) =>
            const WelcomeScreen(),

        '/login': (context) =>
            const LoginScreen(),

        '/signup': (context) =>
            const SignUpScreen(),

        '/forgot-password': (context) =>
            const ForgotPasswordScreen(),

        '/home': (context) =>
            const MainShell(),
      },
    );
  }
}
