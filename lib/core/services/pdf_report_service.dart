import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// A titled section of a generated report — a heading plus either plain
/// body text or a bullet list.
class PdfSection {
  final String heading;
  final String? body;
  final List<String>? bullets;

  const PdfSection.text(this.heading, this.body) : bullets = null;

  const PdfSection.list(this.heading, this.bullets) : body = null;
}

/// Generates simple, clean PDF guides/reports shared across Counselling,
/// Exam Universe, Career Roadmap, and Education Loan — one place to keep the
/// document style consistent instead of four bespoke PDF builders.
class PdfReportService {
  PdfReportService._();

  static Future<File> generate({
    required String title,
    required String subtitle,
    required List<PdfSection> sections,
    required String fileName,
  }) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'EduNavigate AI',
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.blue700,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Divider(color: PdfColors.grey400),
          ],
        ),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ),
        build: (context) => [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            subtitle,
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 18),
          for (final section in sections) ...[
            pw.Text(
              section.heading,
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
            pw.SizedBox(height: 6),
            if (section.body != null)
              pw.Text(section.body!, style: const pw.TextStyle(fontSize: 11)),
            if (section.bullets != null)
              ...section.bullets!.map(
                (b) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 3),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('•  ', style: const pw.TextStyle(fontSize: 11)),
                      pw.Expanded(
                        child:
                            pw.Text(b, style: const pw.TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                ),
              ),
            pw.SizedBox(height: 14),
          ],
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName.pdf');
    await file.writeAsBytes(await doc.save());
    return file;
  }
}
