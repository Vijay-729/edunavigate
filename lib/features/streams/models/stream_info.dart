import 'package:flutter/material.dart';

/// The four streams a student picks between after Class 10.
class StreamInfo {
  const StreamInfo({
    required this.code,
    required this.name,
    required this.tagline,
    required this.icon,
    required this.gradientColors,
    required this.overview,
    required this.subjects,
    required this.skillsRequired,
    required this.whoShouldChoose,
    required this.pros,
    required this.cons,
    required this.futureOpportunities,
    required this.salaryExpectation,
    required this.growthOpportunities,
    required this.personalityTraits,
    required this.industriesHiring,
    required this.skillsToBuild,
    required this.examIds,
  });

  final String code; // 'pcm' | 'pcb' | 'commerce' | 'humanities'
  final String name;
  final String tagline;
  final IconData icon;
  final List<Color> gradientColors;

  final String overview;
  final List<String> subjects;
  final List<String> skillsRequired;
  final List<String> whoShouldChoose;
  final List<String> pros;
  final List<String> cons;
  final String futureOpportunities;
  final String salaryExpectation;
  final String growthOpportunities;
  final List<String> personalityTraits;
  final List<String> industriesHiring;
  final List<String> skillsToBuild;

  /// IDs into [StreamExamsData.all] — the entrance exams relevant to this
  /// stream.
  final List<String> examIds;

  Color get accent => gradientColors.first;
}
