import 'package:hive/hive.dart';
import '../domain/repositories/sync_repository.dart';
import '../models/sync_queue_model.dart';
import 'database_service.dart';

class HiveSyncRepository implements SyncRepository {
  static const String _boxName = 'sync_queue';

  @override
  Future<List<SyncQueueItem>> getPendingItems() async {
    final box = await DatabaseService.openBox<SyncQueueItem>(_boxName);
    return box.values.where((item) => item.status != SyncStatus.synced).toList()
      ..sort((a, b) {
        // High priority first, then older first
        if (a.priority == 'high' && b.priority != 'high') return -1;
        if (a.priority != 'high' && b.priority == 'high') return 1;
        return a.createdAt.compareTo(b.createdAt);
      });
  }

  @override
  Future<void> addToQueue(SyncQueueItem item) async {
    final box = await DatabaseService.openBox<SyncQueueItem>(_boxName);
    await box.put(item.id, item);
  }

  @override
  Future<void> updateItem(SyncQueueItem item) async {
    final box = await DatabaseService.openBox<SyncQueueItem>(_boxName);
    await box.put(item.id, item);
  }

  @override
  Future<void> deleteSyncedItems() async {
    final box = await DatabaseService.openBox<SyncQueueItem>(_boxName);
    final syncedKeys = box.keys.where((key) => box.get(key)?.status == SyncStatus.synced);
    await box.deleteAll(syncedKeys);
  }

  @override
  Future<void> clearQueue() async {
    final box = await DatabaseService.openBox<SyncQueueItem>(_boxName);
    await box.clear();
  }
}
