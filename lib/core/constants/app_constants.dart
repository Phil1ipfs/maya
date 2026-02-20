/// App-wide constants
class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'Wallet';
  static const String appVersion = '1.0.0';

  // Currency
  static const String currencySymbol = '₱';
  static const String currencyCode = 'PHP';

  // Validation
  static const double minTransactionAmount = 1.0;
  static const double maxTransactionAmount = 100000.0;
  static const double initialBalance = 0.0;

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);
}
