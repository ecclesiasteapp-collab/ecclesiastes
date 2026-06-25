import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/church_report.dart';

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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final report = ChurchReport(
        id: DateTime.now().toString(),
        communityId: widget.communityId,
        date: DateTime.now(),
        assistants: int.parse(_assistantsController.text),
        communionGuests: 0,
        sermonSubject: _sermonController.text,
        ministerName: 'Nom du Ministre',
      );
      Hive.box<ChurchReport>('church_reports').add(report);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _assistantsController.dispose();
    _sermonController.dispose();
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
              decoration: const InputDecoration(labelText: 'Sujet du sermon'),
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
