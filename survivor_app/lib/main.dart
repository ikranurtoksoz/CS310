import 'screens/favourites_screen.dart';
import 'screens/menus_screen.dart';
import 'screens/transport_screen.dart';

import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';

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

      // Sakura & Navy design system
      theme: AppTheme.light,

      initialRoute: '/',

      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomeScreen(),
        '/favourites': (context) => const FavouritesScreen(),
        '/menus': (context) => const MenusScreen(),
        '/transport': (context) => const TransportScreen(),
      },
    );
  }
}
