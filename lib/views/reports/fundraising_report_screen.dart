import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:printing/printing.dart';
import 'package:uuid/uuid.dart';
import '../../models/fundraising_report.dart';
import '../../services/auth_service.dart';
import '../../services/fundraising_pdf_generator.dart';
import '../../widgets/header_officiel.dart';

class FundraisingReportScreen extends StatefulWidget {
  const FundraisingReportScreen({super.key});

  @override
  State<FundraisingReportScreen> createState() => _FundraisingReportScreenState();
}

class _FundraisingReportScreenState extends State<FundraisingReportScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Contrôleurs
  final _motifCtrl = TextEditingController();
  final _commissionCtrl = TextEditingController(text: 'Econfi');
  final _rapporteurCtrl = TextEditingController();
  final _observationsCtrl = TextEditingController();
  final _precisionDestCtrl = TextEditingController();

  // Montants
  double _cotisationsFC = 0;
  double _collecteSpecialeFC = 0;
  double _donsDiversFC = 0;
  double _autresFC = 0;
  
  double _cotisationsDevise = 0;
  double _collecteSpecialeDevise = 0;
  double _donsDiversDevise = 0;
  double _autresDevise = 0;

  int _nbContributeurs = 0;
  int _nbAbsents = 0;

  String _destination = 'Projet local';

  @override
  void initState() {
    super.initState();
    final user = AuthService.currentUser;
    if (user != null) {
      _rapporteurCtrl.text = user.fullName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 900;
    final user = AuthService.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        title: const Text('Collecte de Fonds'),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isWeb ? 1000 : double.infinity),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                HeaderOfficiel(
                  lines: [
                    HeaderLine('CHAMP', user?.entityId ?? 'Kinshasa Sud-Ouest'),
                    HeaderLine('DISTRICT', 'Ngaliema'),
                    HeaderLine('COMMUNAUTÉ', 'Centrale'),
                  ],
                  typeRapport: 'COTISATION ET COLLECTE DE FONDS',
                  date: DateTime.now(),
                ),
                const SizedBox(height: 16),

                // Informations Générales
                _buildCard('Informations Générales', [
                  TextFormField(
                    controller: _motifCtrl,
                    decoration: const InputDecoration(labelText: 'Motif de la collecte (ex: Construction, Jeunesse)', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Requis' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _commissionCtrl,
                    decoration: const InputDecoration(labelText: 'Commission organisatrice', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _rapporteurCtrl,
                    decoration: const InputDecoration(labelText: 'Nom du Rapporteur', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Requis' : null,
                  ),
                ]),
                const SizedBox(height: 16),

                // Montants en FC
                _buildCard('Montants en Francs Congolais (FC)', [
                  _buildCurrencyField('1. Cotisations des membres', (v) => setState(() => _cotisationsFC = v)),
                  _buildCurrencyField('2. Collecte spéciale', (v) => setState(() => _collecteSpecialeFC = v)),
                  _buildCurrencyField('3. Dons et offrandes diverses', (v) => setState(() => _donsDiversFC = v)),
                  _buildCurrencyField('4. Autres', (v) => setState(() => _autresFC = v)),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('TOTAL GÉNÉRAL FC', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('${(_cotisationsFC + _collecteSpecialeFC + _donsDiversFC + _autresFC).toStringAsFixed(2)} FC', 
                           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF003366))),
                    ],
                  ),
                ]),
                const SizedBox(height: 16),

                // Montants en Devise
                _buildCard('Montants en Devise (USD/EUR)', [
                  _buildCurrencyField('1. Cotisations des membres', (v) => setState(() => _cotisationsDevise = v)),
                  _buildCurrencyField('2. Collecte spéciale', (v) => setState(() => _collecteSpecialeDevise = v)),
                  _buildCurrencyField('3. Dons et offrandes diverses', (v) => setState(() => _donsDiversDevise = v)),
                  _buildCurrencyField('4. Autres', (v) => setState(() => _autresDevise = v)),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('TOTAL GÉNÉRAL DEVISE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text((_cotisationsDevise + _collecteSpecialeDevise + _donsDiversDevise + _autresDevise).toStringAsFixed(2),
                           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF003366))),
                    ],
                  ),
                ]),
                const SizedBox(height: 16),

                // Statistiques et Destination
                _buildCard('Statistiques et Destination', [
                  _buildIntField('Nombre de contributeurs (membres)', (v) => setState(() => _nbContributeurs = v)),
                  const SizedBox(height: 12),
                  _buildIntField('Nombre de membres absents ayant cotisé', (v) => setState(() => _nbAbsents = v)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _destination,
                    decoration: const InputDecoration(labelText: 'Destination des fonds', border: OutlineInputBorder()),
                    items: ['Projet local', 'Transfert au District', 'Transfert au Champ', 'Autre']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setState(() => _destination = v!),
                  ),
                  if (_destination == 'Projet local' || _destination == 'Autre')
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextFormField(
                        controller: _precisionDestCtrl,
                        decoration: const InputDecoration(labelText: 'Préciser la destination', border: OutlineInputBorder()),
                      ),
                    ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _observationsCtrl,
                    decoration: const InputDecoration(labelText: 'Observations du Rapporteur', border: OutlineInputBorder()),
                    maxLines: 3,
                  ),
                ]),
                const SizedBox(height: 24),

                // Boutons d'action
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _saveReport,
                        icon: const Icon(Icons.send),
                        label: const Text('ENREGISTRER ET SOUMETTRE', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003366),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 30),
                      onPressed: _generatePDF,
                      tooltip: 'Aperçu PDF',
                    ),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF003366))),
          const SizedBox(height: 16),
          ...children,
        ]),
      ),
    );
  }

  Widget _buildCurrencyField(String label, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), suffixText: 'unité'),
        onChanged: (v) => onChanged(double.tryParse(v) ?? 0),
      ),
    );
  }

  Widget _buildIntField(String label, ValueChanged<int> onChanged) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      onChanged: (v) => onChanged(int.tryParse(v) ?? 0),
    );
  }

  FundraisingReport _buildModel() {
    final user = AuthService.currentUser;
    return FundraisingReport(
      id: const Uuid().v4(),
      entityLevel: 'Communauté',
      entityName: user?.entityId ?? 'Centrale',
      districtName: user?.entityId ?? 'Ngaliema',
      champName: user?.entityId ?? 'Kinshasa Sud-Ouest',
      motif: _motifCtrl.text,
      commissionOrganisatrice: _commissionCtrl.text,
      dateCollecte: DateTime.now(),
      cotisationsFC: _cotisationsFC,
      collecteSpecialeFC: _collecteSpecialeFC,
      donsDiversFC: _donsDiversFC,
      autresFC: _autresFC,
      cotisationsDevise: _cotisationsDevise,
      collecteSpecialeDevise: _collecteSpecialeDevise,
      donsDiversDevise: _donsDiversDevise,
      autresDevise: _autresDevise,
      nombreContributeurs: _nbContributeurs,
      nombreAbsentsCotisants: _nbAbsents,
      destinationFonds: _destination,
      precisionDestination: _precisionDestCtrl.text,
      observations: _observationsCtrl.text,
      rapporteur: _rapporteurCtrl.text,
      dateSoumission: DateTime.now(),
    );
  }

  Future<void> _saveReport() async {
    if (_formKey.currentState!.validate()) {
      final report = _buildModel();
      final box = Hive.box<FundraisingReport>('fundraising_reports');
      await box.put(report.id, report);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Rapport de collecte enregistré avec succès')));
        Navigator.pop(context);
      }
    }
  }

  Future<void> _generatePDF() async {
    try {
      final report = _buildModel();
      final ByteData logoData = await rootBundle.load('assets/branding/logo_ena.png');
      final Uint8List logoBytes = logoData.buffer.asUint8List();

      // FundraisingReport étant un HiveObject, on génère directement sans isolate pour éviter les erreurs de sérialisation
      final pdfBytes = await FundraisingPdfGenerator.generate(report, logoBytes);
      await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur PDF: $e')));
      }
    }
  }
}

