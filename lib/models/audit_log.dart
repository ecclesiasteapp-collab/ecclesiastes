import 'package:hive/hive.dart';

part 'audit_log.g.dart';

@HiveType(typeId: 102)
class AuditLog extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String adminId;
  @HiveField(2) late String actionType;
  @HiveField(3) late String targetType;
  @HiveField(4) late String targetId;
  @HiveField(5) late String changesJson; // Map stored as JSON string
  @HiveField(6) late DateTime timestamp;

  AuditLog({
    required this.id,
    required this.adminId,
    required this.actionType,
    required this.targetType,
    required this.targetId,
    required this.changesJson,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

