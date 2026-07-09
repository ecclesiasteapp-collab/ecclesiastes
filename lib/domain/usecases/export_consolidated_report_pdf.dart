import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../entities/erp_statistics.dart';

class ExportConsolidatedReportPdf {
  Future<void> execute({
    required String title,
    required String entityName,
    required ERPStatistics stats,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('RAPPORT CONSOLIDÉ - ÉGLISE NÉO-APOSTOLIQUE'),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Entité : $entityName'),
              pw.Text('Type : $title'),
              pw.Text('Date : ${DateTime.now().toString().split('.')[0]}'),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Text('STATISTIQUES GÉNÉRALES', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Bullet(text: 'Nombre total de membres : ${stats.totalMembers}'),
              pw.Bullet(text: 'Nombre total de ministres : ${stats.totalMinisters}'),
              pw.Bullet(text: 'Rapports en attente : ${stats.pendingReports}'),
              pw.Bullet(text: 'Tendance financière : ${stats.financialTrend}%'),
              pw.Spacer(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  children: [
                    pw.Text('Signé numériquement par le Responsable'),
                    pw.SizedBox(height: 5),
                    pw.Text('Sceau ERP ECCLESIASTE', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
