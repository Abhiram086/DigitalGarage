import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const CarDashboardApp());
}

class CarDashboardApp extends StatelessWidget {
  const CarDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Health & Maintenance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const SplashScreen(), // Starts the app here!
    );
  }
}