import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/construction_project.dart';
import '../../services/repository_providers.dart';
import '../../providers/scope_provider.dart';
import '../../core/theme.dart';
import 'package:uuid/uuid.dart';

class ConstructionPage extends ConsumerStatefulWidget {
  const ConstructionPage({super.key});

  @override
  ConsumerState<ConstructionPage> createState() => _ConstructionPageState();
}

class _ConstructionPageState extends ConsumerState<ConstructionPage> {
  bool _isLoading = true;
  List<ConstructionProject> _projects = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final entityId = ref.read(activeEntityIdProvider);
    final repo = ref.read(constructionRepositoryProvider);
    final projects = await repo.getProjectsForEntity(entityId);
    
    if (mounted) {
      setState(() {
        _projects = projects;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projets de Construction'),
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProjectDialog,
        backgroundColor: Colors.brown.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBody() {
    if (_projects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction_outlined, size: 80, color: Colors.brown.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text('Aucun projet en cours', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _showAddProjectDialog,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown.shade700, foregroundColor: Colors.white),
              child: const Text('Lancer un projet'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _projects.length,
      itemBuilder: (context, index) {
        final project = _projects[index];
        return _buildProjectCard(project);
      },
    );
  }

  Widget _buildProjectCard(ConstructionProject project) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(project.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                _buildStatusTag(project.status),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: project.progress,
              backgroundColor: Colors.grey.shade200,
              color: Colors.brown.shade700,
              minHeight: 10,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Progression: ${(project.progress * 100).toInt()}%', style: const TextStyle(fontSize: 12)),
                Text('Dépensé: ${project.spent} / ${project.budget} \$', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text('Début: ${project.startDate.toString().split(' ')[0]}', style: const TextStyle(fontSize: 12)),
                const Spacer(),
                TextButton(
                  onPressed: () => _deleteProject(project.id),
                  child: const Text('Détails', style: TextStyle(color: Colors.brown)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTag(ProjectStatus status) {
    Color color;
    String label;
    switch (status) {
      case ProjectStatus.planned: color = Colors.blue; label = 'Planifié'; break;
      case ProjectStatus.in_progress: color = Colors.orange; label = 'En cours'; break;
      case ProjectStatus.on_hold: color = Colors.red; label = 'Suspendu'; break;
      case ProjectStatus.completed: color = Colors.green; label = 'Terminé'; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  void _showAddProjectDialog() {
    final titleController = TextEditingController();
    final budgetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau Projet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Titre du projet')),
            TextField(controller: budgetController, decoration: const InputDecoration(labelText: 'Budget estimé (\$)'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isEmpty) return;
              final project = ConstructionProject(
                id: const Uuid().v4(),
                title: titleController.text,
                entityId: ref.read(activeEntityIdProvider),
                budget: double.tryParse(budgetController.text) ?? 0.0,
                startDate: DateTime.now(),
              );
              await ref.read(constructionRepositoryProvider).saveProject(project);
              Navigator.pop(context);
              _loadData();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown.shade700, foregroundColor: Colors.white),
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProject(String id) async {
    await ref.read(constructionRepositoryProvider).deleteProject(id);
    _loadData();
  }
}
