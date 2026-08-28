import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 10.0.2.2 is required for Android Emulators to access your computer's localhost.
  // If you are testing on Chrome/Web, change this to 'http://127.0.0.1:8000/api'
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Step 1: Get all Makes
  static Future<List<dynamic>> getMakes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/vehicles/makes/'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to load makes');
    } catch (e) {
      print('Error fetching makes: $e');
      return [];
    }
  }

  // Step 2: Get Models for a specific Make ID
  static Future<List<dynamic>> getModels(int makeId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/vehicles/models/?make=$makeId'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to load models');
    } catch (e) {
      print('Error fetching models: $e');
      return [];
    }
  }

  // Step 3: Get Generations for a specific Model ID
  static Future<List<dynamic>> getGenerations(int modelId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/vehicles/generations/?model=$modelId'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to load generations');
    } catch (e) {
      print('Error fetching generations: $e');
      return [];
    }
  }

  // Step 4: Get Engines for a specific Generation ID
  static Future<List<dynamic>> getEngines(int generationId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/vehicles/engines/?generation=$generationId'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to load engines');
    } catch (e) {
      print('Error fetching engines: $e');
      return [];
    }
  }

  // Step 5: Get Final Specifications
  static Future<List<dynamic>> getSpecifications(int generationId, int engineId) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/vehicles/specifications/?generation=$generationId&engine=$engineId')
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to load specifications');
    } catch (e) {
      print('Error fetching specs: $e');
      return [];
    }
  }
}