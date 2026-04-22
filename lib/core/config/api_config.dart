class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    // defaultValue: 'http://localhost:4000',
    defaultValue: 'https://api.cuplusapptest.com',
  );
}