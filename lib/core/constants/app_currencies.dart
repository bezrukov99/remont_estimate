/// Supported currencies with display symbols.
class AppCurrency {
  const AppCurrency({
    required this.code,
    required this.symbol,
  });

  final String code;
  final String symbol;

  String get displayLabel => '$symbol · $code';
}

abstract final class AppCurrencies {
  static const List<AppCurrency> all = [
    AppCurrency(code: 'USD', symbol: r'$'),
    AppCurrency(code: 'EUR', symbol: '€'),
    AppCurrency(code: 'GBP', symbol: '£'),
    AppCurrency(code: 'RUB', symbol: '₽'),
    AppCurrency(code: 'KZT', symbol: '₸'),
    AppCurrency(code: 'UAH', symbol: '₴'),
    AppCurrency(code: 'BYN', symbol: 'Br'),
    AppCurrency(code: 'CHF', symbol: 'CHF'),
    AppCurrency(code: 'CNY', symbol: '¥'),
    AppCurrency(code: 'JPY', symbol: '¥'),
    AppCurrency(code: 'TRY', symbol: '₺'),
    AppCurrency(code: 'PLN', symbol: 'zł'),
    AppCurrency(code: 'CZK', symbol: 'Kč'),
    AppCurrency(code: 'GEL', symbol: '₾'),
    AppCurrency(code: 'AMD', symbol: '֏'),
    AppCurrency(code: 'AED', symbol: 'د.إ'),
  ];

  static AppCurrency? findByCode(String code) {
    final normalized = code.trim().toUpperCase();
    for (final currency in all) {
      if (currency.code == normalized) {
        return currency;
      }
    }
    return null;
  }

  static String symbolFor(String code) {
    return findByCode(code)?.symbol ?? code.trim().toUpperCase();
  }
}
