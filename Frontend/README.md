# Arti SOS Flutter App

A Flutter application for emergency SOS with location tracking.

## Features

- User Authentication (Login/Register)
- Send SOS with automatic location capture
- View SOS history
- Family contact management
- Pending SOS view for receivers

## Setup

1. Install Flutter dependencies:
```bash
flutter pub get
```

2. **Configure API Base URL** in `lib/utils/constants.dart`:
   - For iOS Simulator/Web: `http://localhost:4000/api` (default)
   - For Android Emulator: `http://10.0.2.2:4000/api`
   - For Physical Device: Use your computer's IP address, e.g., `http://192.168.1.100:4000/api`

3. For Android, add location permissions in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

4. For iOS, add location permissions in `ios/Runner/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to send emergency SOS</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location to send emergency SOS</string>
```

## Running the App

```bash
flutter run
```

## API Endpoints Used

- **POST** `/api/auth/register` - User registration
- **POST** `/api/auth/login` - User login
- **POST** `/api/auth/family` - Save family contact (requires authentication, user role)
- **POST** `/api/sos/send` - Send SOS with location (requires authentication, user role)
- **GET** `/api/sos/my` - Get user's SOS history (requires authentication)
- **GET** `/api/sos/pending` - Get pending SOS (requires authentication, receiver role)

## Important Notes

- **Location Permissions**: The app requires location permissions to send SOS. Make sure to grant permissions when prompted.
- **Backend Connection**: Ensure your backend server is running on port 4000 (or update the URL accordingly).
- **Authentication**: All API calls except register/login require a valid JWT token stored after login.
- **SOS Location**: When sending SOS, the app automatically captures the current GPS location and sends it to the backend, which stores it in the database along with the reverse-geocoded address.

