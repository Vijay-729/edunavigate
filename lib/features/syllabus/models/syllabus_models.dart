import 'package:flutter/material.dart';

// ─── Board ────────────────────────────────────────────────────────────────────

enum Board { cbse, icse, stateBoard }

extension BoardExtension on Board {
  String get displayName {
    switch (this) {
      case Board.cbse:
        return 'CBSE';
      case Board.icse:
        return 'ICSE';
      case Board.stateBoard:
        return 'State Board';
    }
  }

  String get code {
    switch (this) {
      case Board.cbse:
        return 'cbse';
      case Board.icse:
        return 'icse';
      case Board.stateBoard:
        return 'state';
    }
  }

  static Board fromCode(String code) {
    switch (code) {
      case 'icse':
        return Board.icse;
      case 'state':
        return Board.stateBoard;
      default:
        return Board.cbse;
    }
  }
}

// ─── Core curriculum models ──────────────────────────────────────────────────

class SyllabusTopic {
  const SyllabusTopic({required this.id, required this.title});
  final String id;
  final String title;
}

class SyllabusChapter {
  const SyllabusChapter({
    required this.id,
    required this.title,
    required this.topics,
  });
  final String id;
  final String title;
  final List<SyllabusTopic> topics;
}

class SyllabusSubject {
  const SyllabusSubject({
    required this.code,
    required this.name,
    required this.icon,
    required this.color,
    required this.chapters,
  });

  final String code;
  final String name;
  final IconData icon;
  final Color color;
  final List<SyllabusChapter> chapters;

  int get totalTopics => chapters.fold(0, (sum, c) => sum + c.topics.length);
}

// ─── Content (Notes / PYQs) models ──────────────────────────────────────────

enum ContentType { note, pyq }

class ContentItem {
  const ContentItem({
    required this.id,
    required this.chapterId,
    required this.chapterTitle,
    required this.title,
    this.fileUrl,
    this.fileType = 'pdf',
    this.isAvailable = true,
    this.board,
    this.year,
    this.thumbnailUrl,
  });

  final String id;
  final String chapterId;
  final String chapterTitle;
  final String title;

  /// Remote URL of the PDF / image file.
  final String? fileUrl;

  /// 'pdf' | 'image'
  final String fileType;
  final bool isAvailable;

  /// PYQ-specific — e.g. 'CBSE', 'State Board'
  final String? board;

  /// PYQ-specific — e.g. '2023'
  final String? year;
  final String? thumbnailUrl;

  factory ContentItem.fromMap(String id, Map<String, dynamic> map) {
    return ContentItem(
      id: id,
      chapterId: map['chapterId'] as String? ?? '',
      chapterTitle: map['chapterTitle'] as String? ?? '',
      title: map['title'] as String? ?? '',
      fileUrl: map['fileUrl'] as String?,
      fileType: map['fileType'] as String? ?? 'pdf',
      isAvailable: map['isAvailable'] as bool? ?? true,
      board: map['board'] as String?,
      year: map['year'] as String?,
      thumbnailUrl: map['thumbnailUrl'] as String?,
    );
  }
}

// ─── Helper: class code from classOrYear string ───────────────────────────────

String classCodeFromProfile(String classOrYear) {
  final c = classOrYear.toLowerCase();
  if (c.contains('12')) return 'class_12';
  if (c.contains('11')) return 'class_11';
  if (c.contains('10')) return 'class_10';
  if (c.contains('9')) return 'class_9';
  if (c.contains('8')) return 'class_8';
  return 'class_9';
}

/// Composite key used as the Firestore document ID for progress and content.
String progressDocId(String classCode, String subjectCode) =>
    '${classCode}_$subjectCode';

/// Key in the progress map for a single topic.
String topicKey(String subjectCode, String topicId) =>
    '${subjectCode}_$topicId';
