import '../../models/sync_queue_model.dart';

abstract class SyncRepository {
  Future<List<SyncQueueItem>> getPendingItems();
  Future<void> addToQueue(SyncQueueItem item);
  Future<void> updateItem(SyncQueueItem item);
  Future<void> deleteSyncedItems();
  Future<void> clearQueue();
}
