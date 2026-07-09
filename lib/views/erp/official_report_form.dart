import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/erp_providers.dart';
import '../../domain/entities/workflow/workflow_instance.dart';
import '../../services/auth_service.dart';

class OfficialReportForm extends ConsumerStatefulWidget {
  final String reportType; // "sacristie" or "service_divin"
  
  const OfficialReportForm({super.key, required this.reportType});

  @override
  ConsumerState<OfficialReportForm> createState() => _OfficialReportFormState();
}

class _OfficialReportFormState extends ConsumerState<OfficialReportForm> {
  final Map<String, dynamic> _formData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rapport Officiel: ${widget.reportType.toUpperCase()}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Saisie des données du rapport conformément au modèle papier."),
            const SizedBox(height: 24),
            // Dynamic fields based on widget.reportType
            TextField(
              decoration: const InputDecoration(labelText: "Présence totale"),
              keyboardType: TextInputType.number,
              onChanged: (v) => _formData['presence'] = v,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: "Offrande collectée (FC)"),
              keyboardType: TextInputType.number,
              onChanged: (v) => _formData['offrande'] = v,
            ),
            const Spacer(),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("Circuit de validation"),
              subtitle: Text("Responsable de Communauté → District"),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text("SOUMETTRE POUR VALIDATION"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => _submitWorkflow(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitWorkflow() async {
    final submitUseCase = ref.read(submitReportWorkflowProvider);
    final messenger = ScaffoldMessenger.of(context);

    try {
      await submitUseCase.execute(
        reportType: widget.reportType,
        entityId: AuthService.currentEntiteId,
        initiatorId: AuthService.currentUserId,
        reportData: _formData,
      );
      messenger.showSnackBar(const SnackBar(content: Text("✅ Rapport soumis au circuit de validation.")));
      Navigator.pop(context);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text("❌ Erreur: $e")));
    }
  }
}
