import 'dart:convert';
import 'package:hive/hive.dart';

part 'sync_queue.g.dart';

@HiveType(typeId: 7)
class SyncQueue extends HiveObject {
  @HiveField(0)
  late String reportType;
  @HiveField(1)
  late String communityId;
  @HiveField(2)
  late String dataJson;

  Map<String, dynamic> get data => jsonDecode(dataJson);
  set data(Map<String, dynamic> value) => dataJson = jsonEncode(value);

  @HiveField(3)
  late String status; // 'pending', 'syncing', 'synced', 'failed'
  @HiveField(4)
  late DateTime createdAt;
  @HiveField(5)
  late String userId;
  @HiveField(6)
  int retryCount = 0;
  @HiveField(7)
  String? physicalProofPath;
  @HiveField(8)
  String? serverReportId;

  SyncQueue({
    required this.reportType,
    required this.communityId,
    required this.dataJson,
    required this.userId,
    this.status = 'pending',
    DateTime? createdAtParam,
  }) : createdAt = createdAtParam ?? DateTime.now();

  factory SyncQueue.fromData({
    required String reportType,
    required String communityId,
    required Map<String, dynamic> data,
    required String userId,
    String status = 'pending',
    DateTime? createdAt,
  }) {
    return SyncQueue(
      reportType: reportType,
      communityId: communityId,
      dataJson: jsonEncode(data),
      userId: userId,
      status: status,
      createdAtParam: createdAt,
    );
  }
}
