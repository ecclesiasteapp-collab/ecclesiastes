import '../../domain/models/workflow_models.dart';
import '../../domain/repositories/workflow_repository.dart';
import '../../../../services/database_service.dart';

class HiveWorkflowRepository implements WorkflowRepository {
  @override
  Future<void> saveDefinition(WorkflowDefinition definition) async {
    final box = await DatabaseService.openBox<WorkflowDefinition>(DatabaseService.workflowDefinitionsBoxName);
    await box.put(definition.id, definition);
  }

  @override
  Future<WorkflowDefinition?> getDefinition(String id) async {
    final box = await DatabaseService.openBox<WorkflowDefinition>(DatabaseService.workflowDefinitionsBoxName);
    return box.get(id);
  }

  @override
  Future<List<WorkflowDefinition>> getAllDefinitions() async {
    final box = await DatabaseService.openBox<WorkflowDefinition>(DatabaseService.workflowDefinitionsBoxName);
    return box.values.toList();
  }

  @override
  Future<void> saveInstance(WorkflowInstance instance) async {
    final box = await DatabaseService.openBox<WorkflowInstance>(DatabaseService.workflowInstancesBoxName);
    await box.put(instance.id, instance);
  }

  @override
  Future<WorkflowInstance?> getInstance(String id) async {
    final box = await DatabaseService.openBox<WorkflowInstance>(DatabaseService.workflowInstancesBoxName);
    return box.get(id);
  }

  @override
  Future<List<WorkflowInstance>> getInstancesByEntity(String entityId) async {
    final box = await DatabaseService.openBox<WorkflowInstance>(DatabaseService.workflowInstancesBoxName);
    return box.values.where((i) => i.entityId == entityId).toList();
  }

  @override
  Future<List<WorkflowInstance>> getPendingInstancesForRole(String role) async {
    // This logic would ideally use the definition to see if the current step allows this role
    final box = await DatabaseService.openBox<WorkflowInstance>(DatabaseService.workflowInstancesBoxName);
    return box.values.where((i) => i.status == WorkflowStatus.submitted || i.status == WorkflowStatus.underReview).toList();
  }

  @override
  Future<List<WorkflowInstance>> getUserRequests(String userId) async {
    final box = await DatabaseService.openBox<WorkflowInstance>(DatabaseService.workflowInstancesBoxName);
    return box.values.where((i) => i.initiatorId == userId).toList();
  }
}
