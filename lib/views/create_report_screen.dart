import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:printing/printing.dart';
import 'package:uuid/uuid.dart';
import '../models/church_report.dart';
import '../models/hierarchy_models.dart';
import '../services/file_storage_service.dart';
import '../services/auth_service.dart';
import '../services/report_pdf_generator.dart';
import '../widgets/header_officiel.dart';
import '../widgets/signature_pad_dialog.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String? _signaturePath;
  ReportTypeExt _selectedType = ReportTypeExt.serviceDivin;
  final _officiantCtrl = TextEditingController();
  final _texteBibliqueCtrl = TextEditingController();
  final _cantiqueCtrl = TextEditingController();
  final _numeroRecuCtrl = TextEditingController();
  final _assistantsCtrl = TextEditingController();
  
  int _presenceTotale = 0;
  int _nombreMembres = 0;
  int _nombreVisiteurs = 0;
  double _offrandeFC = 0;
  double _offrandeDevise = 0;
  
  int _baptemes = 0;
  int _scelles = 0;
  int _confirmations = 0;
  int _ordinations = 0;
  int _mandatements = 0;
  int _nominations = 0;
  int _retraites = 0;

  @override
  void initState() {
    super.initState();
    // Pré-remplissage avec les données de l'utilisateur connecté
    final user = AuthService.currentUser;
    if (user != null) {
      _officiantCtrl.text = user.fullName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Nouveau Rapport Officiel'),
        backgroundColor: const Color(0xFF003366),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _generatePDF,
            tooltip: 'Aperçu PDF',
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isWeb ? 1000 : double.infinity),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. Entête Officiel Modulaire
                HeaderOfficiel(
                  lines: [
                    HeaderLine('CHAMP', AuthService.currentUser?.entityId ?? 'Ecclésiaste'),
                    HeaderLine('DISTRICT', 'Ngaliema'),
                    HeaderLine('COMMUNAUTÉ', 'Centrale'),
                  ],
                  typeRapport: _getReportTypeLabel(_selectedType),
                  date: DateTime.now(),
                ),
                const SizedBox(height: 20),

                // 2. Type de Rapport
                _buildSectionCard(
                  title: 'TYPE DE RAPPORT',
                  icon: Icons.category,
                  child: DropdownButtonFormField<ReportTypeExt>(
                    initialValue: _selectedType,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Sélectionner'),
                    items: ReportTypeExt.values.map((t) => DropdownMenuItem(value: t, child: Text(_getReportTypeLabel(t)))).toList(),
                    onChanged: (v) => setState(() => _selectedType = v!),
                  ),
                ),

                // 3. Liturgie & Officiels
                _buildSectionCard(
                  title: 'CONTENU ET OFFICIANT',
                  icon: Icons.person,
                  child: Column(
                    children: [
                      _buildTextField(_officiantCtrl, 'Officiant Principal'),
                      const SizedBox(height: 12),
                      _buildTextField(_assistantsCtrl, 'Assistants (séparés par des virgules)'),
                      const SizedBox(height: 12),
                      _buildTextField(_texteBibliqueCtrl, 'Texte Biblique de base'),
                      const SizedBox(height: 12),
                      _buildTextField(_cantiqueCtrl, 'Cantique d\'introduction'),
                    ],
                  ),
                ),

                // 4. Statistiques (Responsive Grid)
                _buildSectionCard(
                  title: 'STATISTIQUES DE PRÉSENCE',
                  icon: Icons.analytics,
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildCounter('Présence Totale', _presenceTotale, (v) => setState(() => _presenceTotale = v)),
                      _buildCounter('Membres', _nombreMembres, (v) => setState(() => _nombreMembres = v)),
                      _buildCounter('Visiteurs', _nombreVisiteurs, (v) => setState(() => _nombreVisiteurs = v)),
                    ],
                  ),
                ),

                // 5. Offrandes
                _buildSectionCard(
                  title: 'OFFRANDES ET COMPTABILITÉ',
                  icon: Icons.account_balance_wallet,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildNumberField('Offrandes FC', (v) => _offrandeFC = v)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildNumberField('Offrandes Devise', (v) => _offrandeDevise = v)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(_numeroRecuCtrl, 'Numéro du Reçu'),
                    ],
                  ),
                ),

                if (_shouldShowActes())
                  _buildSectionCard(
                    title: 'ACTES SACRAMENTELS ET MINISTÉRIELS',
                    icon: Icons.auto_awesome,
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 12,
                      children: [
                        _buildCounter('Baptême', _baptemes, (v) => setState(() => _baptemes = v)),
                        _buildCounter('Scellé', _scelles, (v) => setState(() => _scelles = v)),
                        _buildCounter('Confirmation', _confirmations, (v) => setState(() => _confirmations = v)),
                        _buildCounter('Ordination', _ordinations, (v) => setState(() => _ordinations = v)),
                        _buildCounter('Mandatement', _mandatements, (v) => setState(() => _mandatements = v)),
                        _buildCounter('Nomination', _nominations, (v) => setState(() => _nominations = v)),
                        _buildCounter('Retraite', _retraites, (v) => setState(() => _retraites = v)),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // 6.5 Signature
                _buildSectionCard(
                  title: 'SIGNATURE DU RAPPORTEUR',
                  icon: Icons.edit,
                  child: Column(
                    children: [
                      if (_signaturePath != null)
                        Container(
                          height: 100,
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FutureBuilder<Uint8List?>( // Utilisation de FutureBuilder
                            future: FileStorageService.readFile(_signaturePath!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                return Image.memory(snapshot.data!, fit: BoxFit.contain);
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Erreur de chargement de la signature: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                              }
                              return const Center(child: CircularProgressIndicator()); // Placeholder de chargement
                            },
                          ),
                        ),
                      OutlinedButton.icon(
                        onPressed: _showSignaturePad,
                        icon: const Icon(Icons.fingerprint),
                        label: Text(_signaturePath == null
                            ? 'SIGNER LE RAPPORT'
                            : 'MODIFIER LA SIGNATURE'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                
                // 7. Actions Finales
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveReport,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003366),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('ENREGISTRER ET SOUMETTRE', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
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

  Widget _buildSectionCard({required String title, required IconData icon, required Widget child}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF003366), size: 20),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366))),
              ],
            ),
            const Divider(height: 24),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label) {
    return TextFormField(
      controller: ctrl,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
    );
  }

  Widget _buildNumberField(String label, Function(double) onChanged) {
    return TextFormField(
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      keyboardType: TextInputType.number,
      onChanged: (v) => onChanged(double.tryParse(v) ?? 0),
    );
  }

  Widget _buildCounter(String label, int value, Function(int) onChanged) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: value > 0 ? () => onChanged(value - 1) : null),
              Text('$value', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => onChanged(value + 1)),
            ],
          ),
        ],
      ),
    );
  }

  bool _shouldShowActes() {
    return [
      ReportTypeExt.serviceDivin,
      ReportTypeExt.jeunesse,
      ReportTypeExt.ecodim,
      ReportTypeExt.bapteme,
      ReportTypeExt.scellement,
      ReportTypeExt.ordinationInstallation,
      ReportTypeExt.sainteCene
    ].contains(_selectedType);
  }

  String _getReportTypeLabel(ReportTypeExt type) {
    switch (type) {
      case ReportTypeExt.serviceDivin: return 'Service Divin';
      case ReportTypeExt.visitePastorale: return 'Visite Pastorale';
      case ReportTypeExt.communionFraternelle: return 'Communion Fraternelle';
      case ReportTypeExt.ordinationInstallation: return 'Ordination / Installation';
      case ReportTypeExt.funerailles: return 'Funérailles';
      case ReportTypeExt.mariage: return 'Mariage';
      case ReportTypeExt.bapteme: return 'Baptême';
      case ReportTypeExt.scellement: return 'Saint-Scellement';
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


  Future<void> _showSignaturePad() async {
    // Le dialogue retourne maintenant directement les octets de l'image
    final Uint8List? signatureBytes = await showDialog<Uint8List>(
      context: context,
      builder: (context) => const SignaturePadDialog(title: 'Signature du Rapporteur'),
    );
    if (signatureBytes != null && signatureBytes.isNotEmpty) {
      // On sauvegarde directement les octets via le service
      final path = await FileStorageService.saveFile(signatureBytes, 'png'); // La signature est un PNG
      setState(() {
        _signaturePath = path;
      });
    }
  }

  ChurchReport _buildReportModel() {
    return ChurchReport(
      id: const Uuid().v4(),
      type: _selectedType,
      niveauEntite: EntityLevel.communaute, // À adapter selon l'utilisateur
      nomEntite: AuthService.currentUser?.entityId ?? 'Centrale',
      nomChamp: AuthService.currentUser?.entityId ?? 'Kinshasa Sud-Ouest',
      nomDistrict: AuthService.currentUser?.entityId ?? 'Ngaliema',
      dateRapport: DateTime.now(),
      heureDebut: DateTime.now().subtract(const Duration(hours: 1)),
      officiant: _officiantCtrl.text,
      assistants: _assistantsCtrl.text.split(',').map((e) => e.trim()).toList(),
      texteBiblique: _texteBibliqueCtrl.text,
      cantiqueIntroduction: _cantiqueCtrl.text,
      presenceTotale: _presenceTotale,
      nombreMembres: _nombreMembres,
      nombreVisiteurs: _nombreVisiteurs,
      offrandeFC: _offrandeFC,
      offrandeDevise: _offrandeDevise,
      numeroRecu: _numeroRecuCtrl.text,
      nombreBaptemes: _baptemes,
      nombreScelles: _scelles,
      nombreConfirmations: _confirmations,
      nombreOrdinations: _ordinations,
      nombreMandatements: _mandatements,
      nombreNominations: _nominations,
      nombreRetraites: _retraites,
      rapporteur: AuthService.currentUser?.fullName ?? 'Anonyme',
      rapporteurId: AuthService.currentUser?.id,
      statut: ReportStatus.soumis,
      signaturePath: _signaturePath, // Utilisation du chemin
    );
  }

  Future<void> _saveReport() async {
    if (_formKey.currentState!.validate()) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Confirmer la soumission'),
          content: const Text('Voulez-vous enregistrer ce rapport et le transmettre à la hiérarchie ?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('ANNULER')),
            ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('TRANSMETTRE')),
          ],
        ),
      );

      if (confirm == true) {
        final report = _buildReportModel();
        final box = Hive.box<ChurchReport>('church_reports');
        await box.put(report.id, report);

        if (mounted) {
          // Affichage du dialogue de succès final
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 10),
                  Text('Rapport Transmis'),
                ],
              ),
              content: Text('Le rapport "${_getReportTypeLabel(_selectedType)}" a été enregistré et transmis avec succès à votre hiérarchie directe.'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003366)),
                  child: const Text('OK'),
                ),
              ],
            ),
          );

          if (mounted) Navigator.pop(context);
        }
      }

    }
  }

  // 1. Créez une fonction statique ou globale (obligatoire pour l'Isolate)
  static Future<Uint8List> _buildPdfTask(Map<String, dynamic> params) async {
    // Recréer l'objet ChurchReport à partir de la Map
    final reportMap = params['report'] as Map<String, dynamic>;
    final report = ChurchReport.fromMap(reportMap);
    final logoBytes = params['logo'] as Uint8List;

    return await ReportPdfGenerator.generate(report, logoBytes);
  }

  Future<void> _generatePDF() async {
    final report = _buildReportModel();
    final ByteData logoData = await rootBundle.load('assets/branding/logo_ena.png');

    // L'interface reste fluide pendant que l'Isolate travaille
    final pdfBytes = await compute(_buildPdfTask, {
      // On passe une Map car ChurchReport (HiveObject) ne peut pas traverser l'Isolate
      'report': report.toMap(),
      'logo': logoData.buffer.asUint8List(),
    });

    await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
  }
}

