// lib/screens/reports/validation_screen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/report_model.dart';
import '../../models/validation_model.dart';

class ValidationScreen extends StatelessWidget {
  final ReportModel report;

  const ValidationScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validation du Rapport'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${report.type}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Contenu: ${report.toString()}'),
            const SizedBox(height: 20),
            const Text('Action de validation:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _validate(context, 'Approuvé'),
                  icon: const Icon(Icons.check),
                  label: const Text('Approuver'),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton.icon(
                  onPressed: () => _validate(context, 'Rejeté'),
                  icon: const Icon(Icons.close),
                  label: const Text('Rejeter'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _validate(BuildContext context, String decision) {
    final box = Hive.box<ValidationModel>('validations');
    final validation = ValidationModel(
      id: DateTime.now().toString(),
      reportId: report.id,
      validatorRole: 'Chef de District', // À rendre dynamique
      validatorName: 'Apôtre Kiamuaela', // À rendre dynamique
      decision: decision,
      validatedAt: DateTime.now(),
    );
    box.add(validation);

    // Mettre à jour le statut du rapport
    // (Logic de mise à jour du ReportModel via Hive ici)

    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Rapport $decision')));
  }
}

