import 'package:hive/hive.dart';
import '../domain/repositories/inventory_repository.dart';
import '../domain/entities/inventory_item.dart';
import 'database_service.dart';

class HiveInventoryRepository implements InventoryRepository {
  static const String _boxName = 'inventory';

  @override
  Future<List<InventoryItem>> getItemsForEntity(String entityId) async {
    final box = await DatabaseService.openBox<Map>(_boxName);
    return box.values
        .where((m) => m['entite_id'] == entityId)
        .map((m) => _fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }

  @override
  Future<void> saveItem(InventoryItem item) async {
    final box = await DatabaseService.openBox<Map>(_boxName);
    await box.put(item.id, {
      'id': item.id,
      'name': item.name,
      'category': item.category.name,
      'entite_id': item.entityId,
      'value': item.value,
      'date': item.acquisitionDate.toIso8601String(),
      'condition': item.condition,
    });
  }

  @override
  Future<void> deleteItem(String id) async {
    final box = await DatabaseService.openBox<Map>(_boxName);
    await box.delete(id);
  }

  InventoryItem _fromMap(Map<String, dynamic> m) {
    return InventoryItem(
      id: m['id'] ?? '',
      name: m['name'] ?? '',
      category: InventoryCategory.values.firstWhere(
        (e) => e.name == m['category'],
        orElse: () => InventoryCategory.other,
      ),
      entityId: m['entite_id'] ?? '',
      value: m['value'],
      acquisitionDate: DateTime.tryParse(m['date'] ?? '') ?? DateTime.now(),
      condition: m['condition'],
    );
  }
}
