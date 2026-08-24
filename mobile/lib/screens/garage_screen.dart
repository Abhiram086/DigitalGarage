import 'package:flutter/material.dart';

class GarageScreen extends StatelessWidget {
  const GarageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Garage'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Welcome to your digital garage!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}