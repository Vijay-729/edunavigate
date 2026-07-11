import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/gradient_background.dart';
import '../data/predictor_report_repository.dart';
import '../models/prediction_model.dart';
import '../models/student_stream.dart';
import '../providers/predictor_providers.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/predicted_college_card.dart';
import 'college_details_screen.dart';
import 'college_search_results_screen.dart';

/// Renders the Dream / Target / Safe tiers produced by [PredictionEngine]
/// (spec §"When user clicks Predict") plus save/share/download actions.
class CollegePredictorResultScreen extends ConsumerWidget {
  const CollegePredictorResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(predictionResultProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Predictions'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (result != null && !result.isEmpty) ...[
            IconButton(
              icon: const Icon(Icons.save_outlined),
              tooltip: 'Save prediction',
              onPressed: () => _saveReport(context, ref, result),
            ),
            IconButton(
              icon: const Icon(Icons.share_outlined),
              tooltip: 'Share prediction',
              onPressed: () => _shareOrDownload(context, result, share: true),
            ),
            IconButton(
              icon: const Icon(Icons.download_outlined),
              tooltip: 'Download prediction',
              onPressed: () => _shareOrDownload(context, result, share: false),
            ),
          ],
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: result == null
            ? const EmptyStateView(
                icon: Icons.auto_awesome_outlined,
                title: 'No prediction yet',
                message:
                    'Fill in the predictor form and tap Predict to see your results.',
              )
            : result.isEmpty
                ? EmptyStateView(
                    icon: Icons.search_off,
                    title: 'No exact match found',
                    message:
                        'Try a nearby state, a different exam, or widen your budget to see more colleges.',
                    suggestions: const ['Browse all colleges'],
                    onSuggestionTap: (_) => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => const CollegeSearchResultsScreen()),
                    ),
                  )
                : ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    children: [
                      _tierSection(
                          context,
                          'Dream Colleges',
                          '40–60% admission chance',
                          result.dreamColleges,
                          const Color(0xFFEF4444)),
                      _tierSection(
                          context,
                          'Target Colleges',
                          '60–85% admission chance',
                          result.targetColleges,
                          const Color(0xFFF59E0B)),
                      _tierSection(
                          context,
                          'Safe Colleges',
                          '85–99% admission chance',
                          result.safeColleges,
                          const Color(0xFF22C55E)),
                    ],
                  ),
      ),
    );
  }

  Widget _tierSection(
    BuildContext context,
    String title,
    String rangeLabel,
    List<PredictedCollege> colleges,
    Color color,
  ) {
    if (colleges.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800)),
              const SizedBox(width: 8),
              Text(rangeLabel,
                  style: TextStyle(
                      color: color, fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          ...colleges.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PredictedCollegeCard(
                  predicted: p,
                  onExplore: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (_) =>
                            CollegeDetailsScreen(collegeId: p.collegeId)),
                  ),
                  onApply: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (_) =>
                            CollegeDetailsScreen(collegeId: p.collegeId)),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Future<void> _saveReport(
      BuildContext context, WidgetRef ref, PredictionResult result) async {
    await ref.read(predictorReportRepositoryProvider).saveReport(result);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prediction saved to your reports.')),
      );
    }
  }

  Future<void> _shareOrDownload(BuildContext context, PredictionResult result,
      {required bool share}) async {
    final buffer = StringBuffer()
      ..writeln('EduNavigate AI — College Predictor Report')
      ..writeln(
          'Stream: ${result.input.stream.label} | Exam: ${result.input.examId} | Rank: ${result.input.examRank}')
      ..writeln();
    void section(String title, List<PredictedCollege> list) {
      if (list.isEmpty) return;
      buffer.writeln('$title:');
      for (final p in list) {
        buffer.writeln(
            '  • ${p.collegeName} (${p.courseName}) — ${p.probability.round()}% chance');
      }
      buffer.writeln();
    }

    section('Dream Colleges', result.dreamColleges);
    section('Target Colleges', result.targetColleges);
    section('Safe Colleges', result.safeColleges);

    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(share
                ? 'Report copied — paste it anywhere to share.'
                : 'Report copied to clipboard.')),
      );
    }
  }
}
