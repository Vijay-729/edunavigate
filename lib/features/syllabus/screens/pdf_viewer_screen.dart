import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';

/// Shared in-app PDF viewer for both Notes (handwritten, chapter-wise) and
/// PYQs (subject-wise). Remembers the last page per [storageKey] so a
/// student can resume exactly where they left off.
class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({
    super.key,
    required this.title,
    required this.fileUrl,
    required this.storageKey,
  });

  final String title;
  final String fileUrl;
  final String storageKey;

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final _controller = PdfViewerController();
  bool _prefsLoaded = false;
  bool _failed = false;
  int _reloadTick = 0;
  int? _resumePage;

  String get _prefsKey => 'pdf_last_page_${widget.storageKey}';

  @override
  void initState() {
    super.initState();
    _restoreLastPage();
  }

  Future<void> _restoreLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    _resumePage = prefs.getInt(_prefsKey);
    if (mounted) setState(() => _prefsLoaded = true);
  }

  Future<void> _saveLastPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, page);
  }

  Future<void> _download() async {
    final uri = Uri.tryParse(widget.fileUrl);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _retry() {
    setState(() {
      _failed = false;
      _reloadTick++;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgTop,
      appBar: AppBar(
        backgroundColor: AppColors.bgTop,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            tooltip: 'Download',
            onPressed: _download,
          ),
        ],
      ),
      body: !_prefsLoaded
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : _failed
              ? _PdfFailedState(onRetry: _retry)
              : Stack(
                  children: [
                    SfPdfViewer.network(
                      widget.fileUrl,
                      key: ValueKey(_reloadTick),
                      controller: _controller,
                      enableDoubleTapZooming: true,
                      onDocumentLoaded: (details) {
                        final resume = _resumePage;
                        if (resume != null &&
                            resume > 1 &&
                            resume <= details.document.pages.count) {
                          _controller.jumpToPage(resume);
                        }
                      },
                      onDocumentLoadFailed: (details) {
                        setState(() => _failed = true);
                      },
                      onPageChanged: (details) {
                        _saveLastPage(details.newPageNumber);
                      },
                    ),
                  ],
                ),
    );
  }
}

class _PdfFailedState extends StatelessWidget {
  const _PdfFailedState({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.picture_as_pdf_outlined,
                color: Colors.white24, size: 56),
            const SizedBox(height: 16),
            const Text(
              'Could not open this PDF',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 20),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              ),
              onPressed: onRetry,
              child: const Text('Retry',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
