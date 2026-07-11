import '../models/career_roadmap_model.dart';

enum CareerSortOrder {
  relevance,
  mostPopular,
  alphabetical,
  highestSalary,
  demand
}

extension CareerSortOrderX on CareerSortOrder {
  String get label {
    switch (this) {
      case CareerSortOrder.relevance:
        return 'Relevance';
      case CareerSortOrder.mostPopular:
        return 'Most Popular';
      case CareerSortOrder.alphabetical:
        return 'A–Z';
      case CareerSortOrder.highestSalary:
        return 'Highest Salary Potential';
      case CareerSortOrder.demand:
        return 'Highest Demand';
    }
  }
}

class CareerFilter {
  final String query;
  final String? domain;
  final DemandLevel? demandLevel;
  final bool remoteOnly;

  const CareerFilter(
      {this.query = '',
      this.domain,
      this.demandLevel,
      this.remoteOnly = false});

  CareerFilter copyWith({
    String? query,
    String? domain,
    bool clearDomain = false,
    DemandLevel? demandLevel,
    bool clearDemand = false,
    bool? remoteOnly,
  }) {
    return CareerFilter(
      query: query ?? this.query,
      domain: clearDomain ? null : (domain ?? this.domain),
      demandLevel: clearDemand ? null : (demandLevel ?? this.demandLevel),
      remoteOnly: remoteOnly ?? this.remoteOnly,
    );
  }
}

/// Pure search/filter/sort logic for career roadmaps.
class CareerQueryService {
  CareerQueryService._();

  static List<CareerRoadmapModel> search(
      List<CareerRoadmapModel> items, String rawQuery) {
    final query = rawQuery.trim().toLowerCase();
    if (query.isEmpty) return items;
    return items.where((c) {
      final haystack =
          '${c.title} ${c.domain} ${c.tags.join(' ')} ${c.topRecruiters.join(' ')}'
              .toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  static List<CareerRoadmapModel> filter(
      List<CareerRoadmapModel> items, CareerFilter filter) {
    return items.where((c) {
      if (filter.domain != null && c.domain != filter.domain) return false;
      if (filter.demandLevel != null && c.demandLevel != filter.demandLevel) {
        return false;
      }
      if (filter.remoteOnly && !c.remoteWorkFriendly) return false;
      return true;
    }).toList();
  }

  static List<CareerRoadmapModel> sort(
      List<CareerRoadmapModel> items, CareerSortOrder order) {
    final list = List<CareerRoadmapModel>.from(items);
    switch (order) {
      case CareerSortOrder.relevance:
        break;
      case CareerSortOrder.mostPopular:
        list.sort((a, b) => b.popularityScore.compareTo(a.popularityScore));
        break;
      case CareerSortOrder.alphabetical:
        list.sort((a, b) => a.title.compareTo(b.title));
        break;
      case CareerSortOrder.highestSalary:
        list.sort((a, b) => _maxSalary(b.indiaSalaryRange)
            .compareTo(_maxSalary(a.indiaSalaryRange)));
        break;
      case CareerSortOrder.demand:
        list.sort((a, b) => b.demandLevel.index.compareTo(a.demandLevel.index));
        break;
    }
    return list;
  }

  static double _maxSalary(String range) {
    final matches = RegExp(r'(\d+)L')
        .allMatches(range)
        .map((m) => double.parse(m.group(1)!))
        .toList();
    if (matches.isEmpty) return 0;
    return matches.reduce((a, b) => a > b ? a : b);
  }

  static List<String> distinctDomains(List<CareerRoadmapModel> items) {
    final domains = items.map((c) => c.domain).toSet().toList()..sort();
    return domains;
  }
}
