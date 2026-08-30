import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {

  static String get baseUrl => 'https://lenovoideapad.tail62369a.ts.net/api';
  // Dynamically select the correct localhost IP based on the device running the app


  // --- 1. TOKEN MANAGEMENT ---
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<void> setTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', access);
    await prefs.setString('refresh_token', refresh);
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    if (token != null) {
      return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
    }
    return {'Content-Type': 'application/json'};
  }

  // --- 2. AUTHENTICATION ---
  static Future<bool> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'email': email, 'password': password}),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Register Error: $e');
      return false;
    }
  }

  static Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await setTokens(data['access'], data['refresh']);
        return true;
      }
      return false;
    } catch (e) {
      print('Login Error: $e');
      return false;
    }
  }

  // --- 3. VEHICLE SELECTION (GET) ---
  static Future<List<dynamic>> getMakes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/vehicles/makes/'));
      if (response.statusCode == 200) return json.decode(response.body);
      throw Exception('Failed to load makes');
    } catch (e) {
      print('Error fetching makes: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getModels(int makeId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/vehicles/models/?make=$makeId'));
      if (response.statusCode == 200) return json.decode(response.body);
      throw Exception('Failed to load models');
    } catch (e) {
      print('Error fetching models: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getGenerations(int modelId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/vehicles/generations/?model=$modelId'));
      if (response.statusCode == 200) return json.decode(response.body);
      throw Exception('Failed to load generations');
    } catch (e) {
      print('Error fetching generations: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getEngines(int generationId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/vehicles/engines/?generation=$generationId'));
      if (response.statusCode == 200) return json.decode(response.body);
      throw Exception('Failed to load engines');
    } catch (e) {
      print('Error fetching engines: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getSpecifications(int generationId, int engineId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/vehicles/specifications/?generation=$generationId&engine=$engineId'),
      );
      if (response.statusCode == 200) return json.decode(response.body);
      throw Exception('Failed to load specifications');
    } catch (e) {
      print('Error fetching specs: $e');
      return [];
    }
  }

  // --- 4. USER GARAGE (POST) ---
  static Future<bool> addMyVehicle(int specId, String nickname, int odometer) async {
    try {
      // Now this will work because getAuthHeaders() exists!
      final headers = await getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/vehicles/my-cars/'),
        headers: headers,
        body: json.encode({
          'vehicle_specification': specId,
          'nickname': nickname,
          'odometer': odometer,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Error adding vehicle: $e');
      return false;
    }
  }

  // --- 5. FETCH USER GARAGE (GET) ---
  static Future<List<dynamic>> getMyVehicles() async {
    try {
      final headers = await getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/vehicles/my-cars/'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      print('Error fetching my vehicles: $e');
      return [];
    }
  }
}