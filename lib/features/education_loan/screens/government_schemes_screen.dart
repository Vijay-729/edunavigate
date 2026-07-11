import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../models/government_scheme_model.dart';
import '../providers/loan_providers.dart';

/// Lists PM Vidyalaxmi, Vidya Lakshmi, Central Sector Scholarships, State
/// Scholarships, and the Interest Subsidy scheme.
class GovernmentSchemesScreen extends ConsumerWidget {
  const GovernmentSchemesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schemes = ref.watch(allGovtSchemesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Government Schemes'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: schemes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) => _SchemeCard(scheme: schemes[index]),
        ),
      ),
    );
  }
}

class _SchemeCard extends StatelessWidget {
  const _SchemeCard({required this.scheme});

  final GovtSchemeModel scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF102846),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_outlined,
                  color: AppColors.accent),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(scheme.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700))),
            ],
          ),
          const SizedBox(height: 10),
          Text(scheme.about,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 13, height: 1.45)),
          const SizedBox(height: 12),
          const Text('Benefits',
              style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          ...scheme.benefits.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.circle, size: 5, color: AppColors.accent),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(b,
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12.5,
                                height: 1.4))),
                  ],
                ),
              )),
          const SizedBox(height: 8),
          Text('Eligibility: ${scheme.eligibility}',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 12,
                  height: 1.4)),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              final uri = Uri.tryParse(scheme.applyUrl);
              if (uri != null) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            icon: const Icon(Icons.open_in_new, size: 16),
            label: const Text('Learn More / Apply'),
          ),
        ],
      ),
    );
  }
}
