import 'package:flutter/material.dart';

/// A career option within a stream. Numeric fields (fees, salary, cutoffs
/// referenced elsewhere) are realistic *sample* figures meant to give
/// students a sense of scale — always shown in the UI with a note to verify
/// current figures before relying on them for decisions.
class StreamCareer {
  const StreamCareer({
    required this.id,
    required this.streamCode,
    required this.name,
    required this.icon,
    this.isEmerging = false,
    required this.overview,
    required this.eligibility,
    required this.requiredSkills,
    required this.entranceExamIds,
    required this.bestColleges,
    required this.courseDuration,
    required this.expectedFees,
    required this.scholarships,
    required this.averageSalary,
    required this.highestSalary,
    required this.futureScope,
    required this.topRecruiters,
    required this.workLifeBalance,
    required this.govtPrivateOpportunities,
    required this.higherStudyOptions,
  });

  final String id;
  final String streamCode;
  final String name;
  final IconData icon;
  final bool isEmerging;

  final String overview;
  final String eligibility;
  final List<String> requiredSkills;
  final List<String> entranceExamIds;
  final List<String> bestColleges;
  final String courseDuration;
  final String expectedFees;
  final String scholarships;
  final String averageSalary;
  final String highestSalary;
  final String futureScope;
  final List<String> topRecruiters;
  final String workLifeBalance;
  final String govtPrivateOpportunities;
  final List<String> higherStudyOptions;
}
