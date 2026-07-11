import 'package:flutter/material.dart';

enum CounsellingCategory {
  engineering,
  medical,
  cuet,
  law,
  management,
  agriculture,
  biotechnology,
  design,
  architecture,
  stateCounselling,
}

extension CounsellingCategoryX on CounsellingCategory {
  String get label {
    switch (this) {
      case CounsellingCategory.engineering:
        return 'Engineering';
      case CounsellingCategory.medical:
        return 'Medical';
      case CounsellingCategory.cuet:
        return 'CUET';
      case CounsellingCategory.law:
        return 'Law';
      case CounsellingCategory.management:
        return 'Management';
      case CounsellingCategory.agriculture:
        return 'Agriculture';
      case CounsellingCategory.biotechnology:
        return 'Biotechnology';
      case CounsellingCategory.design:
        return 'Design';
      case CounsellingCategory.architecture:
        return 'Architecture';
      case CounsellingCategory.stateCounselling:
        return 'State Counselling';
    }
  }

  IconData get icon {
    switch (this) {
      case CounsellingCategory.engineering:
        return Icons.precision_manufacturing_outlined;
      case CounsellingCategory.medical:
        return Icons.local_hospital_outlined;
      case CounsellingCategory.cuet:
        return Icons.school_outlined;
      case CounsellingCategory.law:
        return Icons.gavel_outlined;
      case CounsellingCategory.management:
        return Icons.groups_outlined;
      case CounsellingCategory.agriculture:
        return Icons.agriculture_outlined;
      case CounsellingCategory.biotechnology:
        return Icons.biotech_outlined;
      case CounsellingCategory.design:
        return Icons.design_services_outlined;
      case CounsellingCategory.architecture:
        return Icons.architecture_outlined;
      case CounsellingCategory.stateCounselling:
        return Icons.map_outlined;
    }
  }
}

class FaqItem {
  final String question;
  final String answer;
  const FaqItem({required this.question, required this.answer});

  Map<String, dynamic> toMap() => {'question': question, 'answer': answer};
  factory FaqItem.fromMap(Map<String, dynamic> map) => FaqItem(
        question: map['question'] as String? ?? '',
        answer: map['answer'] as String? ?? '',
      );
}

class VideoResource {
  final String title;
  final String url;
  const VideoResource({required this.title, required this.url});

  Map<String, dynamic> toMap() => {'title': title, 'url': url};
  factory VideoResource.fromMap(Map<String, dynamic> map) => VideoResource(
        title: map['title'] as String? ?? '',
        url: map['url'] as String? ?? '',
      );
}

/// One node of the interactive registration→reporting timeline.
class CounsellingTimelineStep {
  final String title;
  final String subtitle;
  final String detail;
  const CounsellingTimelineStep(
      {required this.title, required this.subtitle, required this.detail});

  Map<String, dynamic> toMap() =>
      {'title': title, 'subtitle': subtitle, 'detail': detail};
  factory CounsellingTimelineStep.fromMap(Map<String, dynamic> map) =>
      CounsellingTimelineStep(
        title: map['title'] as String? ?? '',
        subtitle: map['subtitle'] as String? ?? '',
        detail: map['detail'] as String? ?? '',
      );
}

/// A single dated event shown on the counselling calendar.
class CounsellingDateEvent {
  final String label;
  final DateTime date;
  const CounsellingDateEvent({required this.label, required this.date});

  Map<String, dynamic> toMap() =>
      {'label': label, 'date': date.toIso8601String()};
  factory CounsellingDateEvent.fromMap(Map<String, dynamic> map) =>
      CounsellingDateEvent(
        label: map['label'] as String? ?? '',
        date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      );
}

/// A full admission-counselling process (e.g. JoSAA, NEET-UG MCC, CUET-UG).
/// Firebase-ready — `toMap`/`fromMap` mirror an intended
/// `counsellingPrograms/{id}` Firestore document.
class CounsellingProgram {
  final String id;
  final String name;
  final String fullName;
  final CounsellingCategory category;
  final String conductingBody;
  final String about;
  final String eligibility;
  final String registrationProcess;
  final String choiceFillingInfo;
  final String choiceLockingInfo;
  final String seatAllotmentInfo;
  final String documentVerificationInfo;
  final String reportingInfo;
  final String admissionConfirmationInfo;
  final List<String> importantInstructions;
  final List<String> reservationRules;
  final String seatMatrixNote;
  final List<String> previousYearCutoffs;
  final List<FaqItem> faqs;
  final List<String> requiredDocuments;
  final List<String> documentChecklist;
  final List<String> commonMistakes;
  final List<VideoResource> videoResources;
  final String officialWebsite;
  final String contactEmail;
  final String contactPhone;
  final List<CounsellingTimelineStep> timelineSteps;
  final List<CounsellingDateEvent> dateEvents;
  final List<String> tags;
  final int popularityScore;

  const CounsellingProgram({
    required this.id,
    required this.name,
    required this.fullName,
    required this.category,
    required this.conductingBody,
    required this.about,
    required this.eligibility,
    required this.registrationProcess,
    required this.choiceFillingInfo,
    required this.choiceLockingInfo,
    required this.seatAllotmentInfo,
    required this.documentVerificationInfo,
    required this.reportingInfo,
    required this.admissionConfirmationInfo,
    this.importantInstructions = const [],
    this.reservationRules = const [],
    this.seatMatrixNote = '',
    this.previousYearCutoffs = const [],
    this.faqs = const [],
    this.requiredDocuments = const [],
    this.documentChecklist = const [],
    this.commonMistakes = const [],
    this.videoResources = const [],
    this.officialWebsite = '',
    this.contactEmail = '',
    this.contactPhone = '',
    this.timelineSteps = const [],
    this.dateEvents = const [],
    this.tags = const [],
    this.popularityScore = 50,
  });

  /// Next upcoming dated event (relative to now), or null if all are past.
  CounsellingDateEvent? get nextUpcomingEvent {
    final now = DateTime.now();
    final upcoming = dateEvents.where((e) => e.date.isAfter(now)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return upcoming.isEmpty ? null : upcoming.first;
  }

  bool get isUpcoming => nextUpcomingEvent != null;

  /// Most recently passed dated event — used to surface "currently active /
  /// just happened" programs in the "Recent Counselling" rail.
  CounsellingDateEvent? get mostRecentPastEvent {
    final now = DateTime.now();
    final past = dateEvents.where((e) => e.date.isBefore(now)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return past.isEmpty ? null : past.first;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'fullName': fullName,
        'category': category.name,
        'conductingBody': conductingBody,
        'about': about,
        'eligibility': eligibility,
        'registrationProcess': registrationProcess,
        'choiceFillingInfo': choiceFillingInfo,
        'choiceLockingInfo': choiceLockingInfo,
        'seatAllotmentInfo': seatAllotmentInfo,
        'documentVerificationInfo': documentVerificationInfo,
        'reportingInfo': reportingInfo,
        'admissionConfirmationInfo': admissionConfirmationInfo,
        'importantInstructions': importantInstructions,
        'reservationRules': reservationRules,
        'seatMatrixNote': seatMatrixNote,
        'previousYearCutoffs': previousYearCutoffs,
        'faqs': faqs.map((f) => f.toMap()).toList(),
        'requiredDocuments': requiredDocuments,
        'documentChecklist': documentChecklist,
        'commonMistakes': commonMistakes,
        'videoResources': videoResources.map((v) => v.toMap()).toList(),
        'officialWebsite': officialWebsite,
        'contactEmail': contactEmail,
        'contactPhone': contactPhone,
        'timelineSteps': timelineSteps.map((t) => t.toMap()).toList(),
        'dateEvents': dateEvents.map((d) => d.toMap()).toList(),
        'tags': tags,
        'popularityScore': popularityScore,
      };

  factory CounsellingProgram.fromMap(Map<String, dynamic> map) {
    return CounsellingProgram(
      id: map['id'] as String,
      name: map['name'] as String,
      fullName: map['fullName'] as String? ?? '',
      category: CounsellingCategory.values.firstWhere(
        (c) => c.name == map['category'],
        orElse: () => CounsellingCategory.engineering,
      ),
      conductingBody: map['conductingBody'] as String? ?? '',
      about: map['about'] as String? ?? '',
      eligibility: map['eligibility'] as String? ?? '',
      registrationProcess: map['registrationProcess'] as String? ?? '',
      choiceFillingInfo: map['choiceFillingInfo'] as String? ?? '',
      choiceLockingInfo: map['choiceLockingInfo'] as String? ?? '',
      seatAllotmentInfo: map['seatAllotmentInfo'] as String? ?? '',
      documentVerificationInfo:
          map['documentVerificationInfo'] as String? ?? '',
      reportingInfo: map['reportingInfo'] as String? ?? '',
      admissionConfirmationInfo:
          map['admissionConfirmationInfo'] as String? ?? '',
      importantInstructions:
          (map['importantInstructions'] as List?)?.cast<String>() ?? const [],
      reservationRules:
          (map['reservationRules'] as List?)?.cast<String>() ?? const [],
      seatMatrixNote: map['seatMatrixNote'] as String? ?? '',
      previousYearCutoffs:
          (map['previousYearCutoffs'] as List?)?.cast<String>() ?? const [],
      faqs: (map['faqs'] as List? ?? [])
          .map((f) => FaqItem.fromMap(Map<String, dynamic>.from(f as Map)))
          .toList(),
      requiredDocuments:
          (map['requiredDocuments'] as List?)?.cast<String>() ?? const [],
      documentChecklist:
          (map['documentChecklist'] as List?)?.cast<String>() ?? const [],
      commonMistakes:
          (map['commonMistakes'] as List?)?.cast<String>() ?? const [],
      videoResources: (map['videoResources'] as List? ?? [])
          .map(
              (v) => VideoResource.fromMap(Map<String, dynamic>.from(v as Map)))
          .toList(),
      officialWebsite: map['officialWebsite'] as String? ?? '',
      contactEmail: map['contactEmail'] as String? ?? '',
      contactPhone: map['contactPhone'] as String? ?? '',
      timelineSteps: (map['timelineSteps'] as List? ?? [])
          .map((t) => CounsellingTimelineStep.fromMap(
              Map<String, dynamic>.from(t as Map)))
          .toList(),
      dateEvents: (map['dateEvents'] as List? ?? [])
          .map((d) =>
              CounsellingDateEvent.fromMap(Map<String, dynamic>.from(d as Map)))
          .toList(),
      tags: (map['tags'] as List?)?.cast<String>() ?? const [],
      popularityScore: map['popularityScore'] as int? ?? 50,
    );
  }
}
