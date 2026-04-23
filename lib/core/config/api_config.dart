class ApiConfig {
  // static const String baseUrl = "https://api.cuplusapptest.com";
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:4000',
  );
}