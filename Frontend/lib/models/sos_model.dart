class SOS {
  final int id;
  final int userId;
  final String serviceType;
  final double latitude;
  final double longitude;
  final String? address;
  final String status;
  final DateTime createdAt;
  final String? userName;
  final String? userPhone;

  SOS({
    required this.id,
    required this.userId,
    required this.serviceType,
    required this.latitude,
    required this.longitude,
    this.address,
    required this.status,
    required this.createdAt,
    this.userName,
    this.userPhone,
  });

  factory SOS.fromJson(Map<String, dynamic> json) {
    // Handle PostgreSQL numeric types which come as strings
    double parseDouble(dynamic value) {
      if (value is num) {
        return value.toDouble();
      } else if (value is String) {
        return double.parse(value);
      } else {
        throw FormatException('Cannot parse $value to double');
      }
    }

    int parseInt(dynamic value) {
      if (value is int) {
        return value;
      } else if (value is num) {
        return value.toInt();
      } else if (value is String) {
        return int.parse(value);
      } else {
        throw FormatException('Cannot parse $value to int');
      }
    }

    return SOS(
      id: parseInt(json['id']),
      userId: parseInt(json['user_id']),
      serviceType: json['service_type'] as String,
      latitude: parseDouble(json['latitude']),
      longitude: parseDouble(json['longitude']),
      address: json['address'] as String?,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] as String),
      userName: json['user_name'] as String?,
      userPhone: json['user_phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_type': serviceType,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'user_name': userName,
      'user_phone': userPhone,
    };
  }
}

