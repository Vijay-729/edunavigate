import '../../../core/models/faq_item.dart';
import 'exam_category.dart';

/// One dated milestone (registration, admit card, exam day, result) shown
/// on the exam's timeline and the shared Exam Calendar.
class ExamDateEvent {
  final String label;
  final DateTime date;
  const ExamDateEvent({required this.label, required this.date});

  Map<String, dynamic> toMap() =>
      {'label': label, 'date': date.toIso8601String()};
  factory ExamDateEvent.fromMap(Map<String, dynamic> map) => ExamDateEvent(
        label: map['label'] as String? ?? '',
        date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      );
}

/// A full entrance-exam profile. Firebase-ready — `toMap`/`fromMap` mirror
/// an intended `examProfiles/{id}` Firestore document.
class ExamProfileModel {
  final String id;
  final String shortName;
  final String fullName;
  final ExamCategory category;
  final String conductingBody;
  final ExamDifficulty difficulty;
  final ExamMode mode;
  final String about;
  final String eligibility;
  final String ageLimit;
  final String educationalQualification;
  final String applicationFees;
  final String applicationProcess;
  final List<String> examPattern;
  final String markingScheme;
  final List<String> syllabus;
  final String preparationStrategy;
  final List<String> bestBooks;
  final String previousYearPapersInfo;
  final String mockTestsInfo;
  final List<String> cutoffs;
  final String resultInfo;
  final String counsellingInfo;
  final List<String> topCollegesAccepting;
  final List<String> careerOpportunities;
  final String officialWebsite;
  final List<FaqItem> faqs;
  final List<ExamDateEvent> dateEvents;
  final int popularityScore;

  /// Only set for state-level exams (e.g. WBJEE, MHT CET) — used by search
  /// and shown as a chip; null for national/all-India exams.
  final String? state;

  /// Short subject tags distinct from the full [syllabus] topic list, e.g.
  /// `['Physics', 'Chemistry', 'Mathematics']`.
  final List<String> subjects;
  final String duration;
  final String numberOfAttempts;

  /// This year's predicted cutoff (a single forward-looking line), separate
  /// from [cutoffs] which holds actual previous-year results.
  final String expectedCutoff;

  /// Wikipedia article title used to fetch a real logo/banner image via the
  /// same enrichment widgets already built for Explore/Scholarships
  /// (`EnrichedCardPhoto`/`InstitutionLogoAvatar`) — null falls back to the
  /// category icon.
  final String? wikipediaTitle;

  const ExamProfileModel({
    required this.id,
    required this.shortName,
    required this.fullName,
    required this.category,
    required this.conductingBody,
    required this.difficulty,
    required this.mode,
    required this.about,
    required this.eligibility,
    required this.ageLimit,
    required this.educationalQualification,
    required this.applicationFees,
    required this.applicationProcess,
    this.examPattern = const [],
    required this.markingScheme,
    this.syllabus = const [],
    required this.preparationStrategy,
    this.bestBooks = const [],
    required this.previousYearPapersInfo,
    required this.mockTestsInfo,
    this.cutoffs = const [],
    required this.resultInfo,
    required this.counsellingInfo,
    this.topCollegesAccepting = const [],
    this.careerOpportunities = const [],
    this.officialWebsite = '',
    this.faqs = const [],
    this.dateEvents = const [],
    this.popularityScore = 50,
    this.state,
    this.subjects = const [],
    this.duration = '',
    this.numberOfAttempts = '',
    this.expectedCutoff = '',
    this.wikipediaTitle,
  });

  ExamDateEvent? get nextUpcomingEvent {
    final now = DateTime.now();
    final upcoming = dateEvents.where((e) => e.date.isAfter(now)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return upcoming.isEmpty ? null : upcoming.first;
  }

  ExamApplicationStatus get applicationStatus {
    final now = DateTime.now();
    final regEvent = dateEvents
        .where((e) => e.label.toLowerCase().contains('registration'))
        .toList();
    final examEvent = dateEvents
        .where((e) => e.label.toLowerCase().contains('exam date'))
        .toList();
    if (examEvent.isNotEmpty && examEvent.first.date.isBefore(now)) {
      return ExamApplicationStatus.completed;
    }
    if (regEvent.length >= 2) {
      final open = regEvent.first.date;
      final close = regEvent.last.date;
      if (now.isBefore(open)) return ExamApplicationStatus.upcoming;
      if (now.isAfter(close)) return ExamApplicationStatus.closed;
      return ExamApplicationStatus.ongoing;
    }
    return nextUpcomingEvent != null
        ? ExamApplicationStatus.upcoming
        : ExamApplicationStatus.completed;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'shortName': shortName,
        'fullName': fullName,
        'category': category.name,
        'conductingBody': conductingBody,
        'difficulty': difficulty.name,
        'mode': mode.name,
        'about': about,
        'eligibility': eligibility,
        'ageLimit': ageLimit,
        'educationalQualification': educationalQualification,
        'applicationFees': applicationFees,
        'applicationProcess': applicationProcess,
        'examPattern': examPattern,
        'markingScheme': markingScheme,
        'syllabus': syllabus,
        'preparationStrategy': preparationStrategy,
        'bestBooks': bestBooks,
        'previousYearPapersInfo': previousYearPapersInfo,
        'mockTestsInfo': mockTestsInfo,
        'cutoffs': cutoffs,
        'resultInfo': resultInfo,
        'counsellingInfo': counsellingInfo,
        'topCollegesAccepting': topCollegesAccepting,
        'careerOpportunities': careerOpportunities,
        'officialWebsite': officialWebsite,
        'faqs': faqs.map((f) => f.toMap()).toList(),
        'dateEvents': dateEvents.map((d) => d.toMap()).toList(),
        'popularityScore': popularityScore,
        'state': state,
        'subjects': subjects,
        'duration': duration,
        'numberOfAttempts': numberOfAttempts,
        'expectedCutoff': expectedCutoff,
        'wikipediaTitle': wikipediaTitle,
      };

  factory ExamProfileModel.fromMap(Map<String, dynamic> map) {
    return ExamProfileModel(
      id: map['id'] as String,
      shortName: map['shortName'] as String,
      fullName: map['fullName'] as String? ?? '',
      category: ExamCategory.values.firstWhere((c) => c.name == map['category'],
          orElse: () => ExamCategory.engineering),
      conductingBody: map['conductingBody'] as String? ?? '',
      difficulty: ExamDifficulty.values.firstWhere(
          (d) => d.name == map['difficulty'],
          orElse: () => ExamDifficulty.moderate),
      mode: ExamMode.values.firstWhere((m) => m.name == map['mode'],
          orElse: () => ExamMode.online),
      about: map['about'] as String? ?? '',
      eligibility: map['eligibility'] as String? ?? '',
      ageLimit: map['ageLimit'] as String? ?? '',
      educationalQualification:
          map['educationalQualification'] as String? ?? '',
      applicationFees: map['applicationFees'] as String? ?? '',
      applicationProcess: map['applicationProcess'] as String? ?? '',
      examPattern: (map['examPattern'] as List?)?.cast<String>() ?? const [],
      markingScheme: map['markingScheme'] as String? ?? '',
      syllabus: (map['syllabus'] as List?)?.cast<String>() ?? const [],
      preparationStrategy: map['preparationStrategy'] as String? ?? '',
      bestBooks: (map['bestBooks'] as List?)?.cast<String>() ?? const [],
      previousYearPapersInfo: map['previousYearPapersInfo'] as String? ?? '',
      mockTestsInfo: map['mockTestsInfo'] as String? ?? '',
      cutoffs: (map['cutoffs'] as List?)?.cast<String>() ?? const [],
      resultInfo: map['resultInfo'] as String? ?? '',
      counsellingInfo: map['counsellingInfo'] as String? ?? '',
      topCollegesAccepting:
          (map['topCollegesAccepting'] as List?)?.cast<String>() ?? const [],
      careerOpportunities:
          (map['careerOpportunities'] as List?)?.cast<String>() ?? const [],
      officialWebsite: map['officialWebsite'] as String? ?? '',
      faqs: (map['faqs'] as List? ?? [])
          .map((f) => FaqItem.fromMap(Map<String, dynamic>.from(f as Map)))
          .toList(),
      dateEvents: (map['dateEvents'] as List? ?? [])
          .map(
              (d) => ExamDateEvent.fromMap(Map<String, dynamic>.from(d as Map)))
          .toList(),
      popularityScore: map['popularityScore'] as int? ?? 50,
      state: map['state'] as String?,
      subjects: (map['subjects'] as List?)?.cast<String>() ?? const [],
      duration: map['duration'] as String? ?? '',
      numberOfAttempts: map['numberOfAttempts'] as String? ?? '',
      expectedCutoff: map['expectedCutoff'] as String? ?? '',
      wikipediaTitle: map['wikipediaTitle'] as String?,
    );
  }
}
