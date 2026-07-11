import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/gradient_background.dart';
import '../providers/vault_providers.dart';
import '../widgets/vault_document_card.dart';
import 'vault_document_detail_screen.dart';

/// Expiry reminders — documents already expired or expiring within 30 days
/// (Passport, Driving Licence, Income/Caste Certificate, etc.).
class VaultExpiryScreen extends ConsumerWidget {
  const VaultExpiryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docs = ref.watch(vaultExpiringDocumentsProvider);
    final expired = docs.where((d) => d.isExpired).toList();
    final expiringSoon = docs.where((d) => !d.isExpired).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expiry Reminders'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: SafeArea(
          child: docs.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_rounded,
                            color: Colors.greenAccent, size: 48),
                        const SizedBox(height: 16),
                        const Text('Nothing expiring soon',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text(
                            'Set expiry dates on documents like Passport or '
                            'Driving Licence to get reminders here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.55),
                                fontSize: 12.5)),
                      ],
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  children: [
                    if (expired.isNotEmpty) ...[
                      const Text('Expired',
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 10),
                      ...expired.map((d) => VaultDocumentListTile(
                            document: d,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                  builder: (_) =>
                                      VaultDocumentDetailScreen(document: d)),
                            ),
                          )),
                      const SizedBox(height: 20),
                    ],
                    if (expiringSoon.isNotEmpty) ...[
                      const Text('Expiring Soon',
                          style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 10),
                      ...expiringSoon.map((d) => VaultDocumentListTile(
                            document: d,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                  builder: (_) =>
                                      VaultDocumentDetailScreen(document: d)),
                            ),
                          )),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
