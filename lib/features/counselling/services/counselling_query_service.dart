import '../models/counselling_model.dart';

enum CounsellingSortOrder { relevance, mostPopular, nearestDate, alphabetical }

extension CounsellingSortOrderX on CounsellingSortOrder {
  String get label {
    switch (this) {
      case CounsellingSortOrder.relevance:
        return 'Relevance';
      case CounsellingSortOrder.mostPopular:
        return 'Most Popular';
      case CounsellingSortOrder.nearestDate:
        return 'Nearest Date';
      case CounsellingSortOrder.alphabetical:
        return 'A–Z';
    }
  }
}

class CounsellingFilter {
  final String query;
  final CounsellingCategory? category;
  final bool upcomingOnly;

  const CounsellingFilter({
    this.query = '',
    this.category,
    this.upcomingOnly = false,
  });

  CounsellingFilter copyWith({
    String? query,
    CounsellingCategory? category,
    bool clearCategory = false,
    bool? upcomingOnly,
  }) {
    return CounsellingFilter(
      query: query ?? this.query,
      category: clearCategory ? null : (category ?? this.category),
      upcomingOnly: upcomingOnly ?? this.upcomingOnly,
    );
  }
}

/// Pure search/filter/sort logic for counselling programs.
class CounsellingQueryService {
  CounsellingQueryService._();

  static List<CounsellingProgram> search(
      List<CounsellingProgram> items, String rawQuery) {
    final query = rawQuery.trim().toLowerCase();
    if (query.isEmpty) return items;
    return items.where((p) {
      final haystack = '${p.name} ${p.fullName} ${p.conductingBody} '
              '${p.tags.join(' ')}'
          .toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  static List<CounsellingProgram> filter(
      List<CounsellingProgram> items, CounsellingFilter filter) {
    return items.where((p) {
      if (filter.category != null && p.category != filter.category) {
        return false;
      }
      if (filter.upcomingOnly && !p.isUpcoming) return false;
      return true;
    }).toList();
  }

  static List<CounsellingProgram> sort(
      List<CounsellingProgram> items, CounsellingSortOrder order) {
    final list = List<CounsellingProgram>.from(items);
    switch (order) {
      case CounsellingSortOrder.relevance:
        break;
      case CounsellingSortOrder.mostPopular:
        list.sort((a, b) => b.popularityScore.compareTo(a.popularityScore));
        break;
      case CounsellingSortOrder.nearestDate:
        list.sort((a, b) {
          final da = a.nextUpcomingEvent?.date;
          final db = b.nextUpcomingEvent?.date;
          if (da == null && db == null) return 0;
          if (da == null) return 1;
          if (db == null) return -1;
          return da.compareTo(db);
        });
        break;
      case CounsellingSortOrder.alphabetical:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
    }
    return list;
  }
}
