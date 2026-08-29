import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/api_service.dart';

class GarageProvider extends ChangeNotifier {
  List<Vehicle> _vehicles = [];
  bool isLoading = false;

  List<Vehicle> get vehicles => _vehicles;

  Future<void> fetchVehicles() async {
    isLoading = true;
    notifyListeners();

    final data = await ApiService.getMyVehicles();
    _vehicles = data.map((v) => Vehicle.fromJson(v)).toList();

    isLoading = false;
    notifyListeners();
  }

  void addVehicle(Vehicle vehicle) {
    _vehicles.add(vehicle);
    notifyListeners();
  }

  void clearVehicles() {
    _vehicles.clear();
    notifyListeners();
  }
}