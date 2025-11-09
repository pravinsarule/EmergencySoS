class FamilyContact {
  final int? id;
  final int userId;
  final String serviceType;
  final String contactName;
  final String contactNumber;
  final String address;

  FamilyContact({
    this.id,
    required this.userId,
    required this.serviceType,
    required this.contactName,
    required this.contactNumber,
    required this.address,
  });

  factory FamilyContact.fromJson(Map<String, dynamic> json) {
    return FamilyContact(
      id: json['id'] as int?,
      userId: json['user_id'] as int,
      serviceType: json['service_type'] as String,
      contactName: json['contact_name'] as String,
      contactNumber: json['contact_number'] as String,
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_type': serviceType,
      'contact_name': contactName,
      'contact_number': contactNumber,
      'address': address,
    };
  }
}

