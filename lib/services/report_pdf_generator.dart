import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'file_storage_service.dart';
import '../models/church_report.dart';

class ReportPdfGenerator {
  static Future<Uint8List> generate(ChurchReport report, Uint8List logoBytes) async {
    final pdf = pw.Document();
    
    final pw.MemoryImage logoImage = pw.MemoryImage(logoBytes);

    // On lit la signature depuis le fichier stocké
    pw.MemoryImage? reporterSignature;
    if (report.signaturePath != null) {
      final signatureBytes = await FileStorageService.readFile(report.signaturePath!);
      if (signatureBytes != null) {
        reporterSignature = pw.MemoryImage(signatureBytes);
      }
    }

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
                    _buildSignatureSection(report, reporterSignature),
                  ],
                ),
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
                      'Généré par Ecclésiastes v1.0 - ID: ${report.id}',
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

  static pw.Widget _buildSignatureSection(ChurchReport report, pw.MemoryImage? reporterSig) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Approuvé par :', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.SizedBox(height: 10),
            pw.Text(report.validateur ?? '_________________________', style: const pw.TextStyle(fontSize: 11)),
            pw.SizedBox(height: 5),
            pw.Text('Validation numérique', style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text('Le Rapporteur :', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.SizedBox(height: 5),
            if (reporterSig != null)
              pw.Container(height: 40, width: 80, child: pw.Image(reporterSig))
            else
              pw.SizedBox(height: 40),
            pw.Text(report.rapporteur, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
            pw.Text('Nom & Signature tactile', style: const pw.TextStyle(fontSize: 9)),
          ],
        ),
      ],
    );
  }

  static String _getReportTypeLabel(ReportTypeExt type) {
    switch (type) {
      case ReportTypeExt.serviceDivin: return 'Service Divin';
      case ReportTypeExt.visitePastorale: return 'Visite Pastorale';
      case ReportTypeExt.communionFraternelle: return 'Communion Fraternelle';
      case ReportTypeExt.ordinationInstallation: return 'Ordination / Installation';
      case ReportTypeExt.funerailles: return 'Funérailles';
      case ReportTypeExt.mariage: return 'Mariage';
      case ReportTypeExt.bapteme: return 'Baptême';
      case ReportTypeExt.sainteCene: return 'Sainte-Cène';
      case ReportTypeExt.sacristie: return 'Sacristie';
      case ReportTypeExt.ecodim: return 'ECODIM';
      case ReportTypeExt.econfi: return 'ECONFI';
      case ReportTypeExt.jeunesse: return 'Jeunesse';
      case ReportTypeExt.papas: return 'Papas';
      case ReportTypeExt.mamans: return 'Mamans';
      case ReportTypeExt.aines: return 'Aînés';
      case ReportTypeExt.musiqueTechnique: return 'Musique - Direction Technique';
      case ReportTypeExt.musiqueOrchestre: return 'Musique - Orchestre';
      case ReportTypeExt.presseMedias: return 'Presse / Médias';
      case ReportTypeExt.josephArimathee: return 'Joseph d\'Arimathée';
      case ReportTypeExt.securiteProtocole: return 'Sécurité / Protocole';
      case ReportTypeExt.medicale: return 'Médicale';
      case ReportTypeExt.construction: return 'Construction';
      case ReportTypeExt.consolidationCommunaute: return 'Consolidation Communauté';
      case ReportTypeExt.consolidationDistrict: return 'Consolidation District';
      case ReportTypeExt.consolidationChamp: return 'Consolidation Champ';
      case ReportTypeExt.consolidationTerritorial: return 'Consolidation Territorial';
      case ReportTypeExt.consolidationInternational: return 'Consolidation International';
      case ReportTypeExt.collecteFundraising: return 'Collecte / Fundraising';
      case ReportTypeExt.evenementSpecial: return 'Événement';
      case ReportTypeExt.mensuelActivite: return 'Mensuel d\'Activité';
      case ReportTypeExt.trimestrielActivite: return 'Trimestriel d\'Activité';
      case ReportTypeExt.annuelActivite: return 'Annuel d\'Activité';
      case ReportTypeExt.scellement: return 'Saint-Scellement';
      case ReportTypeExt.reunionCommission: return 'Réunion de Commission';
      case ReportTypeExt.seminaire: return 'Séminaire';
      case ReportTypeExt.repetition: return 'Répétition';
      case ReportTypeExt.formation: return 'Formation';
      case ReportTypeExt.activiteSociale: return 'Activité Sociale';
      case ReportTypeExt.inventaire: return 'Rapport d\'Inventaire';
      case ReportTypeExt.gestionDistrict: return 'Rapport de Gestion (District)';
      case ReportTypeExt.gestionCommunaute: return 'Rapport de Gestion (Cté)';
      case ReportTypeExt.autre: return 'Autre Rapport';
    }
  }

  static String _getJourSemaine(DateTime date) {
    const jours = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
    return jours[date.weekday - 1];
  }
}

