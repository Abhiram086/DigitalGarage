import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/garage_provider.dart';
import 'providers/auth_provider.dart'; // <-- 1. ADD THIS IMPORT
import 'screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GarageProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()), // <-- 2. ADD THIS PROVIDER
      ],
      child: const CarDashboardApp(),
    ),
  );
}

class CarDashboardApp extends StatelessWidget {
  const CarDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Health & Maintenance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}