import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/inventory_item.dart';
import '../../services/repository_providers.dart';
import '../../providers/scope_provider.dart';
import '../../core/theme.dart';
import 'package:uuid/uuid.dart';

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  bool _isLoading = true;
  List<InventoryItem> _items = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final entityId = ref.read(activeEntityIdProvider);
    final repo = ref.read(inventoryRepositoryProvider);
    final items = await repo.getItemsForEntity(entityId);
    
    if (mounted) {
      setState(() {
        _items = items;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaire du Patrimoine'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBody() {
    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text('Aucun article inventorié', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _showAddItemDialog,
              child: const Text('Ajouter un article'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(_getCategoryIcon(item.category), color: AppTheme.primary),
            title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${_getCategoryLabel(item.category)} • État: ${item.condition ?? "N/A"}'),
            trailing: Text(item.value != null ? '${item.value} \$' : ''),
            onLongPress: () => _deleteItem(item.id),
          ),
        );
      },
    );
  }

  void _showAddItemDialog() {
    final nameController = TextEditingController();
    final valueController = TextEditingController();
    InventoryCategory selectedCategory = InventoryCategory.furniture;
    String condition = 'Bon';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nouvel Article'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nom de l\'article'),
                ),
                DropdownButtonFormField<InventoryCategory>(
                  value: selectedCategory,
                  items: InventoryCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(_getCategoryLabel(c)))).toList(),
                  onChanged: (v) => setDialogState(() => selectedCategory = v!),
                  decoration: const InputDecoration(labelText: 'Catégorie'),
                ),
                TextField(
                  controller: valueController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Valeur estimée (\$)'),
                ),
                DropdownButtonFormField<String>(
                  value: condition,
                  items: ['Excellent', 'Bon', 'Moyen', 'Mauvais'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setDialogState(() => condition = v!),
                  decoration: const InputDecoration(labelText: 'État'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) return;
                final newItem = InventoryItem(
                  id: const Uuid().v4(),
                  name: nameController.text,
                  category: selectedCategory,
                  entityId: ref.read(activeEntityIdProvider),
                  value: double.tryParse(valueController.text),
                  acquisitionDate: DateTime.now(),
                  condition: condition,
                );
                await ref.read(inventoryRepositoryProvider).saveItem(newItem);
                Navigator.pop(context);
                _loadData();
              },
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteItem(String id) async {
    await ref.read(inventoryRepositoryProvider).deleteItem(id);
    _loadData();
  }

  String _getCategoryLabel(InventoryCategory category) {
    switch (category) {
      case InventoryCategory.building: return 'Bâtiment';
      case InventoryCategory.instrument: return 'Instrument';
      case InventoryCategory.furniture: return 'Mobilier';
      case InventoryCategory.liturgical: return 'Liturgique';
      case InventoryCategory.other: return 'Autre';
    }
  }

  IconData _getCategoryIcon(InventoryCategory category) {
    switch (category) {
      case InventoryCategory.building: return Icons.business;
      case InventoryCategory.instrument: return Icons.music_note;
      case InventoryCategory.furniture: return Icons.chair;
      case InventoryCategory.liturgical: return Icons.church;
      case InventoryCategory.other: return Icons.category;
    }
  }
}
