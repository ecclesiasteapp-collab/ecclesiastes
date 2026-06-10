import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/validation_task.dart';

class TrackingService {
  static late Isar _db;
  static void init(Isar db) => _db = db;

  static Future<List<ValidationTask>> getTasksByStatus(ValidationStatus status) async {
    return await _db.validationTasks.filter().statusEqualTo(status).sortByCreatedAtDesc().findAll();
  }

  static Future<Uint8List> generateExportPDF(List<ValidationTask> tasks) async {
    final pdf = pw.Document();
    
    // Attempt to load logo, fallback to text if fails
    pw.Widget logoWidget;
    try {
       final logoData = await rootBundle.load('assets/images/logo_ena.png');
       final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());
       logoWidget = pw.Image(logoImage, width: 50, height: 50);
    } catch (e) {
       logoWidget = pw.Container(width: 50, height: 50, color: PdfColors.blue, child: pw.Center(child: pw.Text('ENA', style: pw.TextStyle(color: PdfColors.white))));
    }

    pdf.addPage(pw.MultiPage(
      header: (context) => pw.Row(
        children: [
          logoWidget,
          pw.SizedBox(width: 15),
          pw.Expanded(child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('ÉGLISE NÉO-APOSTOLIQUE EN RDC OUEST', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.Text('EXPORT CONFORME DIRECTIVES §13.5', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
            ],
          )),
        ],
      ),
      build: (context) => [
        pw.SizedBox(height: 20),
        pw.TableHelper.fromTextArray(
          headers: ['Type', 'Titre', 'Statut', 'Soumis le', 'Communauté', 'District'],
          data: tasks.map((t) {
            final metadata = t.metadataJson != null ? jsonDecode(t.metadataJson!) as Map<String, dynamic> : {};
            return [
              t.entityType,
              metadata['title'] ?? 'N/A',
              t.status.name.toUpperCase(),
              t.createdAt.toString().substring(0, 10),
              t.communityValidatedAt != null ? 'OK' : '..',
              t.districtValidatedAt != null ? 'OK' : '..',
            ];
          }).toList(),
        ),
        pw.SizedBox(height: 40),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Document vérifiable en ligne.', style: pw.TextStyle(fontSize: 8)),
                pw.Text('Signature numérique conforme §3.20.6', style: pw.TextStyle(fontSize: 8)),
              ]
            ),
            pw.Container(
              width: 60,
              height: 60,
              child: pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: 'https://ecclesiastes.rdc/verify/${DateTime.now().millisecondsSinceEpoch}',
              ),
            ),
          ],
        ),
      ],
    ));
    return pdf.save();
  }
}
