import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/territory_config.dart';

class PdfOfficialGenerator {
  static Future<pw.Document> generateReport(TerritoryConfig config, Map<String, dynamic> data, String title) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            _buildHeader(config, title),
            pw.SizedBox(height: 20),
            if (data.containsKey('table')) 
              _buildDataTable(data['table'])
            else
              _buildStandardContent(data),
            pw.Spacer(),
            _buildFooter(data),
          ];
        },
      ),
    );
    return pdf;
  }

  static pw.Widget _buildHeader(TerritoryConfig config, String title) {
    return pw.Column(
      children: [
        pw.Text(config.officialName.toUpperCase(), style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.Text(title, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, decoration: pw.TextDecoration.underline)),
      ],
    );
  }

  static pw.Widget _buildStandardContent(Map<String, dynamic> data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: data.entries.where((e) => e.key != 'signatures').map((e) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Text('${e.key}: ${e.value}', style: const pw.TextStyle(fontSize: 10)),
      )).toList(),
    );
  }

  static pw.Widget _buildDataTable(Map<String, dynamic> tableData) {
    final columns = List<String>.from(tableData['columns'] ?? []);
    final rows = List<List<String>>.from(tableData['rows'] ?? []);

    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
      cellStyle: const pw.TextStyle(fontSize: 8),
      headers: columns,
      data: rows,
    );
  }

  static pw.Widget _buildFooter(Map<String, dynamic> data) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(children: [pw.Text('Approuvé par:'), pw.SizedBox(height: 30), pw.Text('________________')]),
        pw.Column(children: [pw.Text('Le Rapporteur:'), pw.SizedBox(height: 30), pw.Text('________________')]),
      ],
    );
  }
}

