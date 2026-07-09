import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../models/entity_model.dart';
import '../../models/hierarchy_models.dart';
import '../../services/config_service.dart';
import '../../services/database_service.dart';

class EntityManagementPage extends StatefulWidget {
  const EntityManagementPage({super.key});

  @override
  State<EntityManagementPage> createState() => _EntityManagementPageState();
}

class _EntityManagementPageState extends State<EntityManagementPage> {
  late Box<EntityModel> _entityBox;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    _entityBox = await DatabaseService.openBox<EntityModel>('entities_official');
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Entités'),
        backgroundColor: const Color(0xFF1B6B9E),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ValueListenableBuilder(
              valueListenable: _entityBox.listenable(),
              builder: (context, Box<EntityModel> box, _) {
                if (box.isEmpty) {
                  return _buildEmptyState();
                }

                final entities = box.values.toList()
                  ..sort((a, b) => b.niveau.index.compareTo(a.niveau.index));

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: entities.length,
                  itemBuilder: (context, index) {
                    final entity = entities[index];
                    return _buildEntityTile(entity);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEntityDialog(context),
        backgroundColor: const Color(0xFF1B6B9E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_tree_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'Aucune entité créée',
            style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Commencez par ajouter le niveau International.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEntityTile(EntityModel entity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getLevelColor(entity.niveau),
          child: Text(
            entity.code,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(entity.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(_getLevelLabel(entity.niveau)),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () => entity.delete(),
        ),
      ),
    );
  }

  Color _getLevelColor(EntityLevel level) {
    switch (level) {
      case EntityLevel.internationale: return const Color(0xFF003366);
      case EntityLevel.territoriale: return const Color(0xFF1B6B9E);
      case EntityLevel.regionApostolique: return Colors.blue;
      case EntityLevel.champ: return Colors.lightBlue;
      case EntityLevel.district: return Colors.orange;
      case EntityLevel.communaute: return Colors.green;
    }
  }

  String _getLevelLabel(EntityLevel level) {
    final config = ConfigService().levels.firstWhere(
      (l) => l.id == level.name,
      orElse: () => ConfigService().levels.last,
    );
    return config.label;
  }

  void _showAddEntityDialog(BuildContext context) {
    final levels = ConfigService().levels;
    String selectedLevelId = levels.last.id;
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    String? selectedParentId;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final selectedLevel = levels.firstWhere((l) => l.id == selectedLevelId);
          final possibleParents = _entityBox.values
              .where((e) => e.niveau.index > EntityLevel.values.byName(selectedLevelId).index)
              .toList();

          return AlertDialog(
            title: const Text('Nouvelle Entité'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedLevelId,
                    decoration: const InputDecoration(labelText: 'Niveau'),
                    items: levels.map((l) => DropdownMenuItem(
                      value: l.id,
                      child: Text(l.label),
                    )).toList(),
                    onChanged: (val) {
                      setDialogState(() {
                        selectedLevelId = val!;
                        selectedParentId = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  if (selectedLevel.rank > 1)
                    DropdownButtonFormField<String>(
                      value: selectedParentId,
                      decoration: const InputDecoration(labelText: 'Entité Parente'),
                      items: possibleParents.map((e) => DropdownMenuItem(
                        value: e.id,
                        child: Text(e.nom),
                      )).toList(),
                      onChanged: (val) => setDialogState(() => selectedParentId = val),
                    ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nom de l\'entité'),
                  ),
                  TextField(
                    controller: codeController,
                    decoration: const InputDecoration(labelText: 'Code (ex: KIN-01)'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty && codeController.text.isNotEmpty) {
                    final newEntity = EntityModel(
                      id: const Uuid().v4(),
                      nom: nameController.text,
                      code: codeController.text,
                      niveau: EntityLevel.values.byName(selectedLevelId),
                      entiteParentId: selectedParentId,
                    );
                    _entityBox.put(newEntity.id, newEntity);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Créer'),
              ),
            ],
          );
        },
      ),
    );
  }
}
