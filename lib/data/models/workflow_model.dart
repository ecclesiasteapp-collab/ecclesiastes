import 'package:hive/hive.dart';
import '../../domain/entities/workflow/workflow_instance.dart';

part 'workflow_model.g.dart';

@HiveType(typeId: 253)
class WorkflowInstanceModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String definitionId;
  @HiveField(2)
  final String entityId;
  @HiveField(3)
  final String initiatorId;
  @HiveField(4)
  final int statusIndex;
  @HiveField(5)
  final String currentStepId;
  @HiveField(6)
  final Map<dynamic, dynamic> data;
  @HiveField(7)
  final List<WorkflowLogModel> history;

  WorkflowInstanceModel({
    required this.id,
    required this.definitionId,
    required this.entityId,
    required this.initiatorId,
    required this.statusIndex,
    required this.currentStepId,
    required this.data,
    required this.history,
  });

  factory WorkflowInstanceModel.fromEntity(WorkflowInstance instance) {
    return WorkflowInstanceModel(
      id: instance.id,
      definitionId: instance.definitionId,
      entityId: instance.entityId,
      initiatorId: instance.initiatorId,
      statusIndex: instance.status.index,
      currentStepId: instance.currentStepId,
      data: instance.data,
      history: instance.history.map((l) => WorkflowLogModel.fromEntity(l)).toList(),
    );
  }

  WorkflowInstance toEntity() {
    return WorkflowInstance(
      id: id,
      definitionId: definitionId,
      entityId: entityId,
      initiatorId: initiatorId,
      status: WorkflowStatus.values[statusIndex],
      currentStepId: currentStepId,
      data: Map<String, dynamic>.from(data),
      history: history.map((l) => l.toEntity()).toList(),
    );
  }
}

@HiveType(typeId: 254)
class WorkflowLogModel extends HiveObject {
  @HiveField(0)
  final String stepId;
  @HiveField(1)
  final String actorId;
  @HiveField(2)
  final int actionIndex;
  @HiveField(3)
  final DateTime timestamp;
  @HiveField(4)
  final String? comment;
  @HiveField(5)
  final String? signatureHash;

  WorkflowLogModel({
    required this.stepId,
    required this.actorId,
    required this.actionIndex,
    required this.timestamp,
    this.comment,
    this.signatureHash,
  });

  factory WorkflowLogModel.fromEntity(WorkflowLog log) {
    return WorkflowLogModel(
      stepId: log.stepId,
      actorId: log.actorId,
      actionIndex: log.action.index,
      timestamp: log.timestamp,
      comment: log.comment,
      signatureHash: log.signatureHash,
    );
  }

  WorkflowLog toEntity() {
    return WorkflowLog(
      stepId: stepId,
      actorId: actorId,
      action: WorkflowStatus.values[actionIndex],
      timestamp: timestamp,
      comment: comment,
      signatureHash: signatureHash,
    );
  }
}
