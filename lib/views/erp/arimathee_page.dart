import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/social_action.dart';
import '../../services/repository_providers.dart';
import '../../providers/scope_provider.dart';
import '../../core/theme.dart';
import '../../models/person_model.dart';
import '../../models/member_profile.dart';
import 'package:uuid/uuid.dart';

class ArimatheePage extends ConsumerStatefulWidget {
  const ArimatheePage({super.key});

  @override
  ConsumerState<ArimatheePage> createState() => _ArimatheePageState();
}

class _ArimatheePageState extends ConsumerState<ArimatheePage> {
  bool _isLoading = true;
  List<SocialAction> _actions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final entityId = ref.read(activeEntityIdProvider);
    final repo = ref.read(socialRepositoryProvider);
    final actions = await repo.getActionsForEntity(entityId);
    
    if (mounted) {
      setState(() {
        _actions = actions..sort((a, b) => b.date.compareTo(a.date));
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arimathée (Action Sociale)'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddActionDialog,
        backgroundColor: Colors.teal.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBody() {
    if (_actions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.volunteer_activism_outlined, size: 80, color: Colors.teal.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text('Aucune action sociale enregistrée', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _showAddActionDialog,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade700, foregroundColor: Colors.white),
              child: const Text('Enregistrer une aide'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _actions.length,
      itemBuilder: (context, index) {
        final action = _actions[index];
        return _buildActionCard(action);
      },
    );
  }

  Widget _buildActionCard(SocialAction action) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getTypeColor(action.type).withOpacity(0.1),
          child: Icon(_getTypeIcon(action.type), color: _getTypeColor(action.type)),
        ),
        title: Text('${action.amount} ${action.currency}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${_getTypeLabel(action.type)} • ${action.date.toString().split(' ')[0]}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(Icons.person, 'Bénéficiaire', action.beneficiaryId), // En réalité on devrait afficher le nom
                const SizedBox(height: 8),
                _buildDetailRow(Icons.description, 'Description', action.description ?? 'Aucune description'),
                const Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => _deleteAction(action.id),
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text('$label : ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
      ],
    );
  }

  void _showAddActionDialog() async {
    final entityId = ref.read(activeEntityIdProvider);
    final members = await ref.read(memberRepositoryProvider).getMembersByEntity(entityId);

    if (!mounted) return;

    if (members.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aucun membre dans cette entité pour bénéficier d\'une aide.')));
       return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir le bénéficiaire'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: members.length,
            itemBuilder: (context, index) {
              final m = members[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text('${m.prenom} ${m.nom}'),
                onTap: () {
                  Navigator.pop(context);
                  _showActionFormDialog(m);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showActionFormDialog(MemberProfile beneficiary) {
    SocialActionType selectedType = SocialActionType.food;
    final amountController = TextEditingController();
    final descController = TextEditingController();
    String currency = 'FC';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Aide pour ${beneficiary.prenom}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<SocialActionType>(
                  value: selectedType,
                  items: SocialActionType.values.map((t) => DropdownMenuItem(value: t, child: Text(_getTypeLabel(t)))).toList(),
                  onChanged: (v) => setDialogState(() => selectedType = v!),
                  decoration: const InputDecoration(labelText: 'Type d\'aide'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Montant'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: currency,
                        items: ['FC', 'USD'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setDialogState(() => currency = v!),
                        decoration: const InputDecoration(labelText: 'Devise'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description / Notes', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () async {
                final amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount <= 0) return;

                final action = SocialAction(
                  id: const Uuid().v4(),
                  beneficiaryId: beneficiary.id,
                  type: selectedType,
                  entityId: ref.read(activeEntityIdProvider),
                  amount: amount,
                  currency: currency,
                  date: DateTime.now(),
                  description: descController.text,
                );

                await ref.read(socialRepositoryProvider).saveAction(action);
                Navigator.pop(context);
                _loadData();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action sociale enregistrée avec succès')));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade700, foregroundColor: Colors.white),
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteAction(String id) async {
    await ref.read(socialRepositoryProvider).deleteAction(id);
    _loadData();
  }

  String _getTypeLabel(SocialActionType type) {
    switch (type) {
      case SocialActionType.health: return 'Santé';
      case SocialActionType.education: return 'Éducation';
      case SocialActionType.food: return 'Alimentation';
      case SocialActionType.housing: return 'Logement';
      case SocialActionType.funeral: return 'Obsèques';
      case SocialActionType.other: return 'Autre';
    }
  }

  IconData _getTypeIcon(SocialActionType type) {
    switch (type) {
      case SocialActionType.health: return Icons.medical_services;
      case SocialActionType.education: return Icons.school;
      case SocialActionType.food: return Icons.restaurant;
      case SocialActionType.housing: return Icons.home;
      case SocialActionType.funeral: return Icons.church;
      case SocialActionType.other: return Icons.volunteer_activism;
    }
  }

  Color _getTypeColor(SocialActionType type) {
    switch (type) {
      case SocialActionType.health: return Colors.red;
      case SocialActionType.education: return Colors.blue;
      case SocialActionType.food: return Colors.orange;
      case SocialActionType.housing: return Colors.brown;
      case SocialActionType.funeral: return Colors.grey;
      case SocialActionType.other: return Colors.teal;
    }
  }
}
