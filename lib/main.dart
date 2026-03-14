import 'package:flutter/material.dart';
import 'package:ruh_care/screens/login_screen.dart';
import 'package:ruh_care/screens/main_navigation.dart';
import 'package:ruh_care/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ruh-Care',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B7B3A)),
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainNavigation(),
      },
    );
  }
}

