class ApiConstants {
  // Use 10.0.2.2 for Android emulator, localhost for iOS simulator, or your local IP (e.g. 192.168.1.X)
  static const String baseUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:3000/api');
}