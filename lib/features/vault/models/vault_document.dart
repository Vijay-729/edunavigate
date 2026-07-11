import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Keys used in [VaultDocument.detectedFields] — populated by
/// [VaultOcrService] from the Gemini-vision OCR pass, spec: "Automatically
/// detect Student Name, Document Type, Board, University, Passing Year,
/// Marks, CGPA, Roll Number, Registration Number, Certificate Number, Issue
/// Date, Expiry Date."
class VaultFieldKeys {
  VaultFieldKeys._();
  static const studentName = 'studentName';
  static const documentType = 'documentType';
  static const board = 'board';
  static const university = 'university';
  static const passingYear = 'passingYear';
  static const marks = 'marks';
  static const cgpa = 'cgpa';
  static const rollNumber = 'rollNumber';
  static const registrationNumber = 'registrationNumber';
  static const certificateNumber = 'certificateNumber';
  static const issueDate = 'issueDate';
  static const expiryDate = 'expiryDate';

  static const all = [
    studentName,
    documentType,
    board,
    university,
    passingYear,
    marks,
    cgpa,
    rollNumber,
    registrationNumber,
    certificateNumber,
    issueDate,
    expiryDate,
  ];

  static const labels = {
    studentName: 'Student Name',
    documentType: 'Document Type',
    board: 'Board',
    university: 'University',
    passingYear: 'Passing Year',
    marks: 'Marks',
    cgpa: 'CGPA',
    rollNumber: 'Roll Number',
    registrationNumber: 'Registration Number',
    certificateNumber: 'Certificate Number',
    issueDate: 'Issue Date',
    expiryDate: 'Expiry Date',
  };
}

/// A single document stored in EduVault. File bytes are AES-256 encrypted
/// before upload (see `VaultEncryptionService`) and live at [storagePath] in
/// Firebase Storage — this Firestore document only ever holds metadata, so
/// nothing here is sensitive plaintext beyond what the student already sees
/// on-screen.
class VaultDocument {
  const VaultDocument({
    required this.id,
    required this.name,
    required this.originalFileName,
    required this.folderId,
    this.documentType,
    required this.mimeType,
    required this.sizeBytes,
    required this.storagePath,
    required this.sha256,
    this.tags = const [],
    this.notes = '',
    this.favorite = false,
    this.pinned = false,
    this.ocrText,
    this.detectedFields = const {},
    this.expiryDate,
    this.aiSummary,
    this.blurDetected = false,
    required this.createdAt,
    required this.updatedAt,
    this.lastViewedAt,
    this.pageCount = 1,
  });

  final String id;
  final String name;
  final String originalFileName;

  /// Preset folder id ('identity'/'academic'/…/'other') or a custom folder's
  /// Firestore id.
  final String folderId;

  /// e.g. "Aadhaar Card", "Class 12 Marksheet" — from the folder's suggested
  /// types, OCR detection, or free text the student entered.
  final String? documentType;

  final String mimeType;
  final int sizeBytes;
  final String storagePath;

  /// SHA-256 of the *original* (unencrypted) bytes — used purely for
  /// duplicate-upload detection, never for security.
  final String sha256;

  final List<String> tags;
  final String notes;
  final bool favorite;
  final bool pinned;

  /// Raw OCR transcript from the Gemini vision pass, used for full-text
  /// search. Null for documents OCR hasn't run on yet (e.g. DOC/DOCX, or AI
  /// not configured).
  final String? ocrText;

  /// See [VaultFieldKeys] — best-effort, missing keys mean "not detected".
  final Map<String, String> detectedFields;

  final DateTime? expiryDate;
  final String? aiSummary;
  final bool blurDetected;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastViewedAt;

  /// Number of pages for a multi-page scan assembled into one PDF.
  final int pageCount;

  String get extension {
    final dot = name.lastIndexOf('.');
    return dot == -1 ? '' : name.substring(dot + 1).toLowerCase();
  }

  bool get isPdf => mimeType == 'application/pdf' || extension == 'pdf';
  bool get isImage => mimeType.startsWith('image/');
  bool get isDoc => extension == 'doc' || extension == 'docx';

  IconData get typeIcon {
    if (isPdf) return Icons.picture_as_pdf_rounded;
    if (isImage) return Icons.image_rounded;
    if (isDoc) return Icons.description_rounded;
    return Icons.insert_drive_file_rounded;
  }

  String get sizeLabel {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  bool get isExpired =>
      expiryDate != null && expiryDate!.isBefore(DateTime.now());

  bool get isExpiringSoon =>
      expiryDate != null &&
      !isExpired &&
      expiryDate!.difference(DateTime.now()).inDays <= 30;

  VaultDocument copyWith({
    String? name,
    String? folderId,
    String? documentType,
    List<String>? tags,
    String? notes,
    bool? favorite,
    bool? pinned,
    String? ocrText,
    Map<String, String>? detectedFields,
    DateTime? expiryDate,
    bool clearExpiryDate = false,
    String? aiSummary,
    bool? blurDetected,
    DateTime? updatedAt,
    DateTime? lastViewedAt,
  }) {
    return VaultDocument(
      id: id,
      name: name ?? this.name,
      originalFileName: originalFileName,
      folderId: folderId ?? this.folderId,
      documentType: documentType ?? this.documentType,
      mimeType: mimeType,
      sizeBytes: sizeBytes,
      storagePath: storagePath,
      sha256: sha256,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      favorite: favorite ?? this.favorite,
      pinned: pinned ?? this.pinned,
      ocrText: ocrText ?? this.ocrText,
      detectedFields: detectedFields ?? this.detectedFields,
      expiryDate: clearExpiryDate ? null : (expiryDate ?? this.expiryDate),
      aiSummary: aiSummary ?? this.aiSummary,
      blurDetected: blurDetected ?? this.blurDetected,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastViewedAt: lastViewedAt ?? this.lastViewedAt,
      pageCount: pageCount,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'originalFileName': originalFileName,
        'folderId': folderId,
        'documentType': documentType,
        'mimeType': mimeType,
        'sizeBytes': sizeBytes,
        'storagePath': storagePath,
        'sha256': sha256,
        'tags': tags,
        'notes': notes,
        'favorite': favorite,
        'pinned': pinned,
        'ocrText': ocrText,
        'detectedFields': detectedFields,
        'expiryDate':
            expiryDate == null ? null : Timestamp.fromDate(expiryDate!),
        'aiSummary': aiSummary,
        'blurDetected': blurDetected,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
        'lastViewedAt':
            lastViewedAt == null ? null : Timestamp.fromDate(lastViewedAt!),
        'pageCount': pageCount,
      };

  factory VaultDocument.fromMap(String id, Map<String, dynamic> map) {
    DateTime? ts(String key) => (map[key] as Timestamp?)?.toDate();
    return VaultDocument(
      id: id,
      name: map['name'] as String? ?? 'Untitled',
      originalFileName: map['originalFileName'] as String? ?? '',
      folderId: map['folderId'] as String? ?? 'other',
      documentType: map['documentType'] as String?,
      mimeType: map['mimeType'] as String? ?? 'application/octet-stream',
      sizeBytes: map['sizeBytes'] as int? ?? 0,
      storagePath: map['storagePath'] as String? ?? '',
      sha256: map['sha256'] as String? ?? '',
      tags: (map['tags'] as List?)?.cast<String>() ?? const [],
      notes: map['notes'] as String? ?? '',
      favorite: map['favorite'] as bool? ?? false,
      pinned: map['pinned'] as bool? ?? false,
      ocrText: map['ocrText'] as String?,
      detectedFields:
          (map['detectedFields'] as Map?)?.cast<String, String>() ?? const {},
      expiryDate: ts('expiryDate'),
      aiSummary: map['aiSummary'] as String?,
      blurDetected: map['blurDetected'] as bool? ?? false,
      createdAt: ts('createdAt') ?? DateTime.now(),
      updatedAt: ts('updatedAt') ?? DateTime.now(),
      lastViewedAt: ts('lastViewedAt'),
      pageCount: map['pageCount'] as int? ?? 1,
    );
  }
}
