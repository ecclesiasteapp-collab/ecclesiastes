import 'package:hive/hive.dart';
part 'sync_queue_model.g.dart';

@HiveType(typeId: 118)
class SyncQueueItem extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String actionType; // ex: 'UPDATE_MEMBER', 'SUBMIT_REPORT'
  @HiveField(2) late String payloadJson;
  @HiveField(3) late DateTime createdAt;
  @HiveField(4) bool isSynced = false;
  
  @HiveField(5) String status = 'pending'; // 'pending', 'syncing', 'synced', 'failed'
  @HiveField(6) int retryCount = 0;
  // @HiveField(7) est maintenant obsolète et ne doit pas être réutilisé.

  @HiveField(8)
  String priority; // ex: 'normal', 'high'

  SyncQueueItem({
    required this.id,
    required this.actionType,
    required this.payloadJson,
    required this.createdAt,
    this.isSynced = false,
    this.status = 'pending',
    this.retryCount = 0,
    this.priority = 'normal',
  });
}

class SyncStatus {
  static const String pending = 'pending';
  static const String syncing = 'syncing';
  static const String synced = 'synced';
  static const String failed = 'failed';
}

