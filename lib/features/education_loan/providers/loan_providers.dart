import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../../scholarships/data/scholarship_data.dart';
import '../../scholarships/models/scholarship.dart';
import '../data/loan_repository.dart';
import '../models/emi_calculation_model.dart';
import '../models/expense_estimate_model.dart';
import '../models/government_scheme_model.dart';
import '../models/loan_eligibility_model.dart';
import '../models/loan_model.dart';
import '../services/emi_calculator_service.dart';
import '../services/expense_planning_service.dart';
import '../services/loan_eligibility_service.dart';
import '../services/loan_query_service.dart';
import '../services/scholarship_finder_service.dart';

final loanSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');
final loanFilterProvider =
    StateProvider.autoDispose<LoanFilter>((ref) => const LoanFilter());
final loanSortOrderProvider =
    StateProvider.autoDispose<LoanSortOrder>((ref) => LoanSortOrder.relevance);

final allLoansProvider = Provider.autoDispose<List<LoanModel>>(
    (ref) => ref.watch(loanRepositoryProvider).getAllLoans());

final filteredLoansProvider = Provider.autoDispose<List<LoanModel>>((ref) {
  final all = ref.watch(allLoansProvider);
  final query = ref.watch(loanSearchQueryProvider);
  final filter = ref.watch(loanFilterProvider);
  final sort = ref.watch(loanSortOrderProvider);

  var result = LoanQueryService.search(all, query);
  result = LoanQueryService.filter(result, filter);
  result = LoanQueryService.sort(result, sort);
  return result;
});

final loanByIdProvider =
    Provider.autoDispose.family<LoanModel?, String>((ref, id) {
  return ref.watch(loanRepositoryProvider).getLoanById(id);
});

final allGovtSchemesProvider = Provider.autoDispose<List<GovtSchemeModel>>(
    (ref) => ref.watch(loanRepositoryProvider).getAllSchemes());

final loanBookmarkIdsProvider = StreamProvider.autoDispose<Set<String>>(
    (ref) => ref.watch(loanBookmarkRepositoryProvider).watchIds());

final savedLoansProvider = Provider.autoDispose<List<LoanModel>>((ref) {
  final all = ref.watch(allLoansProvider);
  final ids = ref.watch(loanBookmarkIdsProvider).asData?.value ?? const {};
  return all.where((l) => ids.contains(l.id)).toList();
});

/// Up to 4 loans selected for side-by-side comparison.
class LoanCompareListNotifier extends StateNotifier<List<String>> {
  LoanCompareListNotifier() : super(const []);

  static const maxCompare = 4;

  bool toggle(String id) {
    if (state.contains(id)) {
      state = state.where((e) => e != id).toList();
      return true;
    }
    if (state.length >= maxCompare) return false;
    state = [...state, id];
    return true;
  }

  void clear() => state = const [];
}

final loanCompareListProvider =
    StateNotifierProvider.autoDispose<LoanCompareListNotifier, List<String>>(
        (ref) => LoanCompareListNotifier());

// ── Eligibility Checker ─────────────────────────────────────────────────

class LoanEligibilityFormNotifier extends StateNotifier<LoanEligibilityInput> {
  LoanEligibilityFormNotifier() : super(const LoanEligibilityInput());

  void update(LoanEligibilityInput Function(LoanEligibilityInput) transform) {
    state = transform(state);
  }
}

final loanEligibilityFormProvider = StateNotifierProvider.autoDispose<
    LoanEligibilityFormNotifier,
    LoanEligibilityInput>((ref) => LoanEligibilityFormNotifier());

// Deliberately NOT autoDispose: computed via `ref.read` from the form screen
// (which never watches it) and then displayed on a pushed results screen —
// autodispose would tear the result down in the zero-listener gap between
// those two steps (see College Predictor's `predictionResultProvider`).
class LoanEligibilityResultNotifier
    extends StateNotifier<LoanEligibilityResult?> {
  LoanEligibilityResultNotifier() : super(null);

  void check(LoanEligibilityInput input) {
    state = LoanEligibilityService.evaluate(input);
  }
}

final loanEligibilityResultProvider = StateNotifierProvider<
    LoanEligibilityResultNotifier,
    LoanEligibilityResult?>((ref) => LoanEligibilityResultNotifier());

// ── EMI Calculator ───────────────────────────────────────────────────────

final emiInputProvider = StateProvider.autoDispose<EmiInput>((ref) =>
    const EmiInput(
        loanAmount: 1000000, annualInterestRate: 9.5, tenureYears: 10));

final emiResultProvider = Provider.autoDispose<EmiResult>((ref) {
  return EmiCalculatorService.calculate(ref.watch(emiInputProvider));
});

// ── Financial Planning ───────────────────────────────────────────────────

final expensePlanInputProvider = StateProvider.autoDispose<ExpensePlanInput>(
    (ref) => const ExpensePlanInput(annualTuitionFee: 200000));

final expensePlanResultProvider =
    Provider.autoDispose<ExpensePlanResult>((ref) {
  return ExpensePlanningService.estimate(ref.watch(expensePlanInputProvider));
});

// ── Scholarship Finder (reuses the Scholarships module's dataset/bookmarks) ─

final scholarshipFinderFilterProvider =
    StateProvider.autoDispose<ScholarshipFinderFilter>(
        (ref) => const ScholarshipFinderFilter());

final scholarshipFinderResultsProvider =
    Provider.autoDispose<List<Scholarship>>((ref) {
  final filter = ref.watch(scholarshipFinderFilterProvider);
  return ScholarshipFinderService.apply(ScholarshipData.all, filter);
});
