import 'package:hive/hive.dart';
import 'hierarchy_models.dart';

part 'commission_node.g.dart';

@HiveType(typeId: 15)
class CommissionNode extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late CommissionType type;
  @HiveField(2) late EntityLevel level;
  @HiveField(3) late String entityId;
  @HiveField(4) String? parentId;
  @HiveField(5) String? leaderId;
  @HiveField(6) double kpiScore;
  @HiveField(7) int pendingReports;

  CommissionNode({
    required this.id,
    required this.type,
    required this.level,
    required this.entityId,
    this.parentId,
    this.leaderId,
    this.kpiScore = 0.0,
    this.pendingReports = 0,
  });
}

