import 'package:hive/hive.dart';
import '../../domain/entities/workflow/workflow_instance.dart';
import '../../domain/repositories/workflow_repository.dart';
import '../models/workflow_model.dart';

class HiveWorkflowRepository implements WorkflowRepository {
  static const String workflowsBoxName = 'erp_workflows';

  Future<Box<WorkflowInstanceModel>> get _workflowsBox =>
      Hive.openBox<WorkflowInstanceModel>(workflowsBoxName);

  @override
  Future<WorkflowInstance> getInstance(String id) async {
    final box = await _workflowsBox;
    final model = box.get(id);
    if (model == null) throw Exception('Workflow instance not found: $id');
    return model.toEntity();
  }

  @override
  Future<List<WorkflowInstance>> getInstancesForEntity(String entityId) async {
    final box = await _workflowsBox;
    return box.values
        .where((w) => w.entityId == entityId)
        .map((w) => w.toEntity())
        .toList();
  }

  @override
  Future<void> saveInstance(WorkflowInstance instance) async {
    final box = await _workflowsBox;
    await box.put(instance.id, WorkflowInstanceModel.fromEntity(instance));
  }

  @override
  Future<List<WorkflowInstance>> getPendingTasks(String actorRole, String entityId) async {
    final box = await _workflowsBox;
    // Simple filter logic: in reality, this depends on the workflow definition
    return box.values
        .where((w) => w.statusIndex == WorkflowStatus.submitted.index || w.statusIndex == WorkflowStatus.inReview.index)
        .map((w) => w.toEntity())
        .toList();
  }
}
