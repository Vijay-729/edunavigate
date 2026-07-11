import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/chat_message.dart';
import '../services/gemini_service.dart';

@immutable
class AiMentorState {
  final List<ChatMessage> messages;
  final bool sending;

  const AiMentorState({this.messages = const [], this.sending = false});

  AiMentorState copyWith({List<ChatMessage>? messages, bool? sending}) {
    return AiMentorState(
      messages: messages ?? this.messages,
      sending: sending ?? this.sending,
    );
  }
}

/// Drives the AI Mentor chat. A single [ChatSession] is created lazily on the
/// first message so multi-turn context is preserved for the conversation.
class AiMentorController extends StateNotifier<AiMentorState> {
  AiMentorController(this._gemini) : super(const AiMentorState());

  final GeminiService _gemini;
  ChatSession? _session;
  String _systemInstruction =
      'You are EduNavigate AI, a friendly, concise career and education mentor '
      'for Indian students. Give practical, encouraging, age-appropriate advice.';

  bool _seeded = false;

  /// Seeds the system instruction (student context) and a welcome message.
  /// Idempotent — safe to call every time the sheet opens.
  void configure(String systemInstruction, String welcome) {
    _systemInstruction = systemInstruction;
    if (_seeded) return;
    _seeded = true;
    state = state.copyWith(
      messages: [ChatMessage(text: welcome, fromUser: false)],
    );
  }

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.sending) return;

    state = state.copyWith(
      messages: [...state.messages, ChatMessage(text: trimmed, fromUser: true)],
      sending: true,
    );

    try {
      if (!_gemini.isConfigured) {
        _appendBot(
          'The AI Mentor needs a Gemini API key to chat. Once configured, '
          "I'll give you personalized guidance here. For now, explore your "
          'dashboard cards for curated recommendations.',
        );
        return;
      }

      _session ??= _gemini.startChat(systemInstruction: _systemInstruction);
      final res = await _session!
          .sendMessage(Content.text(trimmed))
          .timeout(const Duration(seconds: 45));
      final reply = res.text?.trim();
      _appendBot(
        (reply == null || reply.isEmpty)
            ? "I couldn't generate a response. Please try rephrasing."
            : reply,
      );
    } on TimeoutException {
      _appendBot(
        'The AI Mentor is taking too long to respond. Please try again.',
        isError: true,
      );
    } catch (e, st) {
      debugPrint('AI Mentor error: $e\n$st');
      _appendBot(
        kDebugMode
            ? 'Something went wrong reaching the AI Mentor:\n$e'
            : 'Something went wrong reaching the AI Mentor. Please try again.',
        isError: true,
      );
    } finally {
      if (mounted) state = state.copyWith(sending: false);
    }
  }

  void _appendBot(String text, {bool isError = false}) {
    if (!mounted) return;
    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage(text: text, fromUser: false, isError: isError),
      ],
    );
  }
}

final aiMentorControllerProvider =
    StateNotifierProvider.autoDispose<AiMentorController, AiMentorState>(
  (ref) => AiMentorController(ref.watch(geminiServiceProvider)),
);
