import 'package:flutter/material.dart';

import '../../colleges/models/student_stream.dart';

/// A single curated career resource — a platform, sheet, course, or portal the
/// student can open externally. Mirrors the data-driven approach used by the
/// Scholarship Engine so every hub screen renders from pure data.
class ResourceItem {
  final String title;
  final String description;

  /// Where the resource comes from, e.g. "LeetCode", "NPTEL", "Internshala".
  final String source;

  /// External link opened with url_launcher.
  final String url;

  /// Short badge, e.g. "Free", "Freemium", "Official", "Paid".
  final String tag;

  /// Stand-in "logo" for the platform. Left null for hubs that predate this
  /// field so their cards render exactly as before.
  final IconData? icon;

  /// Who can appear for this exam, e.g. "B.E./B.Tech final year". Only used
  /// by exam-style resources (Higher Studies).
  final String? eligibility;

  /// Rough recommended prep window, e.g. "6-9 months". Only used by
  /// exam-style resources (Higher Studies).
  final String? prepTimeline;

  const ResourceItem({
    required this.title,
    required this.description,
    required this.source,
    required this.url,
    this.tag = 'Free',
    this.icon,
    this.eligibility,
    this.prepTimeline,
  });
}

/// A titled group of related resources within a hub (e.g. "Practice", "Courses").
class ResourceGroup {
  final String heading;
  final List<ResourceItem> items;

  /// For stream-aware hubs: the stream this group is most relevant to. Groups
  /// with `streamKey == null` (e.g. "Funding") are always shown. Ignored by
  /// hubs where [ResourceHub.streamAware] is false.
  final StudentStream? streamKey;

  const ResourceGroup(
      {required this.heading, required this.items, this.streamKey});
}

/// A complete career-readiness hub (Placement, Coding & DSA, Internships,
/// Certifications, Higher Studies). Rendered by [ResourceHubScreen].
class ResourceHub {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;

  /// One-paragraph intro shown at the top of the hub.
  final String intro;

  final List<ResourceGroup> groups;

  /// When true, [ResourceHubScreen] narrows [groups] down to the ones
  /// matching the student's active stream (see [ResourceGroup.streamKey]),
  /// falling back to showing every group if the stream isn't known yet.
  final bool streamAware;

  const ResourceHub({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.intro,
    required this.groups,
    this.streamAware = false,
  });
}
