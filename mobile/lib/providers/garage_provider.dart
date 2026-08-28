import 'package:flutter/material.dart';
import '../models/vehicle.dart';

class GarageProvider extends ChangeNotifier {
  // We start with one default vehicle so the garage isn't empty
  final List<Vehicle> _vehicles = [
    Vehicle(
      id: '1',
      type: 'Car',
      nickname: 'Daily Driver',
      plate: 'KL 36 M 3020',
      odometer: 12500,
      assetPath: 'assets/models/generic_car.glb',
      engine: '1.2 K-Series',      // ADD THIS
      transmission: 'AUTOMATIC',   // ADD THIS
    ),
  ];

  List<Vehicle> get vehicles => _vehicles;

  void addVehicle(Vehicle vehicle) {
    _vehicles.add(vehicle);
    notifyListeners(); // This instantly rebuilds the Home Screen!
  }
}