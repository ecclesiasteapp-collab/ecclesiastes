import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/territory_config.dart';

class PdfOfficialGenerator {
  static Future<pw.Document> generateServiceDivin({
    required TerritoryConfig config,
    required Map<String, dynamic> data,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('RAPPORT DE SERVICE DIVIN', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
                  pw.Text(data['date'] ?? ''),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              children: [
                pw.Expanded(child: _buildInfoColumn('Champ', data['champ'])),
                pw.Expanded(child: _buildInfoColumn('District', data['district'])),
                pw.Expanded(child: _buildInfoColumn('Communauté', data['communaute'])),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Row(
              children: [
                pw.Expanded(child: _buildInfoColumn('Jour', data['jour'])),
                pw.Expanded(child: _buildInfoColumn('Type', data['type'])),
                pw.Expanded(child: _buildInfoColumn('Heures', '${data['heureDebut']} - ${data['heureFin']}')),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('CONTENU LITURGIQUE', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            _buildInfoRow('Cantique d\'intro', data['cantique']),
            _buildInfoRow('Texte Biblique', data['texteBiblique']),
            _buildInfoRow('Officiant', data['officiant']),
            _buildInfoRow('Assistants', '${data['assistant1']}, ${data['assistant2']}, ${data['assistant3']}, ${data['assistant4']}'),
            pw.SizedBox(height: 20),
            pw.Text('STATISTIQUES', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Row(
              children: [
                pw.Expanded(child: _buildInfoColumn('Présences', data['presencesTotales'].toString())),
                pw.Expanded(child: _buildInfoColumn('Membres', data['membres'].toString())),
                pw.Expanded(child: _buildInfoColumn('Visiteurs', data['visiteurs'].toString())),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              children: [
                pw.Expanded(child: _buildInfoColumn('Offrandes FC', '${data['offrandesFC']} FC')),
                pw.Expanded(child: _buildInfoColumn('Offrandes \$', '${data['offrandesDevise']} \$')),
                pw.Expanded(child: _buildInfoColumn('Reçu N°', data['numeroRecu'])),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('ACTES SACREMENTELS ET NOMINATIONS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Bullet(text: 'Baptêmes: ${data['bapteme']} | Scellés: ${data['scelle']} | Confirmations: ${data['confirmation']}'),
            pw.Bullet(text: 'Ordinations: ${data['ordination']} | Prêtres: ${data['pretre']} | Diacres: ${data['diacre']}'),
            pw.Bullet(text: 'Mandatements: ${data['mandatement']} | RD: ${data['rd']} | RC: ${data['rc']}'),
            if (data['nomination']?.isNotEmpty == true) pw.Text('Nominations: ${data['nomination']}'),
            if (data['retraite']?.isNotEmpty == true) pw.Text('Retraites: ${data['retraite']}'),
          ];
        },
      ),
    );

    return pdf;
  }

  static pw.Widget _buildInfoColumn(String label, String? value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
        pw.Text(value ?? '-', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  static pw.Widget _buildInfoRow(String label, String? value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.SizedBox(width: 100, child: pw.Text('$label :', style: const pw.TextStyle(fontSize: 10))),
          pw.Text(value ?? '-', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

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

