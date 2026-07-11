import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/generic_bookmark_repository.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/gradient_background.dart';
import '../providers/loan_providers.dart';
import '../widgets/loan_card.dart';
import 'loan_detail_screen.dart';

class SavedLoansScreen extends ConsumerWidget {
  const SavedLoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedLoansProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Loans'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: saved.isEmpty
            ? const EmptyStateView(
                icon: Icons.bookmark_border,
                title: 'No saved loans',
                message: 'Tap the bookmark icon on any lender to save it here.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: saved.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final l = saved[i];
                  return LoanCard(
                    loan: l,
                    isSaved: true,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => LoanDetailScreen(loanId: l.id)),
                    ),
                    onSave: () => ref
                        .read(loanBookmarkRepositoryProvider)
                        .toggle(l.id, true),
                  );
                },
              ),
      ),
    );
  }
}
