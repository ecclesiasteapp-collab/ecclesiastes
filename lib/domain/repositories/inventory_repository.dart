import '../../domain/entities/inventory_item.dart';

abstract class InventoryRepository {
  Future<List<InventoryItem>> getItemsForEntity(String entityId);
  Future<void> saveItem(InventoryItem item);
  Future<void> deleteItem(String id);
}
