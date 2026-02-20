import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

/// Utility class for formatting currency values
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_PH',
    symbol: AppConstants.currencySymbol,
    decimalDigits: 2,
  );

  static final NumberFormat _compactFormat = NumberFormat.compactCurrency(
    locale: 'en_PH',
    symbol: AppConstants.currencySymbol,
    decimalDigits: 2,
  );

  /// Format amount with currency symbol (e.g., ₱1,234.56)
  static String format(double amount) {
    return _currencyFormat.format(amount);
  }

  /// Format amount in compact form (e.g., ₱1.2K)
  static String formatCompact(double amount) {
    return _compactFormat.format(amount);
  }

  /// Format amount without currency symbol (e.g., 1,234.56)
  static String formatWithoutSymbol(double amount) {
    final format = NumberFormat('#,##0.00', 'en_PH');
    return format.format(amount);
  }

  /// Parse string to double
  static double? parse(String value) {
    try {
      // Remove currency symbol and commas
      final cleanValue = value
          .replaceAll(AppConstants.currencySymbol, '')
          .replaceAll(',', '')
          .trim();
      return double.tryParse(cleanValue);
    } catch (e) {
      return null;
    }
  }
}
