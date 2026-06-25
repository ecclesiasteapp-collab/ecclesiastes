import 'package:hive/hive.dart';

part 'modification_request.g.dart';

@HiveType(typeId: 109)
enum ModificationStatus {
  @HiveField(0) pending,
  @HiveField(1) approved,
  @HiveField(2) rejected,
  @HiveField(3) inProgress,
  @HiveField(4) completed,
}

@HiveType(typeId: 111)
class ModificationRequest extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String ministerId;

  @HiveField(2)
  final String ministerName;

  @HiveField(3)
  final String resourceType;

  @HiveField(4)
  final String resourceId;

  @HiveField(5)
  final String request;

  @HiveField(6)
  final ModificationStatus status;

  @HiveField(7)
  final DateTime createdAt;

  ModificationRequest({
    required this.id,
    required this.ministerId,
    required this.ministerName,
    required this.resourceType,
    required this.resourceId,
    required this.request,
    required this.status,
    required this.createdAt,
  });
}
