import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Generous but bounded — a hung request must never leave a loading
/// spinner/typing indicator stuck forever with no way for the user to recover.
const _geminiTimeout = Duration(seconds: 45);

/// Thin wrapper over the Gemini SDK powering the AI Mentor and assessment
/// explanation. The provider is locked to Gemini (Google AI Studio).
///
/// BIND YOUR KEY at launch via a gitignored env.json ({"GEMINI_API_KEY": "..."}):
///   flutter run --dart-define-from-file=env.json
/// (never hard-code keys in source). When no key is present the app degrades
/// gracefully instead of crashing.
class GeminiService {
  GeminiService(this._apiKey);

  final String _apiKey;

  bool get isConfigured => _apiKey.isNotEmpty;

  GenerativeModel _model({String? systemInstruction}) => GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
        systemInstruction: systemInstruction == null
            ? null
            : Content.system(systemInstruction),
      );

  /// Single-shot text prompt — used for assessment insights and recommendations.
  Future<String> ask(String prompt, {String? systemInstruction}) async {
    if (!isConfigured) throw const GeminiNotConfigured();
    final res = await _model(systemInstruction: systemInstruction)
        .generateContent([Content.text(prompt)]).timeout(_geminiTimeout);
    return res.text?.trim() ?? '';
  }

  /// Vision prompt — sends an image + text to Gemini 2.0 Flash for analysis.
  /// Used for marksheet OCR and AI-powered analysis.
  Future<String> analyzeImage(
    Uint8List imageBytes,
    String prompt, {
    String mimeType = 'image/jpeg',
  }) async {
    if (!isConfigured) throw const GeminiNotConfigured();
    final res = await _model().generateContent([
      Content.multi([
        DataPart(mimeType, imageBytes),
        TextPart(prompt),
      ]),
    ]).timeout(_geminiTimeout);
    return res.text?.trim() ?? '';
  }

  /// Starts a multi-turn chat session seeded with a system instruction that
  /// describes the student so every reply is personalized.
  ChatSession startChat({required String systemInstruction}) {
    if (!isConfigured) throw const GeminiNotConfigured();
    return _model(systemInstruction: systemInstruction).startChat();
  }
}

class GeminiNotConfigured implements Exception {
  const GeminiNotConfigured();
  @override
  String toString() => 'AI Mentor is not configured. Launch with '
      '--dart-define-from-file=env.json to enable it.';
}

final geminiServiceProvider = Provider<GeminiService>(
  (ref) => GeminiService(
    const String.fromEnvironment('GEMINI_API_KEY', defaultValue: ''),
  ),
);
