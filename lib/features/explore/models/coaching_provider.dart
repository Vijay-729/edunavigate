import 'package:flutter/material.dart';

import '../../colleges/models/student_stream.dart';

/// A curated coaching institute/provider. Unlike [NearbySchool], this is
/// hand-maintained reference data (name, courses, exams, official links) —
/// not something OpenStreetMap reliably tags, so it's bundled with the app
/// rather than fetched live. See [CoachingProviders] for the seed list.
class CoachingProvider {
  const CoachingProvider({
    required this.id,
    required this.name,
    required this.icon,
    required this.about,
    required this.coursesOffered,
    required this.supportedStreams,
    required this.website,
    this.phone,
    this.email,
    required this.popularExams,
    required this.recommendationReason,
    this.wikipediaTitle,
    this.feeStructure = const [],
    this.scholarshipInfo = '',
    this.offersOnline = true,
    this.offersOffline = true,
    this.hasHostel = false,
    this.hasTestSeries = true,
    this.hasDoubtSupport = true,
    this.duration = 'Varies by course',
    this.rating = 4.2,
    this.popularResults = const [],
  });

  final String id;
  final String name;
  final IconData icon;
  final String about;
  final List<String> coursesOffered;
  final List<StudentStream> supportedStreams;
  final String website;
  final String? phone;
  final String? email;
  final List<String> popularExams;

  /// Shown under "Recommended for You", e.g. "Best for NEET preparation".
  final String recommendationReason;

  /// `"en:Allen Career Institute"` (lang-prefixed, matching OSM's convention)
  /// — used to look up a real logo/campus photo via
  /// [InstitutionMediaService], free and keyless. Null when no reliable
  /// Wikipedia article is known for this provider.
  final String? wikipediaTitle;

  /// Indicative fee-range bullet lines (e.g. "JEE 2-yr Classroom: ₹1.5L –
  /// ₹2.2L / year"). Approximate and course/city-dependent — always shown
  /// with a "confirm on official website" disclaimer, never as exact quotes.
  final List<String> feeStructure;

  /// Short description of the provider's known scholarship/scholarship-test
  /// programme, if any (e.g. Allen's ASAT). Empty string → "Information not
  /// available".
  final String scholarshipInfo;

  final bool offersOnline;
  final bool offersOffline;
  final bool hasHostel;
  final bool hasTestSeries;
  final bool hasDoubtSupport;

  /// Typical programme duration, e.g. "1–2 years (Foundation to Advanced)".
  final String duration;

  /// Indicative rating out of 5, shown for at-a-glance comparison — not
  /// sourced from a specific external review platform.
  final double rating;

  /// Well-known, general highlights (e.g. "Consistently strong JEE Advanced
  /// selections") — deliberately non-numeric/unverifiable-claim-free; shown
  /// under "Popular Results" on the detail page. Empty → "Information not
  /// available".
  final List<String> popularResults;

  /// First fee-structure line, shown as the card's at-a-glance "Starting
  /// Fee" — falls back to "Information not available" when [feeStructure]
  /// is empty.
  String get startingFeeLabel =>
      feeStructure.isEmpty ? 'Information not available' : feeStructure.first;
}
