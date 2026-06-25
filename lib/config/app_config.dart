class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.ecclesiaste.app',
  );

  static const String adminEmail = String.fromEnvironment(
    'ADMIN_EMAIL',
    defaultValue: 'superadmin@ecclesiastes.rdc',
  );

  static const String adminPassword = String.fromEnvironment(
    'ADMIN_PASSWORD',
    defaultValue: 'Admin@2026!RDC',
  );

  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
}
