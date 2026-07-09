import '../entities/workflow/workflow_instance.dart';
import '../repositories/workflow_repository.dart';

class ValidateWorkflowTask {
  final WorkflowRepository repository;

  ValidateWorkflowTask(this.repository);

  Future<void> execute({
    required String instanceId,
    required String actorId,
    required WorkflowStatus action, // approved or rejected
    String? comment,
  }) async {
    final instance = await repository.getInstance(instanceId);
    
    final newLog = WorkflowLog(
      stepId: instance.currentStepId,
      actorId: actorId,
      action: action,
      timestamp: DateTime.now(),
      comment: comment,
    );

    final updatedHistory = List<WorkflowLog>.from(instance.history)..add(newLog);

    final updatedInstance = WorkflowInstance(
      id: instance.id,
      definitionId: instance.definitionId,
      entityId: instance.entityId,
      initiatorId: instance.initiatorId,
      status: action, // Simplified: status reflects last action for now
      currentStepId: instance.currentStepId, // Could move to next step in a real engine
      data: instance.data,
      history: updatedHistory,
    );

    await repository.saveInstance(updatedInstance);
  }
}
