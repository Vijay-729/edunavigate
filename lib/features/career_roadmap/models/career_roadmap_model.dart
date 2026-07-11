import 'package:flutter/material.dart';

import '../../../core/models/faq_item.dart';

enum DemandLevel { low, medium, high, veryHigh }

extension DemandLevelX on DemandLevel {
  String get label {
    switch (this) {
      case DemandLevel.low:
        return 'Low Demand';
      case DemandLevel.medium:
        return 'Medium Demand';
      case DemandLevel.high:
        return 'High Demand';
      case DemandLevel.veryHigh:
        return 'Very High Demand';
    }
  }
}

/// One stage of the 12th → leadership interactive roadmap.
class CareerRoadmapStep {
  final String title;
  final String subtitle;
  final String detail;
  const CareerRoadmapStep(
      {required this.title, required this.subtitle, required this.detail});

  Map<String, dynamic> toMap() =>
      {'title': title, 'subtitle': subtitle, 'detail': detail};
  factory CareerRoadmapStep.fromMap(Map<String, dynamic> map) =>
      CareerRoadmapStep(
        title: map['title'] as String? ?? '',
        subtitle: map['subtitle'] as String? ?? '',
        detail: map['detail'] as String? ?? '',
      );
}

/// Beginner → Advanced skill progression plus projects/certificates/books/
/// courses — the "Skill Roadmap" section of a career page.
class CareerSkillRoadmap {
  final List<String> beginnerSkills;
  final List<String> intermediateSkills;
  final List<String> advancedSkills;
  final List<String> projects;
  final List<String> certificates;
  final List<String> books;
  final List<String> courses;

  const CareerSkillRoadmap({
    this.beginnerSkills = const [],
    this.intermediateSkills = const [],
    this.advancedSkills = const [],
    this.projects = const [],
    this.certificates = const [],
    this.books = const [],
    this.courses = const [],
  });

  Map<String, dynamic> toMap() => {
        'beginnerSkills': beginnerSkills,
        'intermediateSkills': intermediateSkills,
        'advancedSkills': advancedSkills,
        'projects': projects,
        'certificates': certificates,
        'books': books,
        'courses': courses,
      };

  factory CareerSkillRoadmap.fromMap(Map<String, dynamic> map) =>
      CareerSkillRoadmap(
        beginnerSkills:
            (map['beginnerSkills'] as List?)?.cast<String>() ?? const [],
        intermediateSkills:
            (map['intermediateSkills'] as List?)?.cast<String>() ?? const [],
        advancedSkills:
            (map['advancedSkills'] as List?)?.cast<String>() ?? const [],
        projects: (map['projects'] as List?)?.cast<String>() ?? const [],
        certificates:
            (map['certificates'] as List?)?.cast<String>() ?? const [],
        books: (map['books'] as List?)?.cast<String>() ?? const [],
        courses: (map['courses'] as List?)?.cast<String>() ?? const [],
      );
}

/// A full career profile — overview through learning path. Firebase-ready:
/// `toMap`/`fromMap` mirror an intended `careerRoadmaps/{id}` document.
class CareerRoadmapModel {
  final String id;
  final String title;
  final String domain;
  final IconData icon;
  final Color accent;
  final String shortDescription;
  final String overview;
  final String dailyWork;
  final List<String> requiredSkills;
  final String eligibility;
  final List<String> bestDegrees;
  final List<String> bestColleges;
  final List<String> topRecruiters;
  final String indiaSalaryRange;
  final String internationalSalaryRange;
  final String futureScope;
  final String growthRate;
  final DemandLevel demandLevel;
  final String aiImpact;
  final bool remoteWorkFriendly;
  final double workLifeBalanceRating; // 1-5
  final List<String> pros;
  final List<String> cons;
  final List<String> requiredCertifications;
  final List<String> resources;
  final List<CareerRoadmapStep> roadmapSteps;
  final CareerSkillRoadmap skillRoadmap;
  final List<FaqItem> faqs;
  final List<String> tags;
  final int popularityScore;

  const CareerRoadmapModel({
    required this.id,
    required this.title,
    required this.domain,
    required this.icon,
    required this.accent,
    required this.shortDescription,
    required this.overview,
    required this.dailyWork,
    this.requiredSkills = const [],
    required this.eligibility,
    this.bestDegrees = const [],
    this.bestColleges = const [],
    this.topRecruiters = const [],
    required this.indiaSalaryRange,
    required this.internationalSalaryRange,
    required this.futureScope,
    required this.growthRate,
    required this.demandLevel,
    required this.aiImpact,
    required this.remoteWorkFriendly,
    required this.workLifeBalanceRating,
    this.pros = const [],
    this.cons = const [],
    this.requiredCertifications = const [],
    this.resources = const [],
    this.roadmapSteps = const [],
    this.skillRoadmap = const CareerSkillRoadmap(),
    this.faqs = const [],
    this.tags = const [],
    this.popularityScore = 50,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'domain': domain,
        'shortDescription': shortDescription,
        'overview': overview,
        'dailyWork': dailyWork,
        'requiredSkills': requiredSkills,
        'eligibility': eligibility,
        'bestDegrees': bestDegrees,
        'bestColleges': bestColleges,
        'topRecruiters': topRecruiters,
        'indiaSalaryRange': indiaSalaryRange,
        'internationalSalaryRange': internationalSalaryRange,
        'futureScope': futureScope,
        'growthRate': growthRate,
        'demandLevel': demandLevel.name,
        'aiImpact': aiImpact,
        'remoteWorkFriendly': remoteWorkFriendly,
        'workLifeBalanceRating': workLifeBalanceRating,
        'pros': pros,
        'cons': cons,
        'requiredCertifications': requiredCertifications,
        'resources': resources,
        'roadmapSteps': roadmapSteps.map((s) => s.toMap()).toList(),
        'skillRoadmap': skillRoadmap.toMap(),
        'faqs': faqs.map((f) => f.toMap()).toList(),
        'tags': tags,
        'popularityScore': popularityScore,
      };

  factory CareerRoadmapModel.fromMap(Map<String, dynamic> map,
      {required IconData icon, required Color accent}) {
    return CareerRoadmapModel(
      id: map['id'] as String,
      title: map['title'] as String,
      domain: map['domain'] as String? ?? '',
      icon: icon,
      accent: accent,
      shortDescription: map['shortDescription'] as String? ?? '',
      overview: map['overview'] as String? ?? '',
      dailyWork: map['dailyWork'] as String? ?? '',
      requiredSkills:
          (map['requiredSkills'] as List?)?.cast<String>() ?? const [],
      eligibility: map['eligibility'] as String? ?? '',
      bestDegrees: (map['bestDegrees'] as List?)?.cast<String>() ?? const [],
      bestColleges: (map['bestColleges'] as List?)?.cast<String>() ?? const [],
      topRecruiters:
          (map['topRecruiters'] as List?)?.cast<String>() ?? const [],
      indiaSalaryRange: map['indiaSalaryRange'] as String? ?? '',
      internationalSalaryRange:
          map['internationalSalaryRange'] as String? ?? '',
      futureScope: map['futureScope'] as String? ?? '',
      growthRate: map['growthRate'] as String? ?? '',
      demandLevel: DemandLevel.values.firstWhere(
          (d) => d.name == map['demandLevel'],
          orElse: () => DemandLevel.medium),
      aiImpact: map['aiImpact'] as String? ?? '',
      remoteWorkFriendly: map['remoteWorkFriendly'] as bool? ?? false,
      workLifeBalanceRating:
          (map['workLifeBalanceRating'] as num?)?.toDouble() ?? 3.0,
      pros: (map['pros'] as List?)?.cast<String>() ?? const [],
      cons: (map['cons'] as List?)?.cast<String>() ?? const [],
      requiredCertifications:
          (map['requiredCertifications'] as List?)?.cast<String>() ?? const [],
      resources: (map['resources'] as List?)?.cast<String>() ?? const [],
      roadmapSteps: (map['roadmapSteps'] as List? ?? [])
          .map((s) =>
              CareerRoadmapStep.fromMap(Map<String, dynamic>.from(s as Map)))
          .toList(),
      skillRoadmap: CareerSkillRoadmap.fromMap(
          Map<String, dynamic>.from(map['skillRoadmap'] as Map? ?? {})),
      faqs: (map['faqs'] as List? ?? [])
          .map((f) => FaqItem.fromMap(Map<String, dynamic>.from(f as Map)))
          .toList(),
      tags: (map['tags'] as List?)?.cast<String>() ?? const [],
      popularityScore: map['popularityScore'] as int? ?? 50,
    );
  }
}
