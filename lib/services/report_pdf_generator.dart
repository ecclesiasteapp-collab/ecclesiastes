import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/church_report.dart';

class ReportPdfGenerator {
  static Future<Uint8List> generate(ChurchReport report) async {
    final pdf = pw.Document();
    
    // Chargement du logo
    final ByteData logoData = await rootBundle.load('assets/images/logo_ena.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final pw.MemoryImage logoImage = pw.MemoryImage(logoBytes);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Stack(
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildHeader(report, logoImage),
                    pw.SizedBox(height: 20),
                    _buildTitreSection(report),
                    pw.SizedBox(height: 10),
                    _buildJourEtDate(report),
                    pw.SizedBox(height: 15),
                    _buildLiturgicSection(report),
                    pw.SizedBox(height: 20),
                    _buildStatsSection(report),
                    pw.SizedBox(height: 20),
                    _buildActesSection(report),
                    pw.SizedBox(height: 30),
                    _buildSignatureSection(report),
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
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(ChurchReport report, pw.MemoryImage logo) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 1),
      ),
      padding: const pw.EdgeInsets.all(8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Eglise Néo – Apostolique de la RDC – Ouest',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                ),
                pw.SizedBox(height: 8),
                _buildHeaderLine('CHAMP APOSTOLIQUE', report.nomChamp),
                _buildHeaderLine('DISTRICT', report.nomDistrict),
                _buildHeaderLine('COMMUNAUTÉ', report.nomEntite),
              ],
            ),
          ),
          pw.Container(
            width: 50,
            height: 50,
            child: pw.Image(logo),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildHeaderLine(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        children: [
          pw.SizedBox(width: 100, child: pw.Text('$label :', style: const pw.TextStyle(fontSize: 10))),
          pw.Expanded(
            child: pw.Container(
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: PdfColors.black, width: 0.5, style: pw.BorderStyle.dashed)),
              ),
              child: pw.Text(value, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTitreSection(ChurchReport report) {
    return pw.Container(
      width: double.infinity,
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.black, width: 2)),
      ),
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Text(
        _getReportTypeLabel(report.type).toUpperCase(),
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18),
      ),
    );
  }

  static pw.Widget _buildJourEtDate(ChurchReport report) {
    final df = DateFormat('dd/MM/yyyy');
    final tf = DateFormat('HH:mm');
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text('Jour : ${_getJourSemaine(report.dateRapport)}', style: const pw.TextStyle(fontSize: 11)),
        pw.Text('Date : Le ${df.format(report.dateRapport)}', style: const pw.TextStyle(fontSize: 11)),
        pw.Text('Début : ${tf.format(report.heureDebut)} / Fin : ${report.heureFin != null ? tf.format(report.heureFin!) : "___"}', style: const pw.TextStyle(fontSize: 11)),
      ],
    );
  }

  static pw.Widget _buildLiturgicSection(ChurchReport report) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildContentLine('Cantique d\'introduction', report.cantiqueIntroduction),
        _buildContentLine('Texte Biblique', report.texteBiblique),
        _buildContentLine('Officiant', report.officiant),
        if (report.assistants.isNotEmpty)
          _buildContentLine('Assistants', report.assistants.join(', ')),
      ],
    );
  }

  static pw.Widget _buildContentLine(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(width: 120, child: pw.Text('$label :', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11))),
          pw.Expanded(
            child: pw.Container(
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: PdfColors.black, width: 0.5, style: pw.BorderStyle.dashed)),
              ),
              child: pw.Text(value, style: const pw.TextStyle(fontSize: 11)),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildStatsSection(ChurchReport report) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('STATISTIQUES ET OFFRANDES', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Présence Totale: ${report.presenceTotale}', style: const pw.TextStyle(fontSize: 11)),
            pw.Text('Membres: ${report.nombreMembres}', style: const pw.TextStyle(fontSize: 11)),
            pw.Text('Visiteurs: ${report.nombreVisiteurs}', style: const pw.TextStyle(fontSize: 11)),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Offrandes FC: ${report.offrandeFC}', style: const pw.TextStyle(fontSize: 11)),
            pw.Text('Offrandes Devise: ${report.offrandeDevise}', style: const pw.TextStyle(fontSize: 11)),
            pw.Text('Reçu N°: ${report.numeroRecu}', style: const pw.TextStyle(fontSize: 11)),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildActesSection(ChurchReport report) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('ACTES SACRAMENTELS ET MINISTÉRIELS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _actItem('Baptême', report.nombreBaptemes),
            _actItem('Scellé', report.nombreScelles),
            _actItem('Confirmation', report.nombreConfirmations),
            _actItem('Ordination', report.nombreOrdinations),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _actItem('Mandatement', report.nombreMandatements),
            _actItem('Nomination', report.nombreNominations),
            _actItem('Retraite', report.nombreRetraites),
            pw.SizedBox(width: 80),
          ],
        ),
      ],
    );
  }

  static pw.Widget _actItem(String label, int count) {
    return pw.Row(
      children: [
        pw.Text('$label : ', style: const pw.TextStyle(fontSize: 10)),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5)),
          child: pw.Text('$count', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
        ),
      ],
    );
  }

  static pw.Widget _buildSignatureSection(ChurchReport report) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Approuvé par :', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.SizedBox(height: 40),
            pw.Text('_________________________', style: const pw.TextStyle(fontSize: 11)),
            pw.Text('Nom & Signature', style: const pw.TextStyle(fontSize: 9)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Le Rapporteur :', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.SizedBox(height: 40),
            pw.Text(report.rapporteur, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
            pw.Text('Nom & Signature', style: const pw.TextStyle(fontSize: 9)),
          ],
        ),
      ],
    );
  }

  static String _getReportTypeLabel(ReportTypeExt type) {
    switch (type) {
      case ReportTypeExt.serviceDivin: return 'Rapport de Service Divin';
      case ReportTypeExt.reunionFreres: return 'Réunion de Frères';
      case ReportTypeExt.serviceJeunesse: return 'Service de Jeunesse';
      case ReportTypeExt.seminaire: return 'Séminaire';
      case ReportTypeExt.serviceEcodim: return 'Service Ecodim';
      case ReportTypeExt.serviceFunebre: return 'Service Funèbre';
      case ReportTypeExt.mariage: return 'Mariage';
      case ReportTypeExt.concert: return 'Concert';
      default: return 'Rapport d\'activité';
    }
  }

  static String _getJourSemaine(DateTime date) {
    const jours = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
    return jours[date.weekday - 1];
  }
}
