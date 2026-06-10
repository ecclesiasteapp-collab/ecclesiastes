import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/fundraising_report.dart';

class FundraisingPdfGenerator {
  static Future<Uint8List> generate(FundraisingReport report) async {
    final pdf = pw.Document();
    
    final ByteData logoData = await rootBundle.load('assets/images/logo_ena.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final pw.MemoryImage logoImage = pw.MemoryImage(logoBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // EN-TÊTE OFFICIEL
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('EGLISE NEO APOSTOLIQUE EN RDC OUEST', 
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                          pw.SizedBox(height: 10),
                          pw.Text('CHAMP D’APOTRE : ${report.champName}'),
                          pw.Text('DISTRICT : ${report.districtName}'),
                          pw.Text('COMMUNAUTE : ${report.entityName}'),
                        ],
                      ),
                      pw.Container(
                        width: 50,
                        height: 50,
                        child: pw.Image(logoImage),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Divider(thickness: 2),
                  pw.SizedBox(height: 10),
                  pw.Center(
                    child: pw.Text('RAPPORT DE COTISATION ET COLLECTE DE FONDS', 
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16, decoration: pw.TextDecoration.underline)),
                  ),
                  pw.SizedBox(height: 20),

                  // INFOS GÉNÉRALES
                  pw.Text('Motif de la collecte : ${report.motif}'),
                  pw.Text('Date : Le ${report.dateCollecte.day}/${report.dateCollecte.month}/${report.dateCollecte.year}'),
                  pw.Text('Organisé par : ${report.commissionOrganisatrice}'),
                  pw.SizedBox(height: 20),

                  // TABLEAU DES MONTANTS
                  pw.Text('I. DÉTAIL DES COLLECTES', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                  pw.SizedBox(height: 10),
                  pw.Table(
                    border: pw.TableBorder.all(),
                    children: [
                      _buildTableRow(['Désignation', 'FC (Francs)', 'Devise (USD/EUR)'], isHeader: true),
                      _buildTableRow(['1. Cotisations des membres', '${report.cotisationsFC}', '${report.cotisationsDevise}']),
                      _buildTableRow(['2. Collecte spéciale', '${report.collecteSpecialeFC}', '${report.collecteSpecialeDevise}']),
                      _buildTableRow(['3. Dons et offrandes diverses', '${report.donsDiversFC}', '${report.donsDiversDevise}']),
                      _buildTableRow(['4. Autres (préciser : ${report.precisionDestination})', '${report.autresFC}', '${report.autresDevise}']),
                      _buildTableRow(['TOTAL GÉNÉRAL', '${report.totalFC}', '${report.totalDevise}'], isHeader: true),
                    ],
                  ),
                  pw.SizedBox(height: 20),

                  // STATISTIQUES
                  pw.Text('II. STATISTIQUES', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                  pw.SizedBox(height: 8),
                  pw.Text('Nombre de contributeurs (membres) : ${report.nombreContributeurs}'),
                  pw.Text('Nombre de membres absents ayant cotisé : ${report.nombreAbsentsCotisants}'),
                  pw.SizedBox(height: 15),

                  // DESTINATION
                  pw.Text('III. DESTINATION DES FONDS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                  pw.SizedBox(height: 8),
                  pw.Text('Les fonds collectés sont destinés à : ${report.destinationFonds}'),
                  if (report.precisionDestination.isNotEmpty)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 10),
                      child: pw.Text('Précision : ${report.precisionDestination}'),
                    ),
                  pw.SizedBox(height: 15),

                  // OBSERVATIONS
                  pw.Text('IV. OBSERVATIONS DU RAPPORTEUR', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                  pw.SizedBox(height: 8),
                  pw.Text(report.observations.isEmpty ? 'Aucune observation.' : report.observations),
                  
                  pw.Spacer(),

                  // SIGNATURES
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Approuvé par :', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 40),
                          pw.Text('_________________________'),
                          pw.Text('Nom et signature', style: pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Le Rapporteur :', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 40),
                          pw.Text('_________________________'),
                          pw.Text(report.rapporteur, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              // LE FILIGRANE DE PROTECTION
              pw.Positioned(
                bottom: -10,
                right: 0,
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey400),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    'Généré par Ecclésiastes v1.0 - ID: ${DateTime.now().millisecondsSinceEpoch}',
                    style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return pw.TableRow(
      children: cells.map((cell) => pw.Padding(
        padding: const pw.EdgeInsets.all(6),
        child: pw.Text(
          cell, 
          style: pw.TextStyle(
            fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
            fontSize: 10,
          ),
          textAlign: isHeader ? pw.TextAlign.center : pw.TextAlign.left,
        ),
      )).toList(),
    );
  }
}
