// lib/screens/reports/service_divin_report_screen.dart
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import '../../models/territory_config.dart';
import '../../services/pdf_official_generator.dart';

class ServiceDivinReportScreen extends StatefulWidget {
  final TerritoryConfig territoryConfig;
  final String communityId;
  final String communityName;
  final String districtName;
  final String champName;

  const ServiceDivinReportScreen({
    Key? key,
    required this.territoryConfig,
    required this.communityId,
    required this.communityName,
    required this.districtName,
    required this.champName,
  }) : super(key: key);

  @override
  State<ServiceDivinReportScreen> createState() => _ServiceDivinReportScreenState();
}

class _ServiceDivinReportScreenState extends State<ServiceDivinReportScreen> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs
  final TextEditingController _cantiqueCtrl = TextEditingController();
  final TextEditingController _texteBibliqueCtrl = TextEditingController();
  final TextEditingController _numeroRecuCtrl = TextEditingController();
  final TextEditingController _nominationCtrl = TextEditingController();
  final TextEditingController _retraiteCtrl = TextEditingController();

  // Signatures
  final SignatureController _approuveParCtrl = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  final SignatureController _rapporteurCtrl = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  // Valeurs
  String _jourType = 'DM';
  String _eventType = 'SD';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _heureDebut = TimeOfDay.now();
  TimeOfDay _heureFin = TimeOfDay.now().replacing(hour: (TimeOfDay.now().hour + 2) % 24);

  String? _selectedOfficiant;
  List<String> _assistants = ['', '', '', ''];

  int _presencesTotales = 0;
  int _membres = 0;
  int _visiteurs = 0;
  double _offrandesFC = 0;
  double _offrandesDevise = 0;

  int _bapteme = 0;
  int _scelle = 0;
  int _confirmation = 0;
  int _ordination = 0;
  int _pretre = 0;
  int _diacre = 0;
  int _mandatement = 0;
  int _rd = 0;
  int _rc = 0;
  int _autresMandatement = 0;

  List<String> _availableMinisters = ['P. KIBIKULA', 'Sr. KIAMUAELA', 'D. MBEKU', 'Evd. NGOMA'];

  @override
  void dispose() {
    _cantiqueCtrl.dispose();
    _texteBibliqueCtrl.dispose();
    _numeroRecuCtrl.dispose();
    _nominationCtrl.dispose();
    _retraiteCtrl.dispose();
    _approuveParCtrl.dispose();
    _rapporteurCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        title: const Text('Rapport de Service Divin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _generateAndPreviewPDF,
            tooltip: 'Générer le PDF',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // EN-TÊTE
            _buildSectionTitle('📋 Informations Générales'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Jour et Type
                    Row(
                      children: [
                        Expanded(
                          child: _buildRadioGroup(
                            'Jour',
                            _jourType,
                            ['DM', 'JDS'],
                            (val) => setState(() => _jourType = val!),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _eventType,
                            decoration: const InputDecoration(labelText: 'Type'),
                            items: ['SD', 'RF', 'SJ', 'S', 'SE', 'SF', 'MA', 'C']
                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (val) => setState(() => _eventType = val!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Date
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_today, color: Color(0xFF003366)),
                      title: Text('Date : ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) setState(() => _selectedDate = date);
                      },
                    ),

                    // Heures
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Début : ${_heureDebut.format(context)}'),
                            onTap: () async {
                              final time = await showTimePicker(context: context, initialTime: _heureDebut);
                              if (time != null) setState(() => _heureDebut = time);
                            },
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Fin : ${_heureFin.format(context)}'),
                            onTap: () async {
                              final time = await showTimePicker(context: context, initialTime: _heureFin);
                              if (time != null) setState(() => _heureFin = time);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // CONTENU LITURGIQUE
            _buildSectionTitle('🎵 Contenu Liturgique'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _cantiqueCtrl,
                      decoration: const InputDecoration(labelText: 'Cantique d\'introduction'),
                      validator: (v) => v!.isEmpty ? 'Requis' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _texteBibliqueCtrl,
                      decoration: const InputDecoration(labelText: 'Texte Biblique'),
                      validator: (v) => v!.isEmpty ? 'Requis' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedOfficiant,
                      decoration: const InputDecoration(labelText: 'Officiant'),
                      items: _availableMinisters
                          .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedOfficiant = val),
                      validator: (v) => v == null ? 'Requis' : null,
                    ),
                    const SizedBox(height: 12),
                    const Text('Assistants (max 4)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...List.generate(4, (i) => Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextFormField(
                        initialValue: _assistants[i],
                        decoration: InputDecoration(labelText: 'Assistant ${i + 1}'),
                        onChanged: (val) => _assistants[i] = val,
                      ),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // STATISTIQUES
            _buildSectionTitle('📊 Statistiques et Finances'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildCounter('Présences Totales', _presencesTotales, (val) => setState(() => _presencesTotales = val)),
                    Row(
                      children: [
                        Expanded(child: _buildCounter('Membres', _membres, (val) => setState(() => _membres = val))),
                        const SizedBox(width: 16),
                        Expanded(child: _buildCounter('Visiteurs', _visiteurs, (val) => setState(() => _visiteurs = val))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Offrandes FC', prefixText: 'FC '),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => _offrandesFC = double.tryParse(val) ?? 0,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Offrandes Devise', prefixText: '\$ '),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => _offrandesDevise = double.tryParse(val) ?? 0,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _numeroRecuCtrl,
                      decoration: const InputDecoration(labelText: 'Numéro du Reçu'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ACTES
            _buildSectionTitle('✝️ Actes'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildCounter('Baptême', _bapteme, (val) => setState(() => _bapteme = val))),
                        Expanded(child: _buildCounter('Scellé', _scelle, (val) => setState(() => _scelle = val))),
                        Expanded(child: _buildCounter('Confirmation', _confirmation, (val) => setState(() => _confirmation = val))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildCounter('Ordination', _ordination, (val) => setState(() => _ordination = val))),
                        Expanded(child: _buildCounter('Prêtre', _pretre, (val) => setState(() => _pretre = val))),
                        Expanded(child: _buildCounter('Diacre', _diacre, (val) => setState(() => _diacre = val))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildCounter('Mandatement', _mandatement, (val) => setState(() => _mandatement = val))),
                        Expanded(child: _buildCounter('RD', _rd, (val) => setState(() => _rd = val))),
                        Expanded(child: _buildCounter('RC', _rc, (val) => setState(() => _rc = val))),
                        Expanded(child: _buildCounter('Autres', _autresMandatement, (val) => setState(() => _autresMandatement = val))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nominationCtrl,
                      decoration: const InputDecoration(labelText: 'Nomination (détails)'),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _retraiteCtrl,
                      decoration: const InputDecoration(labelText: 'Retraite (détails)'),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // SIGNATURES
            _buildSectionTitle('✍️ Signatures'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Approuvé par', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Signature(controller: _approuveParCtrl, backgroundColor: Colors.grey[100]!),
                    ),
                    TextButton.icon(
                      onPressed: () => _approuveParCtrl.clear(),
                      icon: const Icon(Icons.clear),
                      label: const Text('Effacer'),
                    ),
                    const SizedBox(height: 16),
                    const Text('Le Rapporteur', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Signature(controller: _rapporteurCtrl, backgroundColor: Colors.grey[100]!),
                    ),
                    TextButton.icon(
                      onPressed: () => _rapporteurCtrl.clear(),
                      icon: const Icon(Icons.clear),
                      label: const Text('Effacer'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // BOUTON GÉNÉRER
            ElevatedButton.icon(
              onPressed: _generateAndPreviewPDF,
              icon: const Icon(Icons.picture_as_pdf, size: 24),
              label: const Text('GÉNÉRER LE PDF', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCounter(String label, int value, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: value > 0 ? () => onChanged(value - 1) : null,
            ),
            Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => onChanged(value + 1),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
    );
  }

  Widget _buildRadioGroup(String label, String groupValue, List<String> options, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: options.map((opt) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioMenuButton<String>(
                value: opt, 
                groupValue: groupValue, 
                onChanged: onChanged,
                child: Text(opt),
              ),
            ],
          )).toList(),
        ),
      ],
    );
  }

  Future<void> _generateAndPreviewPDF() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs obligatoires'), backgroundColor: Colors.red),
      );
      return;
    }

    final data = {
      'champ': widget.champName,
      'district': widget.districtName,
      'communaute': widget.communityName,
      'jour': _jourType,
      'type': _eventType,
      'date': DateFormat('dd/MM/yyyy').format(_selectedDate),
      'heureDebut': _heureDebut.format(context),
      'heureFin': _heureFin.format(context),
      'cantique': _cantiqueCtrl.text,
      'texteBiblique': _texteBibliqueCtrl.text,
      'officiant': _selectedOfficiant ?? '',
      'assistant1': _assistants[0],
      'assistant2': _assistants[1],
      'assistant3': _assistants[2],
      'assistant4': _assistants[3],
      'presencesTotales': _presencesTotales,
      'membres': _membres,
      'visiteurs': _visiteurs,
      'offrandesFC': _offrandesFC,
      'offrandesDevise': _offrandesDevise,
      'numeroRecu': _numeroRecuCtrl.text,
      'bapteme': _bapteme,
      'scelle': _scelle,
      'confirmation': _confirmation,
      'ordination': _ordination,
      'pretre': _pretre,
      'diacre': _diacre,
      'mandatement': _mandatement,
      'rd': _rd,
      'rc': _rc,
      'autresMandatement': _autresMandatement,
      'nomination': _nominationCtrl.text,
      'retraite': _retraiteCtrl.text,
    };

    final pdf = await PdfOfficialGenerator.generateServiceDivin(
      config: widget.territoryConfig,
      data: data,
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}
