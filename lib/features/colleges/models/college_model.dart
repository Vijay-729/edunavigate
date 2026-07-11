import 'course_model.dart';

enum CollegeType { government, private, autonomous, deemed }

extension CollegeTypeX on CollegeType {
  String get label {
    switch (this) {
      case CollegeType.government:
        return 'Government';
      case CollegeType.private:
        return 'Private';
      case CollegeType.autonomous:
        return 'Autonomous';
      case CollegeType.deemed:
        return 'Deemed University';
    }
  }
}

enum CollegeFacility {
  library,
  labs,
  sports,
  hostel,
  wifi,
  medical,
  gym,
  cafeteria
}

extension CollegeFacilityX on CollegeFacility {
  String get label {
    switch (this) {
      case CollegeFacility.library:
        return 'Library';
      case CollegeFacility.labs:
        return 'Labs';
      case CollegeFacility.sports:
        return 'Sports';
      case CollegeFacility.hostel:
        return 'Hostel';
      case CollegeFacility.wifi:
        return 'Wi-Fi Campus';
      case CollegeFacility.medical:
        return 'Medical Centre';
      case CollegeFacility.gym:
        return 'Gymnasium';
      case CollegeFacility.cafeteria:
        return 'Cafeteria';
    }
  }
}

/// One admission-cutoff data point: "for this exam+course+category+quota, the
/// closing rank/score in a previous cycle was X." The College Predictor
/// compares a student's rank against the closest-matching entry.
class CutoffEntry {
  final String examId;
  final String courseId;
  final String category; // general | obc | sc | st | ews | ph
  final bool homeStateQuota;
  final int year;
  final int? closingRank;
  final double? closingScore;

  const CutoffEntry({
    required this.examId,
    required this.courseId,
    this.category = 'general',
    this.homeStateQuota = false,
    this.year = 2025,
    this.closingRank,
    this.closingScore,
  });

  Map<String, dynamic> toMap() => {
        'examId': examId,
        'courseId': courseId,
        'category': category,
        'homeStateQuota': homeStateQuota,
        'year': year,
        'closingRank': closingRank,
        'closingScore': closingScore,
      };

  factory CutoffEntry.fromMap(Map<String, dynamic> map) => CutoffEntry(
        examId: map['examId'] as String,
        courseId: map['courseId'] as String,
        category: map['category'] as String? ?? 'general',
        homeStateQuota: map['homeStateQuota'] as bool? ?? false,
        year: map['year'] as int? ?? 2025,
        closingRank: map['closingRank'] as int?,
        closingScore: (map['closingScore'] as num?)?.toDouble(),
      );
}

class PlacementStats {
  final double averagePackageLpa;
  final double highestPackageLpa;
  final double placementPercentage;
  final List<String> topRecruiters;

  const PlacementStats({
    required this.averagePackageLpa,
    required this.highestPackageLpa,
    this.placementPercentage = 0,
    this.topRecruiters = const [],
  });

  Map<String, dynamic> toMap() => {
        'averagePackageLpa': averagePackageLpa,
        'highestPackageLpa': highestPackageLpa,
        'placementPercentage': placementPercentage,
        'topRecruiters': topRecruiters,
      };

  factory PlacementStats.fromMap(Map<String, dynamic> map) => PlacementStats(
        averagePackageLpa: (map['averagePackageLpa'] as num?)?.toDouble() ?? 0,
        highestPackageLpa: (map['highestPackageLpa'] as num?)?.toDouble() ?? 0,
        placementPercentage:
            (map['placementPercentage'] as num?)?.toDouble() ?? 0,
        topRecruiters:
            (map['topRecruiters'] as List?)?.cast<String>() ?? const [],
      );
}

class CollegeFees {
  final int tuitionPerYear;
  final int hostelPerYear;

  const CollegeFees({required this.tuitionPerYear, this.hostelPerYear = 0});

  int get totalPerYear => tuitionPerYear + hostelPerYear;

  Map<String, dynamic> toMap() => {
        'tuitionPerYear': tuitionPerYear,
        'hostelPerYear': hostelPerYear,
      };

  factory CollegeFees.fromMap(Map<String, dynamic> map) => CollegeFees(
        tuitionPerYear: map['tuitionPerYear'] as int? ?? 0,
        hostelPerYear: map['hostelPerYear'] as int? ?? 0,
      );
}

class CollegeReview {
  final String author;
  final double rating;
  final String comment;

  const CollegeReview(
      {required this.author, required this.rating, required this.comment});

  Map<String, dynamic> toMap() =>
      {'author': author, 'rating': rating, 'comment': comment};

  factory CollegeReview.fromMap(Map<String, dynamic> map) => CollegeReview(
        author: map['author'] as String? ?? 'Student',
        rating: (map['rating'] as num?)?.toDouble() ?? 4.0,
        comment: map['comment'] as String? ?? '',
      );
}

class FaqEntry {
  final String question;
  final String answer;

  const FaqEntry({required this.question, required this.answer});

  Map<String, dynamic> toMap() => {'question': question, 'answer': answer};

  factory FaqEntry.fromMap(Map<String, dynamic> map) => FaqEntry(
        question: map['question'] as String? ?? '',
        answer: map['answer'] as String? ?? '',
      );
}

/// A single college/institute. Designed to map 1:1 onto a future Firestore
/// `colleges/{id}` document — every field is JSON-serialisable and nested
/// value objects carry their own `toMap`/`fromMap`.
class CollegeModel {
  final String id;
  final String name;
  final String city;
  final String state;
  final CollegeType type;
  final int? nirfRank;
  final String? naacGrade;
  final bool nbaAccredited;
  final int? establishedYear;
  final String about;
  final List<CourseModel> courses;
  final String admissionProcess;
  final List<CutoffEntry> cutoffs;
  final CollegeFees fees;
  final bool scholarshipsAvailable;
  final String scholarshipInfo;
  final PlacementStats placement;
  final List<CollegeFacility> facilities;
  final String facultyInfo;
  final List<CollegeReview> reviews;
  final List<FaqEntry> faqs;
  final String website;
  final String contactEmail;
  final String contactPhone;
  final double? latitude;
  final double? longitude;
  final List<String> tags;
  final int popularityScore; // drives "Trending" / "Most Popular" sort

  const CollegeModel({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
    required this.type,
    this.nirfRank,
    this.naacGrade,
    this.nbaAccredited = false,
    this.establishedYear,
    required this.about,
    this.courses = const [],
    this.admissionProcess = '',
    this.cutoffs = const [],
    required this.fees,
    this.scholarshipsAvailable = false,
    this.scholarshipInfo = '',
    required this.placement,
    this.facilities = const [],
    this.facultyInfo = '',
    this.reviews = const [],
    this.faqs = const [],
    this.website = '',
    this.contactEmail = '',
    this.contactPhone = '',
    this.latitude,
    this.longitude,
    this.tags = const [],
    this.popularityScore = 50,
  });

  bool get isGovernment =>
      type == CollegeType.government || type == CollegeType.autonomous;

  bool get hasHostel => facilities.contains(CollegeFacility.hostel);

  String get logoInitials {
    final words = name.split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    final letters = words.take(2).map((w) => w[0].toUpperCase()).join();
    return letters.isEmpty ? '?' : letters;
  }

  double get averageRating {
    if (reviews.isEmpty) return 4.2;
    final sum = reviews.fold<double>(0, (a, r) => a + r.rating);
    return sum / reviews.length;
  }

  List<CourseCategory> get categories =>
      courses.map((c) => c.category).toSet().toList();

  /// Cheapest total-per-year fee across all offered courses; used for
  /// "Lowest Fees" sorting and the budget filter.
  int get startingFeePerYear => fees.totalPerYear;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'city': city,
        'state': state,
        'type': type.name,
        'nirfRank': nirfRank,
        'naacGrade': naacGrade,
        'nbaAccredited': nbaAccredited,
        'establishedYear': establishedYear,
        'about': about,
        'courses': courses.map((c) => c.toMap()).toList(),
        'admissionProcess': admissionProcess,
        'cutoffs': cutoffs.map((c) => c.toMap()).toList(),
        'fees': fees.toMap(),
        'scholarshipsAvailable': scholarshipsAvailable,
        'scholarshipInfo': scholarshipInfo,
        'placement': placement.toMap(),
        'facilities': facilities.map((f) => f.name).toList(),
        'facultyInfo': facultyInfo,
        'reviews': reviews.map((r) => r.toMap()).toList(),
        'faqs': faqs.map((f) => f.toMap()).toList(),
        'website': website,
        'contactEmail': contactEmail,
        'contactPhone': contactPhone,
        'latitude': latitude,
        'longitude': longitude,
        'tags': tags,
        'popularityScore': popularityScore,
      };

  factory CollegeModel.fromMap(Map<String, dynamic> map) {
    return CollegeModel(
      id: map['id'] as String,
      name: map['name'] as String,
      city: map['city'] as String? ?? '',
      state: map['state'] as String? ?? '',
      type: CollegeType.values.firstWhere(
        (t) => t.name == map['type'],
        orElse: () => CollegeType.private,
      ),
      nirfRank: map['nirfRank'] as int?,
      naacGrade: map['naacGrade'] as String?,
      nbaAccredited: map['nbaAccredited'] as bool? ?? false,
      establishedYear: map['establishedYear'] as int?,
      about: map['about'] as String? ?? '',
      courses: (map['courses'] as List? ?? [])
          .map((c) => CourseModel.fromMap(Map<String, dynamic>.from(c as Map)))
          .toList(),
      admissionProcess: map['admissionProcess'] as String? ?? '',
      cutoffs: (map['cutoffs'] as List? ?? [])
          .map((c) => CutoffEntry.fromMap(Map<String, dynamic>.from(c as Map)))
          .toList(),
      fees: CollegeFees.fromMap(
          Map<String, dynamic>.from(map['fees'] as Map? ?? {})),
      scholarshipsAvailable: map['scholarshipsAvailable'] as bool? ?? false,
      scholarshipInfo: map['scholarshipInfo'] as String? ?? '',
      placement: PlacementStats.fromMap(
          Map<String, dynamic>.from(map['placement'] as Map? ?? {})),
      facilities: (map['facilities'] as List? ?? [])
          .map((f) => CollegeFacility.values.firstWhere((e) => e.name == f,
              orElse: () => CollegeFacility.library))
          .toList(),
      facultyInfo: map['facultyInfo'] as String? ?? '',
      reviews: (map['reviews'] as List? ?? [])
          .map(
              (r) => CollegeReview.fromMap(Map<String, dynamic>.from(r as Map)))
          .toList(),
      faqs: (map['faqs'] as List? ?? [])
          .map((f) => FaqEntry.fromMap(Map<String, dynamic>.from(f as Map)))
          .toList(),
      website: map['website'] as String? ?? '',
      contactEmail: map['contactEmail'] as String? ?? '',
      contactPhone: map['contactPhone'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      tags: (map['tags'] as List?)?.cast<String>() ?? const [],
      popularityScore: map['popularityScore'] as int? ?? 50,
    );
  }
}
