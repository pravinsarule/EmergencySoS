import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../utils/constants.dart';
import '../utils/storage.dart';
import 'api_service.dart';

class AuthService extends ChangeNotifier {
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _token != null && _user != null;

  AuthService() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _token = await Storage.getString(StorageKeys.token);
    final userJson = await Storage.getString(StorageKeys.user);
    if (userJson != null) {
      _user = User.fromJson(jsonDecode(userJson));
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? role,
    String? phone,
  }) async {
    try {
      final response = await ApiService.post(
        ApiConstants.register,
        {
          'name': name,
          'email': email,
          'password': password,
          if (role != null) 'role': role,
          if (phone != null) 'phone': phone,
        },
      );

      if (response.statusCode == 201) {
        try {
          final data = jsonDecode(response.body);
          
          if (data['user'] != null && data['token'] != null) {
            _user = User.fromJson(data['user']);
            _token = data['token'] as String;
            
            // Store token and user
            await Storage.saveString(StorageKeys.token, _token!);
            await Storage.saveString(StorageKeys.user, jsonEncode(_user!.toJson()));
            
            notifyListeners();
            return {'success': true, 'message': 'Registration successful'};
          } else {
            return {'success': false, 'message': 'Invalid response format'};
          }
        } catch (e) {
          return {'success': false, 'message': 'Error parsing response: ${e.toString()}'};
        }
      } else {
        try {
          final data = jsonDecode(response.body);
          return {'success': false, 'message': data['message'] ?? 'Registration failed'};
        } catch (e) {
          return {'success': false, 'message': 'Registration failed with status ${response.statusCode}'};
        }
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        ApiConstants.login,
        {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          
          if (data['user'] != null && data['token'] != null) {
            _user = User.fromJson(data['user']);
            _token = data['token'] as String;
            
            // Store token and user
            await Storage.saveString(StorageKeys.token, _token!);
            await Storage.saveString(StorageKeys.user, jsonEncode(_user!.toJson()));
            
            notifyListeners();
            return {'success': true, 'message': 'Login successful'};
          } else {
            return {'success': false, 'message': 'Invalid response format'};
          }
        } catch (e) {
          return {'success': false, 'message': 'Error parsing response: ${e.toString()}'};
        }
      } else {
        try {
          final data = jsonDecode(response.body);
          return {'success': false, 'message': data['message'] ?? 'Login failed'};
        } catch (e) {
          return {'success': false, 'message': 'Login failed with status ${response.statusCode}'};
        }
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> saveFamilyContact({
    String? familyEmail,
    String? familyPhone,
    String? familyName,
  }) async {
    try {
      final response = await ApiService.post(
        ApiConstants.familyContact,
        {
          if (familyEmail != null) 'family_email': familyEmail,
          if (familyPhone != null) 'family_phone': familyPhone,
          if (familyName != null) 'family_name': familyName,
        },
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          return {'success': true, 'message': data['message'] ?? 'Family contact saved'};
        } catch (e) {
          return {'success': false, 'message': 'Error parsing response: ${e.toString()}'};
        }
      } else {
        try {
          final data = jsonDecode(response.body);
          return {'success': false, 'message': data['message'] ?? 'Failed to save contact'};
        } catch (e) {
          return {'success': false, 'message': 'Failed to save contact with status ${response.statusCode}'};
        }
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    await Storage.clear();
    notifyListeners();
  }
}

