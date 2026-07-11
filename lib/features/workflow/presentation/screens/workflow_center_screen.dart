import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workflow_providers.dart';
import '../domain/models/workflow_models.dart';
import '../../../../models/hierarchy_models.dart';
import '../../../../auth_provider.dart';
import 'package:provider/provider.dart' as legacy_provider;
import 'package:intl/intl.dart';

class WorkflowCenterScreen extends ConsumerWidget {
  const WorkflowCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProvider = legacy_provider.Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Veuillez vous connecter')));
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Centre de Validation'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'À valider', icon: Icon(Icons.pending_actions)),
              Tab(text: 'Mes demandes', icon: Icon(Icons.history_edu)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _PendingTasksList(user: user),
            _MyRequestsList(user: user),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showStartWorkflowDialog(context, ref, user.id, user.entityId),
          label: const Text('Nouvelle Demande'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showStartWorkflowDialog(BuildContext context, WidgetRef ref, String userId, String entityId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Lancer un processus', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Inscription Membre'),
            onTap: () async {
              Navigator.pop(context);
              final engine = ref.read(workflowEngineProvider);
              await engine.startProcess(
                definitionId: 'member_creation',
                initiatorId: userId,
                entityId: entityId,
                data: {'memberName': 'Nouveau Membre Test', 'date': DateTime.now().toIso8601String()},
              );
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demande envoyée')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('Demande de Dépense'),
            onTap: () {
              Navigator.pop(context);
              // Handle other workflow
            },
          ),
        ],
      ),
    );
  }
}

class _PendingTasksList extends ConsumerWidget {
  final dynamic user;
  const _PendingTasksList({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(workflowRepositoryProvider);
    
    return FutureBuilder<List<WorkflowInstance>>(
      future: repository.getPendingInstancesForRole(user.role.name),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final tasks = snapshot.data!;

        if (tasks.isEmpty) {
          return const Center(child: Text('Aucune tâche en attente'));
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text('Demande: ${task.definitionId}'),
                subtitle: Text('Initié par: ${task.initiatorId} - ${DateFormat('dd/MM').format(task.createdAt)}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showApprovalDialog(context, ref, task, user),
              ),
            );
          },
        );
      },
    );
  }

  void _showApprovalDialog(BuildContext context, WidgetRef ref, WorkflowInstance task, dynamic user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Action de Validation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Processus: ${task.definitionId}'),
            Text('Données: ${task.data}'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'Commentaire (Optionnel)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(workflowEngineProvider).reject(
                instanceId: task.id,
                userId: user.id,
                userName: user.fullName,
                reason: 'Refusé par ${user.fullName}',
              );
              Navigator.pop(context);
            },
            child: const Text('REJETER', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(workflowEngineProvider).approveStep(
                instanceId: task.id,
                userId: user.id,
                userName: user.fullName,
              );
              Navigator.pop(context);
            },
            child: const Text('APPROUVER'),
          ),
        ],
      ),
    );
  }
}

class _MyRequestsList extends ConsumerWidget {
  final dynamic user;
  const _MyRequestsList({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(workflowRepositoryProvider);
    
    return FutureBuilder<List<WorkflowInstance>>(
      future: repository.getUserRequests(user.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final requests = snapshot.data!;

        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final req = requests[index];
            return ListTile(
              title: Text(req.definitionId),
              subtitle: Text('Status: ${req.status.name}'),
              trailing: Text(DateFormat('dd/MM/yyyy').format(req.createdAt)),
            );
          },
        );
      },
    );
  }
}
