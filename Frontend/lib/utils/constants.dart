class ApiConstants {
  // Note: For Android emulator, use 'http://10.0.2.2:4000/api'
  // For physical device, use your computer's IP address, e.g., 'http://192.168.1.100:4000/api'
  static const String baseUrl = 'http://localhost:4000/api';
  static const String authBase = '$baseUrl/auth';
  static const String sosBase = '$baseUrl/sos';
  
  // Auth endpoints
  static const String register = '$authBase/register';
  static const String login = '$authBase/login';
  static const String familyContact = '$authBase/family';
  
  // SOS endpoints
  static const String sendSOS = '$sosBase/send';
  static const String mySOS = '$sosBase/my';
  static const String pendingSOS = '$sosBase/pending';
  static const String getAddress = '$sosBase/address';
  static const String familySOS = '$sosBase/family';

  // Family endpoints
  static const String familyBase = '$baseUrl/family';
  static const String trackedMembers = '$familyBase/members';
  static const String memberLocation = '$familyBase/location';
  static const String shareLocation = '$familyBase/share-location';
}

class StorageKeys {
  static const String token = 'auth_token';
  static const String user = 'user_data';
}

