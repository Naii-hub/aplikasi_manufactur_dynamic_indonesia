import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/welcome_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Machine Store',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(), // Mulai dari Welcome Screen
    );
  }
}