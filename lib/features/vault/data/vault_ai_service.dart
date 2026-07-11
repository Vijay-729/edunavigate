import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;

import '../../ai/services/gemini_service.dart';

/// Lightweight AI helpers layered on top of OCR output: a plain-language
/// summary (reusing [GeminiService.ask]) and a pure-Dart blur heuristic (no
/// extra native dependency) used to flag scans worth retaking.
class VaultAiService {
  VaultAiService(this._gemini);

  final GeminiService _gemini;

  bool get isConfigured => _gemini.isConfigured;

  /// One or two sentences summarizing what a document is and its key facts,
  /// built from the OCR transcript rather than the image itself (cheaper,
  /// and works even for documents where only rawText was captured).
  Future<String?> summarize(String rawText) async {
    if (!isConfigured || rawText.trim().isEmpty) return null;
    final prompt =
        'Summarize this student document in 1-2 short sentences for a '
        'document locker app. Mention the document type and any key facts '
        '(name, year, marks) if present. Text:\n\n$rawText';
    final result = await _gemini.ask(prompt);
    return result.isEmpty ? null : result;
  }

  /// Suggests a clearer file name given a raw OCR transcript, when the OCR
  /// pass itself didn't already produce one.
  Future<String?> suggestFileName(String rawText,
      {String? documentType}) async {
    if (!isConfigured || rawText.trim().isEmpty) return null;
    final prompt =
        'Suggest a short, filesystem-safe file name (no extension, use '
        'underscores, no spaces) for a document of type '
        '"${documentType ?? 'unknown'}" with this text:\n\n$rawText';
    final result = await _gemini.ask(prompt);
    final cleaned = result.trim().replaceAll(RegExp(r'[^A-Za-z0-9_\-]'), '_');
    return cleaned.isEmpty ? null : cleaned;
  }

  /// Simple Laplacian-variance style blur heuristic: a sharp scan has a lot
  /// of high-frequency edge detail; a blurry one doesn't. No ML model or
  /// native dependency needed — just pixel math via the pure-Dart `image`
  /// package.
  bool detectBlur(Uint8List imageBytes, {double threshold = 90}) {
    final decoded = img.decodeImage(imageBytes);
    if (decoded == null) return false;
    final small = img.copyResize(decoded, width: 300);
    final gray = img.grayscale(small);

    double sum = 0;
    double sumSq = 0;
    var count = 0;
    for (var y = 1; y < gray.height - 1; y++) {
      for (var x = 1; x < gray.width - 1; x++) {
        final center = gray.getPixel(x, y).r;
        final left = gray.getPixel(x - 1, y).r;
        final right = gray.getPixel(x + 1, y).r;
        final up = gray.getPixel(x, y - 1).r;
        final down = gray.getPixel(x, y + 1).r;
        final laplacian = (4 * center - left - right - up - down).toDouble();
        sum += laplacian;
        sumSq += laplacian * laplacian;
        count++;
      }
    }
    if (count == 0) return false;
    final mean = sum / count;
    final variance = (sumSq / count) - (mean * mean);
    return variance < threshold;
  }
}

final vaultAiServiceProvider = Provider<VaultAiService>(
  (ref) => VaultAiService(ref.watch(geminiServiceProvider)),
);
