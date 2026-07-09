import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/official_report.dart';

class PdfReportService {
  static final PdfReportService instance = PdfReportService._internal();
  factory PdfReportService() => instance;
  PdfReportService._internal();

  /// Génère le PDF d'un rapport officiel
  Future<Uint8List> generateOfficialReportPdf(OfficialReportTemplate template, Map<String, dynamic> data, {String? entityName, String? rapporteurName}) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          _buildHeader(template, entityName),
          pw.SizedBox(height: 20),
          _buildInfoTable(template, data, rapporteurName),
          pw.SizedBox(height: 30),
          ..._buildSections(template, data),
          pw.Spacer(),
          _buildFooter(template),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(OfficialReportTemplate template, String? entityName) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text('ÉGLISE NÉO-APOSTOLIQUE', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
        pw.Text('RDC OUEST', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
        pw.Divider(thickness: 2, color: PdfColors.blue900),
        pw.SizedBox(height: 10),
        pw.Text(template.titre.toUpperCase(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20, color: PdfColors.blue900)),
        pw.Text('Code : ${template.code}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
        if (entityName != null) ...[
          pw.SizedBox(height: 5),
          pw.Text('Entité : $entityName', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
        ],
      ],
    );
  }

  pw.Widget _buildInfoTable(OfficialReportTemplate template, Map<String, dynamic> data, String? rapporteurName) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300)),
      child: pw.Column(
        children: [
          _row('Date du rapport', DateTime.now().toString().split(' ')[0]),
          _row('Rapporteur', rapporteurName ?? 'Non précisé'),
          _row('Statut', 'OFFICIEL - EN ATTENTE DE VALIDATION'),
        ],
      ),
    );
  }

  List<pw.Widget> _buildSections(OfficialReportTemplate template, Map<String, dynamic> data) {
    final List<pw.Widget> widgets = [];

    for (var section in template.sections) {
      widgets.add(pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 10),
        child: pw.Text(section.titre, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.blue800, fontSize: 14)),
      ));

      for (var field in section.fields) {
        final value = data[field.id]?.toString() ?? '—';
        widgets.add(pw.Padding(
          padding: const pw.EdgeInsets.only(left: 10, bottom: 4),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(width: 150, child: pw.Text('${field.label} :', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Expanded(child: pw.Text(value)),
            ],
          ),
        ));
      }
      widgets.add(pw.Divider(color: PdfColors.grey100));
    }

    return widgets;
  }

  pw.Widget _buildFooter(OfficialReportTemplate template) {
    return pw.Column(
      children: [
        pw.Divider(),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              children: [
                pw.Text('Signature du Rapporteur', style: const pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 40),
                pw.Container(width: 100, decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(style: pw.BorderStyle.dashed)))),
              ],
            ),
            pw.Column(
              children: [
                pw.Text('Cachet et Signature Autorité', style: const pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 40),
                pw.Container(width: 100, decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(style: pw.BorderStyle.dashed)))),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Text('Généré par Ecclesiaste ERP - Solution de gestion ENA', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
      ],
    );
  }

  pw.Widget _row(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.SizedBox(width: 100, child: pw.Text(label, style: const pw.TextStyle(fontSize: 10))),
          pw.Text(': $value', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
        ],
      ),
    );
  }

  /// Affiche l'aperçu avant impression ou export
  Future<void> printReport(OfficialReportTemplate template, Map<String, dynamic> data, {String? entityName, String? rapporteurName}) async {
    final pdfBytes = await generateOfficialReportPdf(template, data, entityName: entityName, rapporteurName: rapporteurName);
    await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
  }
}
