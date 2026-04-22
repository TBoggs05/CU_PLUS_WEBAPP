class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:4000',
    // defaultValue: 'http://cuplus-backend-env.eba-sufmkysk.us-east-2.elasticbeanstalk.com',
  );
}