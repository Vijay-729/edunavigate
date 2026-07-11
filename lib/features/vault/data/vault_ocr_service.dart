import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ai/services/gemini_service.dart';
import '../models/vault_document.dart';
import '../models/vault_folder.dart';

/// Result of running [VaultOcrService.analyze] over one document.
class VaultOcrResult {
  const VaultOcrResult({
    this.rawText = '',
    this.documentType,
    this.suggestedFileName,
    this.fields = const {},
    this.expiryDate,
  });

  final String rawText;
  final String? documentType;
  final String? suggestedFileName;
  final Map<String, String> fields;
  final DateTime? expiryDate;
}

/// Reuses the existing [GeminiService.analyzeImage] (already wired for
/// marksheet OCR) to read a document's content and extract the structured
/// fields called for by the EduVault spec, instead of adding a new native
/// OCR/ML-Kit dependency. Gemini 2.5 Flash accepts inline PDF bytes the same
/// way it accepts images, so this works for both scans and PDFs.
class VaultOcrService {
  VaultOcrService(this._gemini);

  final GeminiService _gemini;

  bool get isConfigured => _gemini.isConfigured;

  String _prompt(String? folderHint) => '''
You are analyzing a student's document (an ID card, marksheet, certificate, admit card, or similar). Respond with ONLY raw JSON (no markdown fences, no commentary) matching exactly this shape:

{
  "documentType": "short label such as 'Aadhaar Card' or 'Class 12 Marksheet' or null",
  "suggestedFileName": "a filesystem-safe file name without extension, e.g. 12th_Marksheet_CBSE_2025",
  "rawText": "the full text transcript visible in the document",
  "expiryDate": "YYYY-MM-DD if this document has a visible expiry/validity date, else null",
  "fields": {
    "studentName": "or omit if not present",
    "board": "or omit if not present",
    "university": "or omit if not present",
    "passingYear": "or omit if not present",
    "marks": "or omit if not present",
    "cgpa": "or omit if not present",
    "rollNumber": "or omit if not present",
    "registrationNumber": "or omit if not present",
    "certificateNumber": "or omit if not present",
    "issueDate": "or omit if not present"
  }
}
${folderHint == null ? '' : 'This document was uploaded into the "$folderHint" folder, which may hint at its type.'}
Only include keys in "fields" that are actually visible in the document. Every value must be a string.
''';

  /// Returns `null` when the AI Mentor isn't configured (no Gemini key) —
  /// callers should treat that as "OCR unavailable", not an error, since the
  /// spec allows EduVault to work without AI features configured.
  Future<VaultOcrResult?> analyze(
    Uint8List bytes, {
    required String mimeType,
    String? folderHint,
  }) async {
    if (!isConfigured) return null;
    final text = await _gemini.analyzeImage(
      bytes,
      _prompt(folderHint),
      mimeType: mimeType,
    );
    return _parse(text);
  }

  VaultOcrResult _parse(String raw) {
    var text = raw.trim();
    if (text.startsWith('```')) {
      text = text.replaceFirst(RegExp(r'^```[a-zA-Z]*\n?'), '');
      final end = text.lastIndexOf('```');
      if (end != -1) text = text.substring(0, end);
      text = text.trim();
    }
    try {
      final json = jsonDecode(text) as Map<String, dynamic>;
      final fieldsRaw = json['fields'] as Map<String, dynamic>? ?? const {};
      final fields = <String, String>{
        for (final entry in fieldsRaw.entries)
          if (VaultFieldKeys.all.contains(entry.key) && entry.value != null)
            entry.key: entry.value.toString(),
      };
      DateTime? expiryDate;
      final expiryRaw = json['expiryDate'] as String?;
      if (expiryRaw != null && expiryRaw.toLowerCase() != 'null') {
        expiryDate = DateTime.tryParse(expiryRaw);
      }
      return VaultOcrResult(
        rawText: json['rawText'] as String? ?? raw,
        documentType: json['documentType'] as String?,
        suggestedFileName: json['suggestedFileName'] as String?,
        fields: fields,
        expiryDate: expiryDate,
      );
    } catch (_) {
      // Gemini didn't return clean JSON — still keep the raw transcript so
      // full-text search over `ocrText` continues to work.
      return VaultOcrResult(rawText: raw);
    }
  }

  /// Best-effort match against a folder's suggested document types (e.g.
  /// "Aadhaar Card") so a detected type lines up with the picker used
  /// elsewhere in the UI.
  String? matchKnownDocumentType(String? detected) {
    if (detected == null) return null;
    final lower = detected.toLowerCase();
    for (final known in VaultFolders.allSuggestedTypes) {
      if (known.toLowerCase() == lower ||
          lower.contains(known.toLowerCase()) ||
          known.toLowerCase().contains(lower)) {
        return known;
      }
    }
    return detected;
  }
}

final vaultOcrServiceProvider = Provider<VaultOcrService>(
  (ref) => VaultOcrService(ref.watch(geminiServiceProvider)),
);
