class ApiConstants {
  // For Android emulator use 10.0.2.2, for iOS simulator use localhost.
  // For a real device replace with your machine LAN IP: e.g. 'http://192.168.1.100:8000'
  static const String baseUrl = 'https://3f43203f1c55.ngrok-free.app';

  static const String registerEndpoint = '$baseUrl/register';
  static const String verifyEndpoint = '$baseUrl/verify';

  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
