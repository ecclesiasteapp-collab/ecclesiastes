import '../entities/workflow/workflow_instance.dart';

abstract class WorkflowRepository {
  Future<WorkflowInstance> getInstance(String id);
  Future<List<WorkflowInstance>> getInstancesForEntity(String entityId);
  Future<void> saveInstance(WorkflowInstance instance);
  Future<List<WorkflowInstance>> getPendingTasks(String actorRole, String entityId);
}
