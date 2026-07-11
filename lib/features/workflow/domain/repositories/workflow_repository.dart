import '../models/workflow_models.dart';

abstract class WorkflowRepository {
  // Definitions
  Future<void> saveDefinition(WorkflowDefinition definition);
  Future<WorkflowDefinition?> getDefinition(String id);
  Future<List<WorkflowDefinition>> getAllDefinitions();

  // Instances
  Future<void> saveInstance(WorkflowInstance instance);
  Future<WorkflowInstance?> getInstance(String id);
  Future<List<WorkflowInstance>> getInstancesByEntity(String entityId);
  Future<List<WorkflowInstance>> getPendingInstancesForRole(String role);
  Future<List<WorkflowInstance>> getUserRequests(String userId);
}
