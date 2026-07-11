import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_fields.dart';
import '../../../core/widgets/gradient_background.dart';
import '../data/vault_upload_controller.dart';

/// Built-in document scanner: capture one or more pages with the camera,
/// apply Brightness/B&W/rotate filters, then assemble everything into a
/// single multi-page PDF and upload it.
///
/// Scoped-down from the full spec deliberately (per product decision): this
/// does camera capture + brightness/B&W/rotate + multi-page PDF assembly,
/// but does NOT do true native auto-crop/perspective correction — that would
/// require a dedicated ML/native scanner plugin beyond what's reusable here.
class VaultScannerScreen extends ConsumerStatefulWidget {
  const VaultScannerScreen(
      {super.key, required this.folderId, this.documentTypeHint});

  final String folderId;
  final String? documentTypeHint;

  @override
  ConsumerState<VaultScannerScreen> createState() => _VaultScannerScreenState();
}

class _ScanPage {
  _ScanPage(this.original);
  final Uint8List original;
  double brightness = 0;
  bool blackAndWhite = false;
  int rotationQuarterTurns = 0;
  Uint8List? processed;
}

class _FilterArgs {
  const _FilterArgs(this.bytes, this.brightness, this.blackAndWhite,
      this.rotationQuarterTurns);
  final Uint8List bytes;
  final double brightness;
  final bool blackAndWhite;
  final int rotationQuarterTurns;
}

Uint8List _applyScanFilters(_FilterArgs args) {
  var image = img.decodeImage(args.bytes);
  if (image == null) return args.bytes;
  if (args.rotationQuarterTurns != 0) {
    image = img.copyRotate(image, angle: 90 * args.rotationQuarterTurns);
  }
  if (args.blackAndWhite) {
    image = img.grayscale(image);
  }
  if (args.brightness != 0) {
    image = img.adjustColor(image, brightness: 1 + (args.brightness / 100));
  }
  return Uint8List.fromList(img.encodeJpg(image, quality: 85));
}

class _VaultScannerScreenState extends ConsumerState<VaultScannerScreen> {
  final List<_ScanPage> _pages = [];
  int _current = 0;
  bool _processing = false;
  bool _uploading = false;

  _ScanPage? get _currentPage => _pages.isEmpty ? null : _pages[_current];

  Future<void> _capturePage() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
      maxWidth: 1800,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    final page = _ScanPage(bytes);
    setState(() {
      _pages.add(page);
      _current = _pages.length - 1;
    });
    await _reprocessCurrent();
  }

  Future<void> _reprocessCurrent() async {
    final page = _currentPage;
    if (page == null) return;
    setState(() => _processing = true);
    final result = await compute(
      _applyScanFilters,
      _FilterArgs(page.original, page.brightness, page.blackAndWhite,
          page.rotationQuarterTurns),
    );
    if (!mounted) return;
    setState(() {
      page.processed = result;
      _processing = false;
    });
  }

  void _rotate() {
    final page = _currentPage;
    if (page == null) return;
    page.rotationQuarterTurns = (page.rotationQuarterTurns + 1) % 4;
    _reprocessCurrent();
  }

  void _toggleBlackAndWhite() {
    final page = _currentPage;
    if (page == null) return;
    setState(() => page.blackAndWhite = !page.blackAndWhite);
    _reprocessCurrent();
  }

  void _removeCurrentPage() {
    if (_pages.isEmpty) return;
    setState(() {
      _pages.removeAt(_current);
      if (_current >= _pages.length) _current = _pages.length - 1;
      if (_current < 0) _current = 0;
    });
  }

  Future<void> _finishAndUpload() async {
    if (_pages.isEmpty) return;
    setState(() => _uploading = true);
    try {
      final doc = pw.Document();
      for (final page in _pages) {
        final bytes = page.processed ?? page.original;
        final image = pw.MemoryImage(bytes);
        doc.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (context) =>
                pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
          ),
        );
      }
      final pdfBytes = await doc.save();
      final fileName =
          'Scanned_Document_${DateTime.now().millisecondsSinceEpoch}.pdf';
      if (!mounted) return;
      final result = await uploadToVaultWithFeedback(
        context,
        ref,
        bytes: pdfBytes,
        fileName: fileName,
        mimeType: 'application/pdf',
        folderId: widget.folderId,
        documentType: widget.documentTypeHint,
      );
      if (!mounted) return;
      if (result != null) {
        Navigator.of(context).pop();
      } else {
        setState(() => _uploading = false);
      }
    } catch (_) {
      if (mounted) {
        showAppSnack(context, 'Could not build the scanned PDF. Try again.');
        setState(() => _uploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _currentPage;
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages.isEmpty
            ? 'Scan Document'
            : 'Page ${_current + 1} of ${_pages.length}'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (page != null)
            IconButton(
              tooltip: 'Remove page',
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: _removeCurrentPage,
            ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        extendBehindAppBar: true,
        child: SafeArea(
          child: _pages.isEmpty ? _buildEmpty() : _buildEditor(page!),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, gradient: AppColors.primaryGradient),
              child: const Icon(Icons.document_scanner_rounded,
                  color: Colors.white, size: 44),
            ),
            const SizedBox(height: 24),
            const Text('Scan a document',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(
              'Capture one or more pages with your camera. You can adjust '
              'brightness, switch to black & white, and rotate before saving.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 13.5,
                  height: 1.4),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _capturePage,
              icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
              label: const Text('Capture First Page',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditor(_ScanPage page) {
    return Column(
      children: [
        if (_pages.length > 1)
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _pages.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final selected = i == _current;
                return GestureDetector(
                  onTap: () => setState(() => _current = i),
                  child: Container(
                    width: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: selected ? AppColors.accent : Colors.white24,
                          width: selected ? 2 : 1),
                      image: DecorationImage(
                        image: MemoryImage(
                            _pages[i].processed ?? _pages[i].original),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.memory(
                    page.processed ?? page.original,
                    fit: BoxFit.contain,
                    gaplessPlayback: true,
                  ),
                ),
                if (_processing)
                  Container(
                    color: Colors.black.withValues(alpha: 0.35),
                    child: const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary)),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
          child: Row(
            children: [
              const Icon(Icons.brightness_6_rounded,
                  color: Colors.white54, size: 18),
              Expanded(
                child: Slider(
                  value: page.brightness,
                  min: -60,
                  max: 60,
                  activeColor: AppColors.accent,
                  onChanged: (v) => setState(() => page.brightness = v),
                  onChangeEnd: (_) => _reprocessCurrent(),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _toggleBlackAndWhite,
                  icon: Icon(
                      page.blackAndWhite
                          ? Icons.filter_b_and_w_rounded
                          : Icons.color_lens_outlined,
                      color: Colors.white70,
                      size: 18),
                  label: Text(page.blackAndWhite ? 'Black & White' : 'Colour',
                      style: const TextStyle(color: Colors.white70)),
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _rotate,
                  icon: const Icon(Icons.rotate_right_rounded,
                      color: Colors.white70, size: 18),
                  label: const Text('Rotate',
                      style: TextStyle(color: Colors.white70)),
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24)),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _uploading ? null : _capturePage,
                  icon: const Icon(Icons.add_a_photo_outlined,
                      color: Colors.white70, size: 18),
                  label: const Text('Add Page',
                      style: TextStyle(color: Colors.white70)),
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _uploading ? null : _finishAndUpload,
                  icon: _uploading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.check_rounded, color: Colors.white),
                  label: Text(_uploading ? 'Saving…' : 'Done',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
