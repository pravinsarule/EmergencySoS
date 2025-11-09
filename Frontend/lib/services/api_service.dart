import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/storage.dart';

class ApiService {
  static Future<String?> getToken() async {
    return await Storage.getString(StorageKeys.token);
  }

  static Map<String, String> getHeaders({bool includeAuth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    return headers;
  }

  static Future<Map<String, String>> getAuthHeaders() async {
    final headers = getHeaders();
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    } else {
      print('Warning: No token found for authenticated request');
    }
    return headers;
  }

  static Future<http.Response> post(
    String url,
    Map<String, dynamic> body, {
    bool requireAuth = false,
  }) async {
    try {
      final headers = requireAuth
          ? await getAuthHeaders()
          : getHeaders();

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      
      return response;
    } catch (e) {
      // Return a response with error status if network fails
      return http.Response('{"message": "Network error: ${e.toString()}"}', 500);
    }
  }

  static Future<http.Response> get(
    String url, {
    bool requireAuth = false,
  }) async {
    try {
      final headers = requireAuth
          ? await getAuthHeaders()
          : getHeaders();

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      
      return response;
    } catch (e) {
      // Return a response with error status if network fails
      return http.Response('{"message": "Network error: ${e.toString()}"}', 500);
    }
  }
}

