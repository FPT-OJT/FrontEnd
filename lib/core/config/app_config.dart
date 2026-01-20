class AppConfig {
  static const String env = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );
  static bool get isProduction => env == 'production';
  static String webGoogleClientId = const String.fromEnvironment(
    'WEB_GOOGLE_CLIENT_ID',
    defaultValue: 'web_client_id',
  );
  static String androidGoogleClientId = const String.fromEnvironment(
    'ANDROID_GOOGLE_CLIENT_ID',
    defaultValue: 'android_client_id',
  );
}

// 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
