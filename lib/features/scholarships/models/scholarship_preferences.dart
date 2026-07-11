/// Optional extra inputs for "Recommended For You" that aren't part of the
/// core [UserProfile] (category, family income, academic percentage,
/// disability status) — kept local to the Scholarship Explorer rather than
/// added to the shared profile/onboarding flow, since they're only used to
/// sharpen scholarship recommendations. Class, stream/course, state and
/// gender are read straight from the existing profile.
class ScholarshipPreferences {
  const ScholarshipPreferences({
    this.category,
    this.familyIncome,
    this.percentage,
    this.disabled = false,
  });

  /// 'General' | 'SC' | 'ST' | 'OBC' | 'EWS' | 'Minority', or null if unset.
  final String? category;

  /// Annual family income in INR, or null if unset.
  final int? familyIncome;

  /// Last qualifying exam percentage, or null if unset.
  final int? percentage;

  final bool disabled;

  bool get isEmpty =>
      category == null &&
      familyIncome == null &&
      percentage == null &&
      !disabled;

  ScholarshipPreferences copyWith({
    String? category,
    bool clearCategory = false,
    int? familyIncome,
    bool clearFamilyIncome = false,
    int? percentage,
    bool clearPercentage = false,
    bool? disabled,
  }) {
    return ScholarshipPreferences(
      category: clearCategory ? null : (category ?? this.category),
      familyIncome:
          clearFamilyIncome ? null : (familyIncome ?? this.familyIncome),
      percentage: clearPercentage ? null : (percentage ?? this.percentage),
      disabled: disabled ?? this.disabled,
    );
  }

  Map<String, dynamic> toMap() => {
        'category': category,
        'familyIncome': familyIncome,
        'percentage': percentage,
        'disabled': disabled,
      };

  factory ScholarshipPreferences.fromMap(Map<String, dynamic> map) {
    return ScholarshipPreferences(
      category: map['category'] as String?,
      familyIncome: map['familyIncome'] as int?,
      percentage: map['percentage'] as int?,
      disabled: map['disabled'] as bool? ?? false,
    );
  }
}
