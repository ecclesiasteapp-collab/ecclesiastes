// =====================================================
// MODÈLES DE RAPPORTS - ÉGLISE NÉO-APOSTOLIQUE RDC OUEST
// Avec logo officiel - RESTAURÉ ET CORRIGÉ
// =====================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../services/auth_service.dart';
import '../../services/database_helper.dart';

// --- Widget de base pour la réutilisation du style ---
abstract class OfficialReportBase extends StatelessWidget {
  const OfficialReportBase({super.key});

  Future<Map<String, String>> _getHierarchyNames(String entiteId) async {
    final chain = await DatabaseHelper.instance.getChaineAncestres(entiteId);
    final Map<String, String> names = {
      'territoriale': 'RDC OUEST',
      'champ': '...',
      'district': '...',
      'communaute': '...',
    };

    for (var entite in chain) {
      final type = entite['type'];
      final nom = entite['nom'] ?? '...';
      if (type == 'EGLISE_TERRITORIALE') names['territoriale'] = nom;
      if (type == 'CHAMP_APOSTOLIQUE') names['champ'] = nom;
      if (type == 'DISTRICT') names['district'] = nom;
      if (type == 'COMMUNAUTE') names['communaute'] = nom;
    }
    return names;
  }

  Widget buildHeader(BuildContext context, Map<String, dynamic> data) {
    final entiteId = data['entiteId'] ?? AuthService.currentEntiteId;

    return FutureBuilder<Map<String, String>>(
      future: _getHierarchyNames(entiteId),
      builder: (context, snapshot) {
        final hierarchy = snapshot.data ?? {
          'territoriale': data['territoriale'] ?? 'RDC OUEST',
          'champ': data['champ'] ?? '...',
          'district': data['district'] ?? '...',
          'communaute': data['communaute'] ?? '...',
        };

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF003366), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 70, height: 70,
                      decoration: const BoxDecoration(color: Color(0xFF003366), shape: BoxShape.circle),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/logos/Logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(Icons.church, size: 40, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ÉGLISE NÉO-APOSTOLIQUE\n${hierarchy['territoriale']!.toUpperCase()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoLine('CHAMP APOSTOLIQUE:', hierarchy['champ']!),
              _buildInfoLine('DISTRICT:', hierarchy['district']!),
              _buildInfoLine('COMMUNAUTÉ:', hierarchy['communaute']!),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 11))),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      color: const Color(0xFF003366),
      child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 160, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 2),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
              child: Text(value, style: const TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSignatureRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSigCol('Approuvé par'),
        _buildSigCol('Le Rapporteur'),
      ],
    );
  }

  Widget _buildSigCol(String label) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 50),
        Container(width: 160, height: 1, color: Colors.black),
        const Text('Nom et Signature', style: TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Future<void> _printReport(BuildContext context, String title, Map<String, dynamic> data, {PdfPageFormat format = PdfPageFormat.a4}) async {
    final pdf = pw.Document();
    final hierarchy = await _getHierarchyNames(data['entiteId'] ?? AuthService.currentEntiteId);
    
    pw.MemoryImage? logoImage;
    try {
      final logoBytes = await rootBundle.load('assets/logos/Logo.png');
      logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    } catch (e) {
      debugPrint('Erreur chargement logo PDF: $e');
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(30),
        build: (pw.Context context) {
          return [
            // --- EN-TETE ---
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black, width: 1.5)),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('EGLISE NEO-APOSTOLIQUE', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: format == PdfPageFormat.a5 ? 11 : 14)),
                        pw.Text(hierarchy['territoriale']!.toUpperCase(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: format == PdfPageFormat.a5 ? 10 : 12)),
                        pw.SizedBox(height: 10),
                        _pdfInfoLine('CHAMP APOSTOLIQUE:', hierarchy['champ']!, isA5: format == PdfPageFormat.a5),
                        _pdfInfoLine('DISTRICT:', hierarchy['district']!, isA5: format == PdfPageFormat.a5),
                        _pdfInfoLine('COMMUNAUTE:', hierarchy['communaute']!, isA5: format == PdfPageFormat.a5),
                      ],
                    ),
                  ),
                  if (logoImage != null) pw.Container(width: format == PdfPageFormat.a5 ? 40 : 60, height: format == PdfPageFormat.a5 ? 40 : 60, child: pw.Image(logoImage)),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            // --- TITRE ---
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(vertical: 8),
              decoration: const pw.BoxDecoration(border: pw.Border.symmetric(horizontal: pw.BorderSide(color: PdfColors.black, width: 1))),
              child: pw.Text(title.toUpperCase(), textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: format == PdfPageFormat.a5 ? 14 : 18)),
            ),
            pw.SizedBox(height: 20),
            // --- TABLEAU ---
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
              columnWidths: { 0: pw.FixedColumnWidth(format == PdfPageFormat.a5 ? 100 : 150), 1: const pw.FlexColumnWidth() },
              children: data.entries.where((e) => !['entiteId', 'territoriale', 'champ', 'district', 'communaute', 'official_title'].contains(e.key)).map((e) {
                  final label = e.key.replaceAll('field_', '').replaceAll('_', ' ').toUpperCase();
                  return pw.TableRow(children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: format == PdfPageFormat.a5 ? 8 : 10))),
                      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(e.value?.toString() ?? '', style: pw.TextStyle(fontSize: format == PdfPageFormat.a5 ? 8 : 10))),
                  ]);
                }).toList(),
            ),
            pw.SizedBox(height: 40),
            // --- SIGNATURES ---
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _pdfSignatureBox('Approuvé par', isA5: format == PdfPageFormat.a5),
                _pdfSignatureBox('Le Rapporteur', isA5: format == PdfPageFormat.a5),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  pw.Widget _pdfInfoLine(String label, String value, {bool isA5 = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.SizedBox(width: isA5 ? 90 : 120, child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: isA5 ? 7 : 9))),
          pw.Text(value, style: pw.TextStyle(fontSize: isA5 ? 7 : 9)),
        ],
      ),
    );
  }

  pw.Widget _pdfSignatureBox(String label, {bool isA5 = false}) {
    return pw.Column(
      children: [
        pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: isA5 ? 8 : 10)),
        pw.SizedBox(height: 30),
        pw.Container(width: isA5 ? 100 : 150, height: 1, color: PdfColors.black),
        pw.Text('Nom et Signature', style: pw.TextStyle(fontSize: isA5 ? 6 : 8)),
      ],
    );
  }

  Future<void> showPrintOptions(BuildContext context, String title, Map<String, dynamic> data) async {
    final format = await showDialog<PdfPageFormat>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Format d\'impression', style: TextStyle(color: Color(0xFF003366))),
        content: const Text('Choisissez le format du document PDF :'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, PdfPageFormat.a5), child: const Text('Format A5 (Petit)')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, PdfPageFormat.a4),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003366)),
            child: const Text('Format A4 (Standard)', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (format != null) {
      _printReport(context, title, data, format: format);
    }
  }

  bool _checkAccess() {
    final user = AuthService.currentUser;
    if (user == null) return false;
    if (AuthService.isSuperAdmin()) return true;
    
    final role = user.entityRole?.toLowerCase();
    return role == 'responsable' || role == 'suppleant';
  }
}

// -----------------------------------------------------
// 1. RAPPORT DE SERVICE DIVIN
// -----------------------------------------------------
class RapportServiceDivinPage extends OfficialReportBase {
  final Map<String, dynamic> rapportData;
  const RapportServiceDivinPage({super.key, required this.rapportData});

  @override
  Widget build(BuildContext context) {
    if (!_checkAccess()) {
      return const Scaffold(body: Center(child: Text("Accès réservé aux responsables.")));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366), 
        title: const Text('Rapport Officiel de SD'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: 'Imprimer PDF',
            onPressed: () => showPrintOptions(context, 'RAPPORT DE SERVICE DIVIN', rapportData),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(context, rapportData),
            const SizedBox(height: 20),
            buildSectionTitle('INFORMATIONS GÉNÉRALES'),
            buildInfoRow('Jour:', rapportData['jour'] ?? ''),
            buildInfoRow('Date:', rapportData['date'] ?? ''),
            buildInfoRow('Type:', rapportData['type'] ?? 'SD'),
            const SizedBox(height: 20),
            buildSectionTitle('DÉTAILS DU SERVICE'),
            buildInfoRow('Cantique d\'intro:', rapportData['cantique'] ?? ''),
            buildInfoRow('Texte biblique:', rapportData['texteBiblique'] ?? ''),
            buildInfoRow('Officiant:', rapportData['officiant'] ?? ''),
            const SizedBox(height: 20),
            buildSectionTitle('ACTES'),
            _buildTriple('Saint Baptême:', rapportData['bapteme'], 'Saint Scellé:', rapportData['scelle'], 'Confirmation:', rapportData['confirmation']),
            const SizedBox(height: 12),
            const Text('Ordinations / Retraites:', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildQuad('AD:', rapportData['ordinationAD'], 'EVD:', rapportData['ordinationEVD'], 'B:', rapportData['ordinationB'], 'EV:', rapportData['ordinationEV']),
            const SizedBox(height: 32),
            buildSignatureRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildTriple(String l1, dynamic v1, String l2, dynamic v2, String l3, dynamic v3) {
    return Row(children: [
      Expanded(child: Text('$l1 ${v1 ?? 0}', style: const TextStyle(fontSize: 11))),
      Expanded(child: Text('$l2 ${v2 ?? 0}', style: const TextStyle(fontSize: 11))),
      Expanded(child: Text('$l3 ${v3 ?? 0}', style: const TextStyle(fontSize: 11))),
    ]);
  }

  Widget _buildQuad(String l1, dynamic v1, String l2, dynamic v2, String l3, dynamic v3, String l4, dynamic v4) {
    return Row(children: [
      Expanded(child: Text('$l1 ${v1 ?? 0}', style: const TextStyle(fontSize: 10))),
      Expanded(child: Text('$l2 ${v2 ?? 0}', style: const TextStyle(fontSize: 10))),
      Expanded(child: Text('$l3 ${v3 ?? 0}', style: const TextStyle(fontSize: 10))),
      Expanded(child: Text('$l4 ${v4 ?? 0}', style: const TextStyle(fontSize: 10))),
    ]);
  }
}

// -----------------------------------------------------
// 2. LISTE DE PRÉSENCE
// -----------------------------------------------------
class ListePresencePage extends OfficialReportBase {
  final Map<String, dynamic> data;
  const ListePresencePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (!_checkAccess()) {
      return const Scaffold(body: Center(child: Text("Accès réservé aux responsables.")));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366), 
        title: const Text('Liste de Présence'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: 'Imprimer PDF',
            onPressed: () => showPrintOptions(context, 'LISTE DE PRÉSENCE', data),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildHeader(context, data),
            const SizedBox(height: 20),
            buildInfoRow('JOUR ET DATE:', data['jourDate'] ?? ''),
            buildInfoRow('TENUE PAR:', data['tenuePar'] ?? ''),
            const SizedBox(height: 20),
            buildSectionTitle('LISTE DES PRÉSENTS'),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              columnWidths: const {0: FixedColumnWidth(30), 1: FlexColumnWidth(4), 2: FlexColumnWidth(2)},
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: Color(0xFF003366)),
                  children: [
                    _buildCell('N°', color: Colors.white),
                    _buildCell('NOMS ET PRÉNOMS', color: Colors.white),
                    _buildCell('MINISTÈRE', color: Colors.white),
                  ]
                ),
                ...List.generate(15, (i) => TableRow(children: [
                  _buildCell('${i+1}'),
                  _buildCell('...'),
                  _buildCell('...'),
                ]))
              ],
            ),
            const SizedBox(height: 32),
            buildSignatureRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildCell(String text, {Color? color}) {
    return Padding(padding: const EdgeInsets.all(6), child: Text(text, style: TextStyle(fontSize: 10, color: color, fontWeight: color != null ? FontWeight.bold : FontWeight.normal)));
  }
}

// -----------------------------------------------------
// 3. RAPPORT DE SACRISTIE
// -----------------------------------------------------
class RapportSacristiePage extends OfficialReportBase {
  final Map<String, dynamic> rapportData;
  const RapportSacristiePage({super.key, required this.rapportData});

  @override
  Widget build(BuildContext context) {
    if (!_checkAccess()) {
      return const Scaffold(body: Center(child: Text("Accès réservé aux responsables.")));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366), 
        title: const Text('Rapport de Sacristie'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: 'Imprimer PDF',
            onPressed: () => showPrintOptions(context, 'RAPPORT DE SACRISTIE', rapportData),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildHeader(context, rapportData),
            const SizedBox(height: 24),
            buildSectionTitle('I. POINTAGE DES MEMBRES'),
            buildInfoRow('Frères présents:', rapportData['field_1']?.toString() ?? '...'),
            buildInfoRow('Sœurs présentes:', rapportData['field_2']?.toString() ?? '...'),
            const SizedBox(height: 20),
            buildSectionTitle('II. ORDRE DANS L\'ÉGLISE'),
            buildInfoRow('Constats:', rapportData['field_1'] ?? 'RAS'),
            const SizedBox(height: 20),
            buildSectionTitle('III. DÉPOUILLEMENT DES OFFRANDES'),
            buildInfoRow('Montant Global:', rapportData['field_1'] ?? '...'),
            const SizedBox(height: 32),
            buildInfoRow('Rapporteur:', rapportData['officiant'] ?? AuthService.currentUser?.fullName ?? '...'),
            const SizedBox(height: 32),
            buildSignatureRow(),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------
// 4. COMMUNIQUÉ OFFICIEL
// -----------------------------------------------------
class CommuniquePage extends OfficialReportBase {
  final Map<String, dynamic> data;
  const CommuniquePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (!_checkAccess()) {
      return const Scaffold(body: Center(child: Text("Accès réservé aux responsables.")));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366), 
        title: const Text('Communiqué Officiel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: 'Imprimer PDF',
            onPressed: () => showPrintOptions(context, 'COMMUNIQUÉ OFFICIEL', data),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildHeader(context, data),
            const SizedBox(height: 24),
            buildSectionTitle('CONTENU DU COMMUNIQUÉ'),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                data['contenu'] ?? 'Aucun contenu spécifié.',
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
            const SizedBox(height: 40),
            buildSignatureRow(),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------
// 5. RAPPORT GÉNÉRIQUE
// -----------------------------------------------------
class RapportGeneriquePage extends OfficialReportBase {
  final String title;
  final Map<String, dynamic> data;
  const RapportGeneriquePage({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    if (!_checkAccess()) {
      return const Scaffold(body: Center(child: Text("Accès réservé aux responsables.")));
    }

    final displayData = data.entries.where((e) => 
      !['entiteId', 'territoriale', 'champ', 'district', 'communaute', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'h7', 'h8', 'official_title'].contains(e.key)
    ).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366), 
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: 'Imprimer PDF',
            onPressed: () => showPrintOptions(context, title.toUpperCase(), data),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildHeader(context, data),
            const SizedBox(height: 24),
            buildSectionTitle(title.toUpperCase()),
            const SizedBox(height: 16),
            ...displayData.map((e) {
              final label = e.key.replaceAll('field_', '').replaceAll('_', ' ').toUpperCase();
              return buildInfoRow('$label:', e.value?.toString() ?? '...');
            }).toList(),
            const SizedBox(height: 40),
            buildSignatureRow(),
          ],
        ),
      ),
    );
  }
}
