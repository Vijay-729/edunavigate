import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/filter_chip_pill.dart';
import '../../../core/widgets/primary_button.dart';
import '../models/scholarship_preferences.dart';

const _categoryOptions = ['General', 'SC', 'ST', 'OBC', 'EWS', 'Minority'];

/// Lets the student optionally fill in category / family income / academic
/// percentage / disability status — the few personalization inputs that
/// aren't already part of their profile — to sharpen "Recommended For You".
/// Purely local (see [ScholarshipPreferencesRepository]); skipping this never
/// blocks the Scholarship Explorer, unlike the Explore feature's location
/// sheet.
Future<void> showScholarshipPersonalizeSheet(
  BuildContext context, {
  required ScholarshipPreferences current,
  required ValueChanged<ScholarshipPreferences> onSave,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PersonalizeSheetBody(initial: current, onSave: onSave),
  );
}

class _PersonalizeSheetBody extends StatefulWidget {
  const _PersonalizeSheetBody({required this.initial, required this.onSave});

  final ScholarshipPreferences initial;
  final ValueChanged<ScholarshipPreferences> onSave;

  @override
  State<_PersonalizeSheetBody> createState() => _PersonalizeSheetBodyState();
}

class _PersonalizeSheetBodyState extends State<_PersonalizeSheetBody> {
  late ScholarshipPreferences _draft = widget.initial;
  late final _incomeController =
      TextEditingController(text: _draft.familyIncome?.toString() ?? '');
  late final _percentageController =
      TextEditingController(text: _draft.percentage?.toString() ?? '');

  @override
  void dispose() {
    _incomeController.dispose();
    _percentageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF0D2040),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const Text('Personalize Recommendations ⭐',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text(
                'Class, stream, state and gender already come from your '
                'profile. Add these to sharpen "Recommended For You".',
                style: TextStyle(
                    color: Colors.white54, fontSize: 12.5, height: 1.4),
              ),
              const SizedBox(height: 20),
              _label('Category'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categoryOptions.map((c) {
                  final selected = _draft.category == c;
                  return FilterChipPill(
                    label: c,
                    selected: selected,
                    onTap: () => setState(() {
                      _draft = selected
                          ? _draft.copyWith(clearCategory: true)
                          : _draft.copyWith(category: c);
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              _label('Annual Family Income (₹)'),
              TextField(
                controller: _incomeController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: _fieldDecoration('e.g. 250000'),
              ),
              const SizedBox(height: 18),
              _label('Last Qualifying Exam Percentage'),
              TextField(
                controller: _percentageController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: _fieldDecoration('e.g. 85'),
              ),
              const SizedBox(height: 18),
              FilterChipPill(
                label: 'I have a disability (40%+)',
                selected: _draft.disabled,
                onTap: () => setState(
                    () => _draft = _draft.copyWith(disabled: !_draft.disabled)),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Save',
                onPressed: () {
                  final income = int.tryParse(_incomeController.text.trim());
                  final percentage =
                      int.tryParse(_percentageController.text.trim());
                  final result = _draft.copyWith(
                    familyIncome: income,
                    clearFamilyIncome: income == null,
                    percentage: percentage,
                    clearPercentage: percentage == null,
                  );
                  widget.onSave(result);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          text,
          style: const TextStyle(
              color: AppColors.accent,
              fontSize: 13,
              fontWeight: FontWeight.w700),
        ),
      );

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.06),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      );
}
