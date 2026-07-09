import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/erp_providers.dart';
import '../../domain/entities/workflow/workflow_instance.dart';
import '../../services/auth_service.dart';
import '../signature_screen.dart';

class ReportApprovalScreen extends ConsumerWidget {
  final String instanceId;

  const ReportApprovalScreen({super.key, required this.instanceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Approbation du Rapport"),
      ),
      body: FutureBuilder<WorkflowInstance>(
        future: ref.read(workflowRepositoryProvider).getInstance(instanceId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final instance = snapshot.data!;
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Détails du Rapport", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(instance.data.toString()), // Simple view of data
                  ),
                ),
                const Spacer(),
                const Text(
                  "En tant que responsable, votre signature numérique est requise pour valider ce rapport.",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _reject(context, ref),
                        child: const Text("REJETER"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text("SIGNER & APPROUVER"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => _signAndApprove(context, ref),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _signAndApprove(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SignatureScreen(
          onSignatureSaved: (bytes) async {
            if (bytes != null) {
              final signUseCase = ref.read(signWorkflowStepProvider);
              await signUseCase.execute(
                instanceId: instanceId,
                actorId: AuthService.currentUserId,
                comment: "Rapport vérifié et approuvé.",
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("✅ Rapport signé et approuvé avec succès."))
              );
            }
          },
        ),
      ),
    );
  }

  void _reject(BuildContext context, WidgetRef ref) {
    // Simplified rejection logic
    Navigator.pop(context);
  }
}
