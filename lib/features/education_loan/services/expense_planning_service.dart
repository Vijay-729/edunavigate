import '../models/emi_calculation_model.dart';
import '../models/expense_estimate_model.dart';
import 'emi_calculator_service.dart';

/// Estimates the full cost of a course (tuition, hostel, books, living,
/// travel) and suggests a loan/scholarship/family-contribution split —
/// the "AI suggests" output of the Financial Planning tool.
class ExpensePlanningService {
  ExpensePlanningService._();

  static const _assumedInterestRate = 9.5;
  static const _assumedTenureYears = 10;

  static ExpensePlanResult estimate(ExpensePlanInput input) {
    final years = input.courseDurationYears;

    final hostelPerYear = !input.hostelRequired
        ? 0
        : switch (input.cityTier) {
            CityTier.metro => 150000,
            CityTier.tier2 => 100000,
            CityTier.tier3 => 70000,
          };
    final livingPerYear = switch (input.cityTier) {
      CityTier.metro => 40000,
      CityTier.tier2 => 28000,
      CityTier.tier3 => 18000,
    };
    const booksPerYear = 15000;
    const travelPerYear = 10000;

    final totalTuition = input.annualTuitionFee * years;
    final totalHostel = hostelPerYear * years;
    final totalBooks = booksPerYear * years;
    final totalLiving = livingPerYear * years;
    final totalTravel = travelPerYear * years;
    final totalExpense =
        totalTuition + totalHostel + totalBooks + totalLiving + totalTravel;

    final lowIncome = (input.familyAnnualIncome ?? 999999999) <= 800000;
    final scholarshipShare = lowIncome ? 0.12 : 0.05;
    final suggestedScholarship = (totalExpense * scholarshipShare).round();
    final familyShare = lowIncome ? 0.15 : 0.25;
    final suggestedFamilyContribution = (totalExpense * familyShare).round();
    final suggestedLoan =
        totalExpense - suggestedScholarship - suggestedFamilyContribution;

    final emi = EmiCalculatorService.calculate(EmiInput(
      loanAmount: suggestedLoan.toDouble(),
      annualInterestRate: _assumedInterestRate,
      tenureYears: _assumedTenureYears,
    ));

    return ExpensePlanResult(
      totalTuition: totalTuition,
      totalHostel: totalHostel,
      totalBooks: totalBooks,
      totalLiving: totalLiving,
      totalTravel: totalTravel,
      totalExpense: totalExpense,
      suggestedLoanAmount: suggestedLoan,
      suggestedScholarshipAmount: suggestedScholarship,
      suggestedFamilyContribution: suggestedFamilyContribution,
      estimatedMonthlyEmi: emi.monthlyEmi,
    );
  }
}
