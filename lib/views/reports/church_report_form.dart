import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/church_report.dart';
import '../../models/hierarchy_models.dart';

class ChurchReportForm extends StatefulWidget {
  final String communityId;
  const ChurchReportForm({super.key, required this.communityId});

  @override
  State<ChurchReportForm> createState() => _ChurchReportFormState();
}

class _ChurchReportFormState extends State<ChurchReportForm> {
  final _formKey = GlobalKey<FormState>();
  final _assistantsController = TextEditingController();
  final _sermonController = TextEditingController();
  final _rapporteurController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final report = ChurchReport(
        id: now.millisecondsSinceEpoch.toString(),
        type: ReportTypeExt.serviceDivin,
        niveauEntite: EntityLevel.communaute,
        nomEntite: widget.communityId,
        nomChamp: 'Ecclésiaste',

        nomDistrict: 'District', // À dynamiser plus tard
        dateRapport: now,
        heureDebut: now,
        presenceTotale: int.tryParse(_assistantsController.text) ?? 0,
        nombreMembres: int.tryParse(_assistantsController.text) ?? 0,
        officiant: 'Nom de l\'Officiant',
        texteBiblique: _sermonController.text,
        rapporteur: _rapporteurController.text,
        statut: ReportStatus.soumis,
      );

      Hive.box<ChurchReport>('church_reports').add(report);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _assistantsController.dispose();
    _sermonController.dispose();
    _rapporteurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rapport Service Divin')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _assistantsController,
              decoration: const InputDecoration(labelText: 'Nombre d\'assistants'),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? 'Requis' : null,
            ),
            TextFormField(
              controller: _sermonController,
              decoration: const InputDecoration(labelText: 'Sujet du sermon / Texte Biblique'),
              validator: (v) => v!.isEmpty ? 'Requis' : null,
            ),
            TextFormField(
              controller: _rapporteurController,
              decoration: const InputDecoration(labelText: 'Nom du Rapporteur'),
              validator: (v) => v!.isEmpty ? 'Requis' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Enregistrer le rapport')
            ),
          ],
        ),
      ),
    );
  }
}

