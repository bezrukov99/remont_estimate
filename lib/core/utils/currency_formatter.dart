import 'package:remont_estimate/core/constants/app_currencies.dart';

/// Lightweight money formatting without extra dependencies.
abstract final class CurrencyFormatter {
  static String format(double amount, String currencyCode) {
    final symbol = AppCurrencies.symbolFor(currencyCode);
    final formatted = amount.toStringAsFixed(2);
    return '$formatted $symbol';
  }

  static String compact(double amount, String currencyCode) {
    final symbol = AppCurrencies.symbolFor(currencyCode);
    final value = amount.abs();
    if (value >= 1_000_000) {
      return '${(amount / 1_000_000).toStringAsFixed(1)}M $symbol';
    }
    if (value >= 10_000) {
      return '${(amount / 1_000).toStringAsFixed(1)}K $symbol';
    }
    return format(amount, currencyCode);
  }
}
