import 'dart:convert';
import '../models/sos_model.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class SOSService {
  static Future<Map<String, dynamic>> sendSOS({
    required String serviceType,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await ApiService.post(
        ApiConstants.sendSOS,
        {
          'serviceType': serviceType,
          'latitude': latitude,
          'longitude': longitude,
        },
        requireAuth: true,
      );

      if (response.statusCode == 201) {
        try {
          final data = jsonDecode(response.body);
          if (data['sos'] != null) {
            return {
              'success': true,
              'sos': SOS.fromJson(data['sos']),
              'message': 'SOS sent successfully',
            };
          } else {
            return {'success': false, 'message': 'Invalid response format'};
          }
        } catch (e) {
          return {'success': false, 'message': 'Error parsing response: ${e.toString()}'};
        }
      } else {
        try {
          final data = jsonDecode(response.body);
          return {
            'success': false,
            'message': data['message'] ?? 'Failed to send SOS',
          };
        } catch (e) {
          return {
            'success': false,
            'message': 'Failed to send SOS with status ${response.statusCode}',
          };
        }
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> getMySOS() async {
    try {
      final response = await ApiService.get(
        ApiConstants.mySOS,
        requireAuth: true,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final list = (data['list'] as List)
            .map((item) => SOS.fromJson(item))
            .toList();
        return {'success': true, 'list': list};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to fetch SOS',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> getPendingSOS() async {
    try {
      final response = await ApiService.get(
        ApiConstants.pendingSOS,
        requireAuth: true,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final list = (data['list'] as List)
            .map((item) => SOS.fromJson(item))
            .toList();
        return {'success': true, 'list': list};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to fetch pending SOS',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Format coordinates to avoid precision issues
      final latStr = latitude.toStringAsFixed(6);
      final lonStr = longitude.toStringAsFixed(6);
      final url = '${ApiConstants.getAddress}?latitude=$latStr&longitude=$lonStr';
      final response = await ApiService.get(url, requireAuth: false);

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          if (data['address'] != null && data['address'].toString().isNotEmpty) {
            return {
              'success': true,
              'address': data['address'] as String,
            };
          } else {
            return {
              'success': false,
              'message': 'Address not found for this location',
            };
          }
        } catch (e) {
          return {'success': false, 'message': 'Error parsing address response: ${e.toString()}'};
        }
      } else {
        try {
          final data = jsonDecode(response.body);
          return {
            'success': false,
            'message': data['message'] ?? 'Failed to get address',
          };
        } catch (e) {
          return {
            'success': false,
            'message': 'Failed to get address with status ${response.statusCode}',
          };
        }
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<List<SOS>> getFamilySOS() async {
    try {
      final response = await ApiService.get(
        ApiConstants.familySOS, // Assuming this endpoint exists
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = (data['list'] as List)
            .map((item) => SOS.fromJson(item))
            .toList();
        return list;
      } else {
        throw Exception('Failed to fetch family SOS: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
}

