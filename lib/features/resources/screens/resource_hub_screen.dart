import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../colleges/providers/college_providers.dart';
import '../models/career_resource.dart';
import '../widgets/resource_card.dart';

/// Renders any [ResourceHub] — intro banner plus grouped, tappable resource
/// cards. Fully data-driven, so every career-readiness feature reuses it.
class ResourceHubScreen extends ConsumerWidget {
  const ResourceHubScreen({super.key, required this.hub});

  final ResourceHub hub;

  Future<void> _open(BuildContext context, ResourceItem item) async {
    final uri = Uri.tryParse(item.url);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeStream =
        hub.streamAware ? ref.watch(activeStreamProvider) : null;
    final visibleGroups = hub.streamAware && activeStream != null
        ? hub.groups
            .where((g) => g.streamKey == null || g.streamKey == activeStream)
            .toList()
        : hub.groups;

    return Scaffold(
      appBar: AppBar(
        title: Text(hub.title),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            _IntroBanner(hub: hub),
            const SizedBox(height: 22),
            for (final group in visibleGroups) ...[
              Text(
                group.heading,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              for (final item in group.items) ...[
                ResourceCard(
                  item: item,
                  accent: hub.accent,
                  onTap: () => _open(context, item),
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _IntroBanner extends StatelessWidget {
  const _IntroBanner({required this.hub});

  final ResourceHub hub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            hub.accent.withValues(alpha: 0.22),
            hub.accent.withValues(alpha: 0.06),
          ],
        ),
        border: Border.all(color: hub.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: hub.accent.withValues(alpha: 0.2),
              border: Border.all(color: hub.accent.withValues(alpha: 0.5)),
            ),
            child: Icon(hub.icon, color: hub.accent, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hub.subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  hub.intro,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13.5,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Convenience to push a hub screen from a dashboard card.
void openResourceHub(BuildContext context, ResourceHub hub) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => ResourceHubScreen(hub: hub)),
  );
}
