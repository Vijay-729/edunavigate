import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/gradient_background.dart';
import '../providers/vault_providers.dart';
import '../widgets/vault_document_card.dart';
import 'vault_document_detail_screen.dart';

/// Search across name, document type, folder, OCR text, detected fields and
/// tags — spec: "Search by File Name, Document Type, Year, Board, University,
/// Keywords, OCR Text."
class VaultSearchScreen extends ConsumerStatefulWidget {
  const VaultSearchScreen({super.key});

  @override
  ConsumerState<VaultSearchScreen> createState() => _VaultSearchScreenState();
}

class _VaultSearchScreenState extends ConsumerState<VaultSearchScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = ref.read(vaultSearchQueryProvider);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(vaultSearchQueryProvider);
    final results = ref.watch(vaultSearchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search name, type, board, year, tags…',
            hintStyle: TextStyle(color: Colors.white38),
            border: InputBorder.none,
          ),
          onChanged: (v) =>
              ref.read(vaultSearchQueryProvider.notifier).state = v,
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                _controller.clear();
                ref.read(vaultSearchQueryProvider.notifier).state = '';
              },
            ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: SafeArea(
          child: query.trim().isEmpty
              ? const _SearchHint()
              : results.isEmpty
                  ? const _NoResults()
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                      itemCount: results.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 160,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.86,
                      ),
                      itemBuilder: (context, i) {
                        final doc = results[i];
                        return VaultDocumentCard(
                          document: doc,
                          width: double.infinity,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (_) =>
                                    VaultDocumentDetailScreen(document: doc)),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}

class _SearchHint extends StatelessWidget {
  const _SearchHint();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_rounded, color: Colors.white24, size: 48),
            const SizedBox(height: 16),
            Text(
              'Search by file name, document type, board, university, year, or tags.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55), fontSize: 13.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded,
                color: Colors.white24, size: 48),
            const SizedBox(height: 16),
            const Text('No matching documents',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('Try a different name, type, or tag.',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 12.5)),
          ],
        ),
      ),
    );
  }
}
