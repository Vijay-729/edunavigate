import '../models/loan_model.dart';

enum LoanSortOrder {
  relevance,
  lowestInterest,
  highestLoanAmount,
  alphabetical
}

extension LoanSortOrderX on LoanSortOrder {
  String get label {
    switch (this) {
      case LoanSortOrder.relevance:
        return 'Relevance';
      case LoanSortOrder.lowestInterest:
        return 'Lowest Interest Rate';
      case LoanSortOrder.highestLoanAmount:
        return 'Highest Loan Amount';
      case LoanSortOrder.alphabetical:
        return 'A–Z';
    }
  }
}

class LoanFilter {
  final String query;
  final bool? nbfcOnly; // null = all, true = NBFC only, false = banks only
  final bool noCollateralOnly;

  const LoanFilter(
      {this.query = '', this.nbfcOnly, this.noCollateralOnly = false});

  LoanFilter copyWith(
      {String? query,
      bool? nbfcOnly,
      bool clearNbfc = false,
      bool? noCollateralOnly}) {
    return LoanFilter(
      query: query ?? this.query,
      nbfcOnly: clearNbfc ? null : (nbfcOnly ?? this.nbfcOnly),
      noCollateralOnly: noCollateralOnly ?? this.noCollateralOnly,
    );
  }
}

/// Pure search/filter/sort logic for loan products.
class LoanQueryService {
  LoanQueryService._();

  static List<LoanModel> search(List<LoanModel> items, String rawQuery) {
    final query = rawQuery.trim().toLowerCase();
    if (query.isEmpty) return items;
    return items
        .where((l) => l.lenderName.toLowerCase().contains(query))
        .toList();
  }

  static List<LoanModel> filter(List<LoanModel> items, LoanFilter filter) {
    return items.where((l) {
      if (filter.nbfcOnly != null && l.isNbfc != filter.nbfcOnly) return false;
      if (filter.noCollateralOnly &&
          !l.collateral.toLowerCase().contains('waiv') &&
          !l.collateral.toLowerCase().contains('unsecured')) {
        return false;
      }
      return true;
    }).toList();
  }

  static List<LoanModel> sort(List<LoanModel> items, LoanSortOrder order) {
    final list = List<LoanModel>.from(items);
    switch (order) {
      case LoanSortOrder.relevance:
        break;
      case LoanSortOrder.lowestInterest:
        list.sort((a, b) => a.interestRateMin.compareTo(b.interestRateMin));
        break;
      case LoanSortOrder.highestLoanAmount:
        break; // maxLoanAmount is free-text; relevance order kept
      case LoanSortOrder.alphabetical:
        list.sort((a, b) => a.lenderName.compareTo(b.lenderName));
        break;
    }
    return list;
  }
}
