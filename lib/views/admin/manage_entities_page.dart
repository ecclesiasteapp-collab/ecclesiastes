import 'package:flutter/material.dart';
import 'package:ecclesiaste/services/database_helper.dart';

class ManageEntitiesPage extends StatefulWidget {
  const ManageEntitiesPage({super.key});

  @override
  State<ManageEntitiesPage> createState() => _ManageEntitiesPageState();
}

class _ManageEntitiesPageState extends State<ManageEntitiesPage> {
  List<Map<String, dynamic>> _entities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEntities();
  }

  Future<void> _loadEntities() async {
    setState(() => _isLoading = true);
    final entities = await DatabaseHelper.instance.getAllEntites();
    if (!mounted) {
      return;
    }
    setState(() {
      _entities = entities;
      _isLoading = false;
    });
  }

  void _addEntity() {
    final TextEditingController nameController = TextEditingController();
    String selectedType = 'COMMUNAUTE';
    String? selectedParentId;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Ajouter une Entité'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Nom de l'entité"),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  items: ['CHAMP_APOSTOLIQUE', 'DISTRICT', 'COMMUNAUTE']
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedType = value);
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Type'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String?>(
                  initialValue: selectedParentId,
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Aucun (Racine)'),
                    ),
                    ..._entities.map(
                      (e) => DropdownMenuItem(
                        value: e['id'],
                        child: Text(e['nom']),
                      ),
                    ),
                  ],
                  onChanged: (value) => setDialogState(() => selectedParentId = value),
                  decoration: const InputDecoration(labelText: 'Entité Parente'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(dialogContext);
                final id = 'ent_${DateTime.now().millisecondsSinceEpoch}';
                await DatabaseHelper.instance.insertEntite(
                  id: id,
                  nom: nameController.text,
                  type: selectedType,
                  parentId: selectedParentId,
                );
                if (!mounted) {
                  return;
                }
                navigator.pop();
                if (!mounted) {
                  return;
                }
                _loadEntities();
              },
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }

  void _editEntity(Map<String, dynamic> entity) {
    final TextEditingController nameController = TextEditingController(
      text: entity['nom'],
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Modifier ${entity['nom']}'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: "Nom de l'entité"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(dialogContext);
              final updatedEntity = Map<String, dynamic>.from(entity);
              updatedEntity['nom'] = nameController.text;
              await DatabaseHelper.instance.updateEntite(entity['id'], updatedEntity);
              if (!mounted) {
                return;
              }
              navigator.pop();
              if (!mounted) {
                return;
              }
              _loadEntities();
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _deleteEntity(Map<String, dynamic> entity) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Supprimer l'entité"),
        content: Text(
          'Voulez-vous vraiment supprimer ${entity['nom']} ? Cela pourrait affecter la hiérarchie.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(dialogContext);
              await DatabaseHelper.instance.deleteEntite(entity['id']);
              if (!mounted) {
                return;
              }
              navigator.pop();
              if (!mounted) {
                return;
              }
              _loadEntities();
            },
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion de la Hiérarchie'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _entities.length,
              itemBuilder: (context, index) {
                final entity = _entities[index];
                return ListTile(
                  leading: const Icon(Icons.account_tree, color: Colors.deepPurple),
                  title: Text(entity['nom']),
                  subtitle: Text(entity['type']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editEntity(entity),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteEntity(entity),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEntity,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

