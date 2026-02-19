class RouteNames {
  RouteNames._();

  static const String splash = '/splash';
  static const String home = '/';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  static const String loginOptions = '/login-options';
  static const String loginDetails = '/login-details';
  static const String registerDetails = '/register-details';
  static const String search = '/search';
  static const String cardSearch = '/card-search';
  static const String profile = '/profile';
  static const String wallet = '/wallet';
  static const String cardDetails = '/card-details';
  static const String cardSettings = '/card-settings';
  static const String editAccount = '/edit-account';
  static const String notificationSettings = '/notification-settings';
  static const String termsConditions = '/terms-conditions';
  static const String liveMap = '/live-map';

  static const String merchantDetail = '/merchants/:merchantId';
  static String generateMerchantDetailRoute(String merchantId) =>
      '/merchants/$merchantId';

  static const String merchantDealCalculator =
      '/merchant/:merchantId/deal-calculator';
  static String generateMerchantDealCalculatorRoute(String merchantId) =>
      '/merchant/$merchantId/deal-calculator';
}
