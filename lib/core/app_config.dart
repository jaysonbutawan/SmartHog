
class AppConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://smarthogapiv2-lq3o.onrender.com', 
  );
}