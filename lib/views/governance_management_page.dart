import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/person_model.dart';
import '../models/hierarchy_models.dart';
import '../models/ordination_model.dart';
import '../models/nomination_model.dart';
import '../services/repository_providers.dart';
import '../services/person_service.dart';
import '../core/theme.dart';
import 'package:uuid/uuid.dart';

class GovernanceManagementPage extends ConsumerStatefulWidget {
  final String personId;

  const GovernanceManagementPage({super.key, required this.personId});

  @override
  ConsumerState<GovernanceManagementPage> createState() => _GovernanceManagementPageState();
}

class _GovernanceManagementPageState extends ConsumerState<GovernanceManagementPage> {
  final PersonService _personService = PersonService.instance;
  Person? _person;
  List<Ordination> _ordinations = [];
  List<Nomination> _nominations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final person = _personService.getPerson(widget.personId);
    final govRepo = ref.read(governanceRepositoryProvider);
    
    final ords = await govRepo.getOrdinationsForPerson(widget.personId);
    final noms = await govRepo.getNominationsForPerson(widget.personId);

    if (mounted) {
      setState(() {
        _person = person;
        _ordinations = ords;
        _nominations = noms;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_person == null) return const Scaffold(body: Center(child: Text('Personne introuvable')));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gouvernance & Mandats'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPersonHeader(),
          const SizedBox(height: 24),
          _buildActionCard(
            title: 'Nouvelle Ordination',
            subtitle: 'Changer le rang ministériel (ex: Prêtre, Apôtre)',
            icon: Icons.workspace_premium,
            color: Colors.amber.shade800,
            onTap: () => _showOrdinationDialog(),
          ),
          ..._ordinations.map((o) => ListTile(
            title: Text(o.rank.name.toUpperCase()),
            subtitle: Text('Le ${o.date.toString().split(' ')[0]}'),
            leading: const Icon(Icons.star, color: Colors.amber),
          )),
          const SizedBox(height: 16),
          _buildActionCard(
            title: 'Nouvelle Nomination',
            subtitle: 'Assigner une fonction (ex: Responsable de communauté)',
            icon: Icons.assignment_ind,
            color: Colors.teal,
            onTap: () => _showNominationDialog(),
          ),
          ..._nominations.map((n) => ListTile(
            title: Text(n.functionName),
            subtitle: Text('Depuis le ${n.startDate.toString().split(' ')[0]} (${n.type})'),
            leading: const Icon(Icons.work, color: Colors.teal),
          )),
          const SizedBox(height: 16),
          _buildActionCard(
            title: 'Mutation / Transfert',
            subtitle: 'Changer l\'entité de rattachement',
            icon: Icons.swap_horiz,
            color: Colors.blue,
            onTap: () {
              // Appeler le service de mutation existant ou nouveau
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPersonHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: AppTheme.primary.withOpacity(0.1),
          child: const Icon(Icons.person, color: AppTheme.primary, size: 30),
        ),
        const SizedBox(height: 8),
        Text(_person!.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('ID: ${_person!.ecclesiasticalId}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  void _showOrdinationDialog() {
    UserRole selectedRole = UserRole.diacre;
    final dateController = TextEditingController(text: DateTime.now().toString().split(' ')[0]);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Enregistrer une Ordination'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<UserRole>(
                value: selectedRole,
                items: UserRole.values.map((r) => DropdownMenuItem(value: r, child: Text(r.name))).toList(),
                onChanged: (v) => setDialogState(() => selectedRole = v!),
                decoration: const InputDecoration(labelText: 'Nouveau Rang'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Date d\'effet', suffixIcon: Icon(Icons.calendar_today)),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setDialogState(() => dateController.text = date.toString().split(' ')[0]);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () async {
                final ordination = Ordination(
                  id: const Uuid().v4(),
                  personId: _person!.id,
                  rank: selectedRole,
                  date: DateTime.parse(dateController.text),
                  entityId: _person!.currentEntityId,
                );
                await ref.read(governanceRepositoryProvider).saveOrdination(ordination);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ordination enregistrée')));
                _loadData();
              },
              child: const Text('Valider'),
            ),
          ],
        ),
      ),
    );
  }

  void _showNominationDialog() {
    String functionName = '';
    String type = 'Titulaire';
    final dateController = TextEditingController(text: DateTime.now().toString().split(' ')[0]);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nouvelle Nomination'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nom de la fonction (ex: Secrétaire)'),
                onChanged: (v) => functionName = v,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: type,
                items: ['Titulaire', 'Adjoint', 'Intérim'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setDialogState(() => type = v!),
                decoration: const InputDecoration(labelText: 'Type de mandat'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () async {
                if (functionName.isEmpty) return;
                final nomination = Nomination(
                  id: const Uuid().v4(),
                  personId: _person!.id,
                  functionName: functionName,
                  entityId: _person!.currentEntityId,
                  type: type,
                  startDate: DateTime.parse(dateController.text),
                );
                await ref.read(governanceRepositoryProvider).saveNomination(nomination);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nomination enregistrée')));
                _loadData();
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
