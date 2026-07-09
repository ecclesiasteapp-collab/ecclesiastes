import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../config/organization_config.dart';
import '../models/commission_node.dart';
import '../models/hierarchy_models.dart';

class CommissionsPage extends StatefulWidget {
  const CommissionsPage({super.key});

  @override
  State<CommissionsPage> createState() => _CommissionsPageState();
}

class _CommissionsPageState extends State<CommissionsPage> {
  late Box<CommissionNode> _commissionBox;
  List<CommissionNode> _commissions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCommissions();
  }

  Future<void> _loadCommissions() async {
    setState(() => _loading = true);
    _commissionBox = Hive.box<CommissionNode>('commissions_box');
    if (mounted) {
      setState(() {
        _commissions = _commissionBox.values.toList();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        title: const Text('Commissions'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showCreateCommissionDialog),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _commissions.isEmpty
              ? const Center(
                  child: Text('Aucune commission',
                      style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _commissions.length,
                  itemBuilder: (context, index) =>
                      _buildCommissionCard(_commissions[index]),
                ),
    );
  }

  Widget _buildCommissionCard(CommissionNode commission) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getCommissionColor(commission.type),
          child: Icon(_getCommissionIcon(commission.type), color: Colors.white),
        ),
        title: Text(_getCommissionName(commission.type),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
            'Niveau: ${_getLevelName(commission.level)} • ${commission.entityId}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteCommission(commission),
        ),
      ),
    );
  }

  Color _getCommissionColor(CommissionType type) {
    switch (type) {
      case CommissionType.ecodim:
        return Colors.purple;
      case CommissionType.econfi:
        return Colors.blue;
      case CommissionType.jeunesse:
        return Colors.green;
      case CommissionType.musique:
        return Colors.orange;
      case CommissionType.papas:
        return Colors.lightBlue;
      case CommissionType.mamans:
        return Colors.pinkAccent;
      case CommissionType.aines:
        return Colors.brown;
      case CommissionType.presseMediasSonorisation:
        return Colors.pink;
      case CommissionType.josephArimathee:
        return Colors.deepPurple;
      case CommissionType.securiteProtocole:
        return Colors.grey;
      case CommissionType.medicale:
        return Colors.red;
      case CommissionType.construction:
        return Colors.indigo;
      case CommissionType.sacristie:
        return Colors.amber;
      case CommissionType.none:
        return Colors.grey;
    }
  }

  IconData _getCommissionIcon(CommissionType type) {
    switch (type) {
      case CommissionType.ecodim:
        return Icons.child_care;
      case CommissionType.econfi:
        return Icons.school;
      case CommissionType.jeunesse:
        return Icons.people;
      case CommissionType.musique:
        return Icons.music_note;
      case CommissionType.papas:
        return Icons.man;
      case CommissionType.mamans:
        return Icons.woman;
      case CommissionType.aines:
        return Icons.person;
      case CommissionType.presseMediasSonorisation:
        return Icons.campaign;
      case CommissionType.josephArimathee:
        return Icons.church;
      case CommissionType.securiteProtocole:
        return Icons.security;
      case CommissionType.medicale:
        return Icons.local_hospital;
      case CommissionType.construction:
        return Icons.build;
      case CommissionType.sacristie:
        return Icons.inventory;
      case CommissionType.none:
        return Icons.block;
    }
  }


  String _getCommissionName(CommissionType type) {
    if (type == CommissionType.sacristie) {
      return 'Sacristie';
    }
    if (type == CommissionType.none) {
      return 'Aucune';
    }
    return OrganizationConfig.getCommission(type).name;
  }

  String _getLevelName(EntityLevel level) {
    switch (level) {
      case EntityLevel.communaute:
        return 'Communauté';
      case EntityLevel.district:
        return 'District';
      case EntityLevel.champ:
        return 'Champ Apostolique';
      case EntityLevel.regionApostolique:
        return 'Région Apostolique';
      case EntityLevel.territoriale:
        return 'Territoriale';
      case EntityLevel.internationale:
        return 'Internationale';
    }
  }

  Future<void> _deleteCommission(CommissionNode commission) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ?'),
        content: Text('Supprimer ${_getCommissionName(commission.type)} ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Supprimer')),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _commissionBox.delete(commission.id);
      await _loadCommissions();
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Supprimée')));
      }
    }
  }

  void _showCreateCommissionDialog() {
    CommissionType selectedType = CommissionType.ecodim;
    EntityLevel selectedLevel = EntityLevel.communaute;
    final entityIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Nouvelle Commission'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<CommissionType>(
                  initialValue: selectedType,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: CommissionType.values
                      .where((t) => t != CommissionType.none)
                      .map((type) {
                    return DropdownMenuItem(
                        value: type, child: Text(_getCommissionName(type)));
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedType = value!);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<EntityLevel>(
                  initialValue: selectedLevel,
                  decoration: const InputDecoration(labelText: 'Niveau'),
                  items: EntityLevel.values.map((level) {
                    return DropdownMenuItem(
                        value: level, child: Text(_getLevelName(level)));
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedLevel = value!);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: entityIdController,
                  decoration: const InputDecoration(
                      labelText: 'ID Entité', hintText: 'Ex: CTE_JEREMIE'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () async {
                if (entityIdController.text.isEmpty) return;
                final newCommission = CommissionNode(
                  id: 'comm_${DateTime.now().millisecondsSinceEpoch}',
                  type: selectedType,
                  level: selectedLevel,
                  entityId: entityIdController.text,
                );
                await _commissionBox.put(newCommission.id, newCommission);
                await _loadCommissions();
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Créer'),
            ),
          ],
        ),
      ),
    );
  }
}

