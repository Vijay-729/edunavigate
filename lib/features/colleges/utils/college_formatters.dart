/// Shared number/currency formatting helpers for the College Explorer and
/// Predictor UI — kept free of widget/Riverpod imports so they're trivially
/// unit-testable.
class CollegeFormatters {
  CollegeFormatters._();

  /// Formats a rupee amount as e.g. "₹2.3L" or "₹85K".
  static String rupeesShort(num amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(amount % 10000000 == 0 ? 0 : 1)}Cr';
    }
    if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(amount % 100000 == 0 ? 0 : 1)}L';
    }
    if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(amount % 1000 == 0 ? 0 : 1)}K';
    }
    return '₹$amount';
  }

  static String lpa(num value) {
    if (value == value.roundToDouble()) {
      return '₹${value.round()} LPA';
    }
    return '₹${value.toStringAsFixed(1)} LPA';
  }

  static String rank(int? rank) {
    if (rank == null) return '—';
    final s = rank.toString();
    final chars = s.split('');
    final result = StringBuffer();
    for (int i = 0; i < chars.length; i++) {
      if (i != 0 && (chars.length - i) % 3 == 0) result.write(',');
      result.write(chars[i]);
    }
    return result.toString();
  }
}
