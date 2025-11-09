import 'dart:convert';
import '../utils/constants.dart';
import 'api_service.dart';

class FamilyService {
  static Future<Map<String, dynamic>> getTrackedMembers() async {
    try {
      final response = await ApiService.get(
        ApiConstants.trackedMembers,
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          return {
            'success': true,
            'members': data['members'] ?? [],
          };
        } catch (e) {
          return {'success': false, 'message': 'Error parsing response: ${e.toString()}'};
        }
      } else {
        try {
          final data = jsonDecode(response.body);
          return {
            'success': false,
            'message': data['message'] ?? 'Failed to fetch members',
          };
        } catch (e) {
          return {
            'success': false,
            'message': 'Failed to fetch members with status ${response.statusCode}',
          };
        }
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> getMemberLocation(int userId) async {
    try {
      final response = await ApiService.get(
        '${ApiConstants.memberLocation}/$userId',
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          return {
            'success': true,
            'location': data['location'],
          };
        } catch (e) {
          return {'success': false, 'message': 'Error parsing response: ${e.toString()}'};
        }
      } else {
        try {
          final data = jsonDecode(response.body);
          return {
            'success': false,
            'message': data['message'] ?? 'Failed to fetch location',
          };
        } catch (e) {
          return {
            'success': false,
            'message': 'Failed to fetch location with status ${response.statusCode}',
          };
        }
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> shareLocation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await ApiService.post(
        ApiConstants.shareLocation,
        {
          'latitude': latitude,
          'longitude': longitude,
        },
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          return {
            'success': true,
            'message': data['message'] ?? 'Location shared successfully',
          };
        } catch (e) {
          return {'success': false, 'message': 'Error parsing response: ${e.toString()}'};
        }
      } else {
        try {
          final data = jsonDecode(response.body);
          return {
            'success': false,
            'message': data['message'] ?? 'Failed to share location',
          };
        } catch (e) {
          return {
            'success': false,
            'message': 'Failed to share location with status ${response.statusCode}',
          };
        }
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }
}

