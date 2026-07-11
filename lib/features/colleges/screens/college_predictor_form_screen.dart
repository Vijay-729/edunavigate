import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_fields.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/primary_button.dart';
import '../../profile/providers/profile_providers.dart';
import '../data/college_repository.dart';
import '../data/exam_seed_data.dart';
import '../models/course_model.dart';
import '../models/prediction_model.dart';
import '../models/student_stream.dart';
import '../providers/college_providers.dart';
import '../providers/predictor_providers.dart';
import '../services/college_query_service.dart';
import '../widgets/stream_picker_view.dart';
import 'college_predictor_result_screen.dart';

/// College Predictor entry form (spec §Feature 2). Collects everything the
/// [PredictionEngine] needs, then hands off to
/// [CollegePredictorResultScreen] once "Predict" is tapped.
class CollegePredictorFormScreen extends ConsumerWidget {
  const CollegePredictorFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(activeStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('College Predictor'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: stream == null
            ? SingleChildScrollView(
                child: StreamPickerView(
                  onPicked: (s) =>
                      ref.read(streamOverrideProvider.notifier).state = s,
                ),
              )
            : _PredictorForm(stream: stream),
      ),
    );
  }
}

class _PredictorForm extends ConsumerStatefulWidget {
  const _PredictorForm({required this.stream});

  final StudentStream stream;

  @override
  ConsumerState<_PredictorForm> createState() => _PredictorFormState();
}

class _PredictorFormState extends ConsumerState<_PredictorForm> {
  final _rankController = TextEditingController();
  final _scoreController = TextEditingController();
  final _percentageController = TextEditingController();
  final _incomeController = TextEditingController();
  final _budgetController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final profile = ref.read(currentProfileProvider).asData?.value;
      ref
          .read(predictorFormProvider.notifier)
          .initializeOnce(widget.stream, homeState: profile?.state);
    });
  }

  @override
  void dispose() {
    _rankController.dispose();
    _scoreController.dispose();
    _percentageController.dispose();
    _incomeController.dispose();
    _budgetController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _patch(PredictionInput Function(PredictionInput) transform) {
    ref.read(predictorFormProvider.notifier).update(transform);
  }

  @override
  Widget build(BuildContext context) {
    final input = ref.watch(predictorFormProvider);
    final allColleges =
        ref.watch(collegeRepositoryProvider).getByStream(widget.stream);
    final states = <String>{
      ...CollegeQueryService.distinctStates(allColleges),
      if (input.homeState != null) input.homeState!,
      if (input.preferredState != null) input.preferredState!,
    }.toList()
      ..sort();
    final relevantExams =
        widget.stream.relevantExamIds.map(ExamSeedData.byId).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.stream.label} Stream',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('Fill in your details for an AI-powered admission estimate.',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55), fontSize: 13)),
          const SizedBox(height: 22),
          _label('Entrance Exam'),
          _Dropdown<String>(
            value: input.examId,
            items: relevantExams.map((e) => e.id).toList(),
            labelBuilder: (id) => ExamSeedData.byId(id).shortName,
            icon: Icons.assignment_outlined,
            onChanged: (v) => _patch((i) => i.copyWith(examId: v)),
          ),
          const SizedBox(height: 16),
          _label('Exam Rank'),
          AppTextField(
            hint: 'e.g. 28000',
            icon: Icons.tag,
            controller: _rankController,
            keyboardType: TextInputType.number,
            onChanged: (v) =>
                _patch((i) => i.copyWith(examRank: int.tryParse(v))),
          ),
          const SizedBox(height: 16),
          _label('Exam Score (optional — for score-based exams)'),
          AppTextField(
            hint: 'e.g. 650',
            icon: Icons.grade_outlined,
            controller: _scoreController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (v) =>
                _patch((i) => i.copyWith(examScore: double.tryParse(v))),
          ),
          const SizedBox(height: 16),
          _label('Class 12 Percentage'),
          AppTextField(
            hint: 'e.g. 88',
            icon: Icons.percent,
            controller: _percentageController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (v) => _patch(
                (i) => i.copyWith(class12Percentage: double.tryParse(v))),
          ),
          const SizedBox(height: 16),
          _label('Preferred Course'),
          _Dropdown<CourseCategory>(
            value: input.preferredCourseCategory,
            items: widget.stream.eligibleCategories,
            labelBuilder: (c) => c.label,
            icon: Icons.menu_book_outlined,
            hint: 'Any course',
            onChanged: (v) =>
                _patch((i) => i.copyWith(preferredCourseCategory: v)),
          ),
          const SizedBox(height: 16),
          _label('Category'),
          _Dropdown<ReservationCategory>(
            value: input.category,
            items: ReservationCategory.values,
            labelBuilder: (c) => c.label,
            icon: Icons.groups_outlined,
            onChanged: (v) => _patch((i) => i.copyWith(category: v)),
          ),
          const SizedBox(height: 16),
          _label('Gender'),
          _Dropdown<String>(
            value: input.gender,
            items: const ['Any', 'Male', 'Female', 'Other'],
            labelBuilder: (g) => g,
            icon: Icons.wc_outlined,
            onChanged: (v) => _patch((i) => i.copyWith(gender: v)),
          ),
          const SizedBox(height: 16),
          _label('Home State (for quota)'),
          _Dropdown<String>(
            value: input.homeState,
            items: states,
            labelBuilder: (s) => s,
            icon: Icons.home_outlined,
            hint: 'Select your home state',
            onChanged: (v) => _patch((i) => i.copyWith(homeState: v)),
          ),
          const SizedBox(height: 16),
          _label('Preferred State'),
          _Dropdown<String>(
            value: input.preferredState,
            items: states,
            labelBuilder: (s) => s,
            icon: Icons.map_outlined,
            hint: 'Any state',
            onChanged: (v) => _patch((i) => i.copyWith(preferredState: v)),
          ),
          const SizedBox(height: 16),
          _label('Preferred City'),
          AppTextField(
            hint: 'e.g. Pune',
            icon: Icons.location_city_outlined,
            controller: _cityController,
            onChanged: (v) => _patch((i) => i.copyWith(preferredCity: v)),
          ),
          const SizedBox(height: 16),
          _label('Annual Family Income (₹)'),
          AppTextField(
            hint: 'e.g. 600000',
            icon: Icons.account_balance_wallet_outlined,
            controller: _incomeController,
            keyboardType: TextInputType.number,
            onChanged: (v) =>
                _patch((i) => i.copyWith(annualFamilyIncome: int.tryParse(v))),
          ),
          const SizedBox(height: 16),
          _label('Budget per Year (₹)'),
          AppTextField(
            hint: 'e.g. 200000',
            icon: Icons.currency_rupee,
            controller: _budgetController,
            keyboardType: TextInputType.number,
            onChanged: (v) =>
                _patch((i) => i.copyWith(budgetPerYear: int.tryParse(v))),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(20),
            ),
            child: SwitchListTile(
              value: input.hostelRequired,
              onChanged: (v) => _patch((i) => i.copyWith(hostelRequired: v)),
              activeThumbColor: AppColors.primary,
              contentPadding: EdgeInsets.zero,
              title: const Text('Hostel Required',
                  style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            label: 'Predict',
            icon: Icons.auto_awesome,
            onPressed: input.isReadyToPredict
                ? () {
                    ref.read(predictionResultProvider.notifier).predict(input);
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => const CollegePredictorResultScreen()),
                    );
                  }
                : () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Please select an exam and enter your rank.')),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: const TextStyle(
                color: AppColors.accent,
                fontSize: 12.5,
                fontWeight: FontWeight.w700)),
      );
}

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.icon,
    required this.onChanged,
    this.hint = 'Select',
  });

  final T? value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final IconData icon;
  final String hint;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    // Guards against DropdownButtonFormField's "exactly one matching item"
    // assertion when [value] (e.g. a profile field) isn't in [items].
    final safeValue = items.contains(value) ? value : null;
    return DropdownButtonFormField<T>(
      initialValue: safeValue,
      isExpanded: true,
      dropdownColor: AppColors.dropdownSurface,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.08),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
      ),
      items: items
          .map((e) => DropdownMenuItem<T>(
              value: e,
              child: Text(labelBuilder(e), overflow: TextOverflow.ellipsis)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
