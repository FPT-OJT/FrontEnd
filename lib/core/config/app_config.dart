class AppConfig {
  static const String env = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );
  static bool get isProduction => env == 'production';
  static String webGoogleClientId = const String.fromEnvironment(
    'WEB_GOOGLE_CLIENT_ID',
  );
  static String androidGoogleClientId = const String.fromEnvironment(
    'ANDROID_GOOGLE_CLIENT_ID',
  );
  static String apiUrl = const String.fromEnvironment('API_URL');
  static void validate() {
    if (webGoogleClientId.isEmpty) {
      throw Exception('WEB_GOOGLE_CLIENT_ID is not set');
    }
    if (androidGoogleClientId.isEmpty) {
      throw Exception('ANDROID_GOOGLE_CLIENT_ID is not set');
    }
    if (apiUrl.isEmpty) {
      throw Exception('API_URL is not set');
    }
  }
}
