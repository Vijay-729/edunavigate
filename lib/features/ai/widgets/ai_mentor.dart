import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../profile/models/user_profile.dart';
import '../models/chat_message.dart';
import '../providers/ai_mentor_controller.dart';

/// Floating "AI Mentor" button shown on every dashboard. Opens a persistent
/// chat sheet seeded with the student's profile context.
class AiMentorFab extends StatelessWidget {
  const AiMentorFab({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.45),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        heroTag: 'ai-mentor-fab',
        elevation: 0,
        backgroundColor: Colors.transparent,
        onPressed: () => showAiMentorSheet(context, profile),
        icon: const Icon(Icons.auto_awesome, color: Colors.white),
        label: const Text(
          'AI Mentor',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// Opens the AI Mentor chat. Pass [contextHint] when launching from a
/// specific stream/career/exam page so the mentor is primed to discuss it
/// (e.g. "the Software Engineer career" or "the PCM stream").
Future<void> showAiMentorSheet(
  BuildContext context,
  UserProfile profile, {
  String? contextHint,
  String? initialQuestion,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AiMentorSheet(
      profile: profile,
      contextHint: contextHint,
      initialQuestion: initialQuestion,
    ),
  );
}

class _AiMentorSheet extends ConsumerStatefulWidget {
  const _AiMentorSheet({
    required this.profile,
    this.contextHint,
    this.initialQuestion,
  });

  final UserProfile profile;
  final String? contextHint;

  /// When set, auto-sent as the first user message once the mentor is
  /// configured — powers "quick prompt" chips (AI Exam Finder, AI
  /// Counselling Assistant, AI Career Comparison) without extra typing.
  final String? initialQuestion;

  @override
  ConsumerState<_AiMentorSheet> createState() => _AiMentorSheetState();
}

class _AiMentorSheetState extends ConsumerState<_AiMentorSheet> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    final p = widget.profile;

    // Build a rich, class-specific system instruction so the AI always
    // responds in context — never suggests college-level topics to school
    // students and never treats a Class 12 student as a beginner.
    final classNum = _extractClassNum(p.classOrYear);
    final isSchool = classNum >= 6 && classNum <= 12;
    final isClass10 = classNum == 10;
    final isClass11or12 = classNum == 11 || classNum == 12;
    final isClass12 = classNum == 12;

    final strengthsText = p.assessmentStrengths.isNotEmpty
        ? 'Assessment strengths: ${p.assessmentStrengths.join(', ')}. '
        : '';

    final streamContext =
        p.branch.isNotEmpty ? 'Stream / Branch: ${p.branch}. ' : '';

    final collegeGuidance = isClass12
        ? 'You MAY discuss college admissions, cut-offs, entrance exams '
            '(JEE/NEET/CUET), and college selection since the student is in '
            'Class 12. '
        : isClass11or12
            ? 'Focus on board preparation, stream subjects, and entrance exam '
                'strategy. Mention college options briefly only if asked. '
            : isClass10
                ? 'Focus on board exam prep, stream selection after Class 10, '
                    'and scholarship opportunities. Do NOT discuss college '
                    'admissions in depth. '
                : 'Focus on academic basics, study habits, olympiads, and '
                    'stream awareness. Keep advice age-appropriate for '
                    'Class $classNum. ';

    final systemInstruction =
        'You are EduNavigate AI, a warm, encouraging, and knowledgeable '
        'personal mentor for Indian school students. '
        'Always respond in a friendly, concise, and age-appropriate way. '
        'STUDENT PROFILE: '
        'Name: ${p.name}. '
        'Class: ${p.classOrYear}. '
        '$streamContext'
        'Board: ${p.educationLevel.isNotEmpty ? p.educationLevel : "CBSE"}. '
        'Career goal: ${p.careerGoal.isNotEmpty ? p.careerGoal : "not set"}. '
        'State: ${p.state}. '
        '$strengthsText'
        '$collegeGuidance'
        'You can help with: study planning, subject doubts, exam strategy, '
        'revision tips, time management, motivation, stress management, '
        'stream selection, career roadmaps, and scholarship guidance. '
        '${isSchool ? "NEVER suggest topics from college curriculum (DSA, DBMS, OS, Computer Networks) unless the student is clearly in college." : ""} '
        'Always remember the student\'s class and tailor every single response '
        'to their specific level, stream, and goals. '
        'If the student seems stressed or demotivated, be empathetic and '
        'encouraging first, then give practical advice. '
        'Keep replies concise — use bullet points for lists and avoid '
        'overly long paragraphs.';

    final hint = widget.contextHint;
    final contextualInstruction = hint == null
        ? systemInstruction
        : '$systemInstruction\n\nCURRENT CONTEXT: The student just opened '
            'details about $hint inside the app. Be ready to answer '
            'follow-up questions about it, but still answer anything else '
            'they ask.';

    final welcomeMsg = hint == null
        ? _buildWelcome(p.name.split(' ').first, classNum, p.branch,
            p.careerGoal, p.assessmentStrengths)
        : 'Hi ${p.name.split(' ').first}! 👋 I see you\'re exploring $hint. '
            'Ask me anything about it — eligibility, difficulty, '
            'alternatives, or how it fits your goals.';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(aiMentorControllerProvider.notifier).configure(
            contextualInstruction,
            welcomeMsg,
          );
      final question = widget.initialQuestion;
      if (question != null && question.trim().isNotEmpty) {
        ref.read(aiMentorControllerProvider.notifier).send(question);
      }
    });
  }

  static int _extractClassNum(String classOrYear) {
    final m = RegExp(r'(\d+)').firstMatch(classOrYear);
    return m != null ? (int.tryParse(m.group(1)!) ?? -1) : -1;
  }

  static String _buildWelcome(
    String firstName,
    int classNum,
    String branch,
    String goal,
    List<String> strengths,
  ) {
    final greet = 'Hi $firstName! 👋 I\'m your AI Mentor.';

    if (classNum == 10) {
      return '$greet\n\nYou\'re in Class 10 — a big year! I can help you with '
          'board exam strategy, stream selection for Class 11, scholarships, '
          'and anything else on your mind. What would you like to explore?';
    }
    if (classNum == 11) {
      final s = branch.isNotEmpty ? ' ($branch)' : '';
      return '$greet\n\nClass 11$s is where real focus begins. I\'m here to '
          'help you with subject doubts, exam strategy, revision planning, '
          'and career guidance. Ask me anything!';
    }
    if (classNum == 12) {
      final goalText =
          goal.isNotEmpty ? 'I see your goal is $goal — great choice!' : '';
      return '$greet\n\nClass 12 is your launchpad! $goalText\n\nI can guide '
          'you on board prep, entrance exams, college selection, and stress '
          'management. What\'s on your mind?';
    }
    final strengthText = strengths.isNotEmpty
        ? ' Your strengths in ${strengths.take(2).join(" & ")} look great!'
        : '';
    return '$greet$strengthText\n\nI\'m here to help you with studies, '
        'career ideas, motivation, and anything school-related. '
        'What would you like to talk about?';
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final text = _input.text;
    if (text.trim().isEmpty) return;
    _input.clear();
    ref.read(aiMentorControllerProvider.notifier).send(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiMentorControllerProvider);
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    final height = MediaQuery.of(context).size.height;

    // Keep the latest message visible as the list grows.
    ref.listen(aiMentorControllerProvider, (_, __) => _scrollToBottom());

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets),
      child: Container(
        height: height * 0.78,
        decoration: const BoxDecoration(
          gradient: AppColors.bgGradient,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 12, 6),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.accent),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'AI Mentor',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12, height: 1),
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.all(16),
                itemCount: state.messages.length + (state.sending ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.messages.length) {
                    return const _TypingBubble();
                  }
                  return _MessageBubble(message: state.messages[index]);
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _input,
                        style: const TextStyle(color: Colors.white),
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                        decoration: InputDecoration(
                          hintText: 'Ask your mentor…',
                          hintStyle:
                              const TextStyle(color: AppColors.textMuted),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.08),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: state.sending ? null : _send,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                        ),
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final fromUser = message.fromUser;
    return Align(
      alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.76,
        ),
        decoration: BoxDecoration(
          color: message.isError
              ? Colors.red.withValues(alpha: 0.25)
              : fromUser
                  ? AppColors.primary
                  : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(fromUser ? 18 : 4),
            bottomRight: Radius.circular(fromUser ? 4 : 18),
          ),
        ),
        child: Text(
          message.text,
          style:
              const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
        ),
      ),
    );
  }
}

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );
    _animations = _controllers
        .map(
          (c) => Tween<double>(begin: 0, end: -7).animate(
            CurvedAnimation(parent: c, curve: Curves.easeInOut),
          ),
        )
        .toList();

    for (var i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 160), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return AnimatedBuilder(
              animation: _animations[i],
              builder: (_, __) => Transform.translate(
                offset: Offset(0, _animations[i].value),
                child: Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.only(left: i == 0 ? 0 : 5),
                  decoration: const BoxDecoration(
                    color: Colors.white54,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
