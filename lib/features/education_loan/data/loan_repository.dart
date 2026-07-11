import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/government_scheme_model.dart';
import '../models/loan_model.dart';
import 'government_scheme_seed_data.dart';
import 'loan_seed_data.dart';

/// Abstraction over "where loan/scheme data comes from". Swapping in a
/// Firestore-backed implementation later (`loanProducts` /
/// `governmentSchemes` collections) requires no changes to services,
/// providers, or UI.
abstract class LoanRepository {
  List<LoanModel> getAllLoans();
  LoanModel? getLoanById(String id);
  List<GovtSchemeModel> getAllSchemes();
}

class LocalLoanRepository implements LoanRepository {
  static final List<LoanModel> _loans = List.unmodifiable(LoanSeedData.all);
  static final List<GovtSchemeModel> _schemes =
      List.unmodifiable(GovernmentSchemeSeedData.all);

  @override
  List<LoanModel> getAllLoans() => _loans;

  @override
  LoanModel? getLoanById(String id) {
    for (final l in _loans) {
      if (l.id == id) return l;
    }
    return null;
  }

  @override
  List<GovtSchemeModel> getAllSchemes() => _schemes;
}

final loanRepositoryProvider =
    Provider<LoanRepository>((ref) => LocalLoanRepository());
