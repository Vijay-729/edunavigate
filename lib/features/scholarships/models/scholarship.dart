import 'package:flutter/material.dart';

/// Who funds the scholarship.
enum ScholarshipProvider { government, private }

/// Application-window status shown as a colored badge (spec: "Applications
/// Open", "Applications Closing Soon", "Closed", "Upcoming").
enum ScholarshipStatus { open, closingSoon, closed, upcoming }

/// A scholarship a student can view, bookmark, and apply to.
///
/// NOTE: [education_loan]'s Scholarship Finder (`scholarship_finder_service.dart`)
/// reuses this exact model and [ScholarshipData.all] — every field that
/// existed before the Scholarship Explorer enhancement (id, title,
/// organization, provider, states, maxFamilyIncome, minPercentage,
/// eligibility, amount, deadline, applyUrl, tags) keeps its original name and
/// type so that module keeps compiling untouched. Everything below is
/// additive.
class Scholarship {
  final String id;
  final String title;
  final String organization;
  final ScholarshipProvider provider;

  /// Empty list means "All India".
  final List<String> states;

  /// Maximum family annual income in INR for eligibility, or null if N/A.
  final int? maxFamilyIncome;

  /// Minimum qualifying percentage, or null if N/A.
  final int? minPercentage;

  final String eligibility;
  final String amount;
  final String deadline; // human-readable, e.g. "31 Oct 2026"
  final String applyUrl;
  final List<String> tags;

  // ── Scholarship Explorer enhancement (additive) ──────────────────────────

  /// `"en:Reliance Foundation"` (lang-prefixed, matching the Explore
  /// feature's convention) — used to look up a real logo/banner image via
  /// [InstitutionMediaService], free and keyless. Null when no reliable
  /// Wikipedia article is known for this provider.
  final String? wikipediaTitle;

  /// Fallback icon shown wherever no real logo/banner is found.
  final IconData icon;

  /// Longer-form description shown on the details page (distinct from the
  /// short [eligibility] line used on the card).
  final String description;

  /// Bullet-point benefits beyond the headline [amount] (e.g. "Free
  /// textbooks", "Laptop allowance").
  final List<String> benefits;

  /// Documents typically required to apply (e.g. "Aadhaar Card", "Income
  /// Certificate").
  final List<String> requiredDocuments;

  /// How applicants are shortlisted (merit list / exam / interview / direct
  /// disbursal). Empty → "Information not available".
  final String selectionProcess;

  /// Renewal conditions for multi-year scholarships (e.g. minimum
  /// year-on-year attendance/marks). Empty → "Information not available".
  final String renewalRules;

  /// Category reservations this scholarship is restricted to (e.g. ['SC'],
  /// ['OBC', 'EWS']). Empty means open to all categories.
  final List<String> categoryEligibility;

  /// Canonical class/level buckets this scholarship targets: any of
  /// 'Class 10', 'Class 12', 'UG', 'PG'. When left empty, [classLevelsResolved]
  /// derives an equivalent list from [tags] so the 12 original entries (which
  /// only ever set tags) still filter correctly.
  final List<String> classLevels;

  final bool girlsOnly;
  final bool disabledOnly;
  final bool meritBased;
  final bool incomeBased;

  /// When applications typically open. Null → unknown / not published.
  final DateTime? applicationOpenDate;

  /// Parsed last date to apply. Null → falls back to parsing [deadline]
  /// (e.g. "31 Oct 2026"); still null after that means "Rolling"/ongoing.
  final DateTime? closeDate;

  const Scholarship({
    required this.id,
    required this.title,
    required this.organization,
    required this.provider,
    this.states = const [],
    this.maxFamilyIncome,
    this.minPercentage,
    required this.eligibility,
    required this.amount,
    required this.deadline,
    required this.applyUrl,
    this.tags = const [],
    this.wikipediaTitle,
    this.icon = Icons.school_rounded,
    this.description = '',
    this.benefits = const [],
    this.requiredDocuments = const [],
    this.selectionProcess = '',
    this.renewalRules = '',
    this.categoryEligibility = const [],
    this.classLevels = const [],
    this.girlsOnly = false,
    this.disabledOnly = false,
    this.meritBased = false,
    this.incomeBased = false,
    this.applicationOpenDate,
    this.closeDate,
  });

  bool get isAllIndia => states.isEmpty;

  String get scopeLabel => isAllIndia ? 'All India' : states.join(', ');

  String get providerLabel =>
      provider == ScholarshipProvider.government ? 'Government' : 'Private';

  /// 'Central' for all-India government schemes, 'State' for state-run ones,
  /// null for private scholarships (the Central/State filter only applies to
  /// government schemes).
  String? get scopeKind {
    if (provider != ScholarshipProvider.government) return null;
    return isAllIndia ? 'Central' : 'State';
  }

  bool get isGirlsOnly =>
      girlsOnly || tags.any((t) => t.toLowerCase() == 'girls');

  bool get isDisabledOnly =>
      disabledOnly || tags.any((t) => t.toLowerCase().contains('disab'));

  bool get isMeritBased =>
      meritBased || tags.any((t) => t.toLowerCase() == 'merit');

  bool get isIncomeBased =>
      incomeBased ||
      maxFamilyIncome != null ||
      tags.any((t) => t.toLowerCase().contains('income'));

  /// Resolved class/level buckets — explicit [classLevels] when set, else
  /// derived from [tags] so the original seed entries (which predate this
  /// field) still classify correctly under the Class 10/Class 12/UG/PG
  /// filters.
  List<String> get classLevelsResolved {
    if (classLevels.isNotEmpty) return classLevels;
    final result = <String>{};
    for (final raw in tags) {
      final t = raw.toLowerCase();
      if (t.contains('class 9') || t.contains('class 10')) {
        result.add('Class 10');
      }
      if (t.contains('class 11') || t.contains('class 12')) {
        result.add('Class 12');
      }
      if (t.contains('undergraduate')) result.add('UG');
      if (t.contains('postgraduate')) result.add('PG');
    }
    return result.toList();
  }

  /// Best-effort last-date-to-apply, preferring the explicit [closeDate]
  /// and falling back to parsing [deadline] (e.g. "31 Oct 2026"). Returns
  /// null for "Rolling"/"Ongoing"/unparseable deadlines, which is treated as
  /// "always open" rather than an error.
  DateTime? get closeDateResolved => closeDate ?? _parseDate(deadline);

  /// Current application-window status, computed against the real device
  /// clock — never a hardcoded date.
  ScholarshipStatus get status {
    final now = DateTime.now();
    final open = applicationOpenDate;
    if (open != null && now.isBefore(open)) return ScholarshipStatus.upcoming;
    final close = closeDateResolved;
    if (close == null) return ScholarshipStatus.open;
    final closeEndOfDay =
        DateTime(close.year, close.month, close.day, 23, 59, 59);
    if (now.isAfter(closeEndOfDay)) return ScholarshipStatus.closed;
    if (closeEndOfDay.difference(now).inDays <= 15) {
      return ScholarshipStatus.closingSoon;
    }
    return ScholarshipStatus.open;
  }

  bool get isClosingSoon => status == ScholarshipStatus.closingSoon;

  /// Largest rupee figure mentioned in [amount] (handles "₹1,25,000",
  /// "₹2 Lakh", "₹1 Crore"), used only for "Highest Amount" sorting — 0 for
  /// non-numeric amounts like "Need based" so they sort last.
  int get amountValue {
    final lower = amount.toLowerCase();
    final matches =
        RegExp(r'[\d,]+(?:\.\d+)?').allMatches(amount).map((m) => m.group(0)!);
    var best = 0.0;
    for (final raw in matches) {
      final n = double.tryParse(raw.replaceAll(',', '')) ?? 0;
      if (n > best) best = n;
    }
    if (lower.contains('crore')) best *= 10000000;
    if (lower.contains('lakh') ||
        lower.contains(' l ') ||
        lower.endsWith('l')) {
      best *= 100000;
    }
    return best.round();
  }

  static DateTime? _parseDate(String raw) {
    const months = {
      'jan': 1,
      'feb': 2,
      'mar': 3,
      'apr': 4,
      'may': 5,
      'jun': 6,
      'jul': 7,
      'aug': 8,
      'sep': 9,
      'oct': 10,
      'nov': 11,
      'dec': 12,
    };
    final parts = raw.trim().split(RegExp(r'\s+'));
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = months[parts[1]
        .toLowerCase()
        .substring(0, parts[1].length >= 3 ? 3 : parts[1].length)];
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    return DateTime(year, month, day);
  }
}
