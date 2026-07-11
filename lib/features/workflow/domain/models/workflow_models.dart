import 'package:hive/hive.dart';
import '../../../../models/hierarchy_models.dart';

part 'workflow_models.g.dart';

@HiveType(typeId: 240)
enum WorkflowStatus {
  @HiveField(0) draft,
  @HiveField(1) submitted,
  @HiveField(2) underReview,
  @HiveField(3) approved,
  @HiveField(4) rejected,
  @HiveField(5) executed,
  @HiveField(6) cancelled,
}

@HiveType(typeId: 241)
class WorkflowDefinition extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String name;
  @HiveField(2) final String description;
  @HiveField(3) final List<WorkflowStepDefinition> steps;
  @HiveField(4) final String targetEntityType; // 'member', 'minister', 'finance', etc.

  WorkflowDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.steps,
    required this.targetEntityType,
  });
}

@HiveType(typeId: 242)
class WorkflowStepDefinition extends HiveObject {
  @HiveField(0) final int order;
  @HiveField(1) final String label;
  @HiveField(2) final List<UserRole> allowedRoles;
  @HiveField(3) final bool requiresSignature;
  @HiveField(4) final bool isFinal;

  WorkflowStepDefinition({
    required this.order,
    required this.label,
    required this.allowedRoles,
    this.requiresSignature = false,
    this.isFinal = false,
  });
}

@HiveType(typeId: 243)
class WorkflowInstance extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String definitionId;
  @HiveField(2) final String initiatorId;
  @HiveField(3) final String entityId; // The entity scope (Community, District, etc.)
  @HiveField(4) final Map<String, dynamic> data; // The payload of the request
  @HiveField(5) final int currentStepOrder;
  @HiveField(6) final WorkflowStatus status;
  @HiveField(7) final List<WorkflowHistoryEntry> history;
  @HiveField(8) final DateTime createdAt;
  @HiveField(9) final DateTime updatedAt;

  WorkflowInstance({
    required this.id,
    required this.definitionId,
    required this.initiatorId,
    required this.entityId,
    required this.data,
    required this.currentStepOrder,
    required this.status,
    required this.history,
    required this.createdAt,
    required this.updatedAt,
  });

  WorkflowInstance copyWith({
    int? currentStepOrder,
    WorkflowStatus? status,
    List<WorkflowHistoryEntry>? history,
    DateTime? updatedAt,
    Map<String, dynamic>? data,
  }) {
    return WorkflowInstance(
      id: id,
      definitionId: definitionId,
      initiatorId: initiatorId,
      entityId: entityId,
      data: data ?? this.data,
      currentStepOrder: currentStepOrder ?? this.currentStepOrder,
      status: status ?? this.status,
      history: history ?? this.history,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@HiveType(typeId: 244)
class WorkflowHistoryEntry extends HiveObject {
  @HiveField(0) final String userId;
  @HiveField(1) final String userName;
  @HiveField(2) final String action; // 'APPROVE', 'REJECT', 'REQUEST_CHANGES'
  @HiveField(3) final String? comment;
  @HiveField(4) final DateTime timestamp;
  @HiveField(5) final String? signaturePath;

  WorkflowHistoryEntry({
    required this.userId,
    required this.userName,
    required this.action,
    this.comment,
    required this.timestamp,
    this.signaturePath,
  });
}
