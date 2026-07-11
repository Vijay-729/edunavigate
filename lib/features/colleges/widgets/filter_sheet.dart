import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../models/course_model.dart';
import '../services/college_query_service.dart';
import 'quick_filter_chip.dart';

/// Full filter bottom sheet — course, state/city, type, accreditation,
/// hostel/scholarship/fees/placement toggles. Works on a local draft and
/// only commits via [onApply] so cancelling doesn't mutate provider state.
Future<void> showCollegeFilterSheet(
  BuildContext context, {
  required CollegeFilter current,
  required List<String> availableStates,
  required List<CourseCategory> availableCategories,
  required ValueChanged<CollegeFilter> onApply,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _FilterSheetBody(
      initial: current,
      availableStates: availableStates,
      availableCategories: availableCategories,
      onApply: onApply,
    ),
  );
}

class _FilterSheetBody extends StatefulWidget {
  const _FilterSheetBody({
    required this.initial,
    required this.availableStates,
    required this.availableCategories,
    required this.onApply,
  });

  final CollegeFilter initial;
  final List<String> availableStates;
  final List<CourseCategory> availableCategories;
  final ValueChanged<CollegeFilter> onApply;

  @override
  State<_FilterSheetBody> createState() => _FilterSheetBodyState();
}

class _FilterSheetBodyState extends State<_FilterSheetBody> {
  late CollegeFilter _draft = widget.initial;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0D2040),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10)),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Filters',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w800)),
                        TextButton(
                          onPressed: () =>
                              setState(() => _draft = const CollegeFilter()),
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _label('Course'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.availableCategories
                          .map((cat) => QuickFilterChip(
                                label: cat.label,
                                icon: cat.icon,
                                selected: _draft.courseCategory == cat,
                                onTap: () => setState(() {
                                  _draft = _draft.courseCategory == cat
                                      ? _draft.copyWith(
                                          clearCourseCategory: true)
                                      : _draft.copyWith(courseCategory: cat);
                                }),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 18),
                    _label('State'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.availableStates
                          .map((state) => QuickFilterChip(
                                label: state,
                                selected: _draft.state == state,
                                onTap: () => setState(() {
                                  _draft = _draft.state == state
                                      ? _draft.copyWith(clearState: true)
                                      : _draft.copyWith(state: state);
                                }),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 18),
                    _label('College Type & Accreditation'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        QuickFilterChip(
                          label: 'Government',
                          selected: _draft.governmentOnly,
                          onTap: () => setState(() => _draft = _draft.copyWith(
                              governmentOnly: !_draft.governmentOnly)),
                        ),
                        QuickFilterChip(
                          label: 'Private',
                          selected: _draft.privateOnly,
                          onTap: () => setState(() => _draft = _draft.copyWith(
                              privateOnly: !_draft.privateOnly)),
                        ),
                        QuickFilterChip(
                          label: 'Autonomous',
                          selected: _draft.autonomousOnly,
                          onTap: () => setState(() => _draft = _draft.copyWith(
                              autonomousOnly: !_draft.autonomousOnly)),
                        ),
                        QuickFilterChip(
                          label: 'NAAC A++',
                          selected: _draft.naacAPlusPlusOnly,
                          onTap: () => setState(() => _draft = _draft.copyWith(
                              naacAPlusPlusOnly: !_draft.naacAPlusPlusOnly)),
                        ),
                        QuickFilterChip(
                          label: 'NBA',
                          selected: _draft.nbaOnly,
                          onTap: () => setState(() => _draft =
                              _draft.copyWith(nbaOnly: !_draft.nbaOnly)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _label('Facilities & Cost'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        QuickFilterChip(
                          label: 'Hostel',
                          selected: _draft.hostelOnly,
                          onTap: () => setState(() => _draft =
                              _draft.copyWith(hostelOnly: !_draft.hostelOnly)),
                        ),
                        QuickFilterChip(
                          label: 'Scholarship',
                          selected: _draft.scholarshipOnly,
                          onTap: () => setState(() => _draft = _draft.copyWith(
                              scholarshipOnly: !_draft.scholarshipOnly)),
                        ),
                        QuickFilterChip(
                          label: 'Low Fees',
                          selected: _draft.lowFeesOnly,
                          onTap: () => setState(() => _draft = _draft.copyWith(
                              lowFeesOnly: !_draft.lowFeesOnly)),
                        ),
                        QuickFilterChip(
                          label: 'High Placement',
                          selected: _draft.highPlacementOnly,
                          onTap: () => setState(() => _draft = _draft.copyWith(
                              highPlacementOnly: !_draft.highPlacementOnly)),
                        ),
                        QuickFilterChip(
                          label: 'AI Recommended',
                          selected: _draft.aiRecommendedOnly,
                          onTap: () => setState(() => _draft = _draft.copyWith(
                              aiRecommendedOnly: !_draft.aiRecommendedOnly)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: PrimaryButton(
                  label: 'Apply Filters',
                  onPressed: () {
                    widget.onApply(_draft);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
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
}
