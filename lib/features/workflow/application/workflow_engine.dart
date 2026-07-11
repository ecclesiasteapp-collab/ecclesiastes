import '../domain/models/workflow_models.dart';
import '../domain/repositories/workflow_repository.dart';
import '../../../../models/hierarchy_models.dart';
import 'package:uuid/uuid.dart';

class WorkflowEngine {
  final WorkflowRepository _repository;
  final _uuid = const Uuid();

  WorkflowEngine(this._repository);

  /// Starts a new workflow instance based on a definition.
  Future<WorkflowInstance> startProcess({
    required String definitionId,
    required String initiatorId,
    required String entityId,
    required Map<String, dynamic> data,
  }) async {
    final definition = await _repository.getDefinition(definitionId);
    if (definition == null) throw Exception('Workflow definition not found');

    final instance = WorkflowInstance(
      id: _uuid.v4(),
      definitionId: definitionId,
      initiatorId: initiatorId,
      entityId: entityId,
      data: data,
      currentStepOrder: 0,
      status: WorkflowStatus.submitted,
      history: [
        WorkflowHistoryEntry(
          userId: initiatorId,
          userName: 'System', // Should be fetched from user service
          action: 'SUBMIT',
          timestamp: DateTime.now(),
          comment: 'Process started',
        )
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _repository.saveInstance(instance);
    return instance;
  }

  /// Approves the current step of a workflow instance.
  Future<WorkflowInstance> approveStep({
    required String instanceId,
    required String userId,
    required String userName,
    String? comment,
    String? signaturePath,
  }) async {
    final instance = await _repository.getInstance(instanceId);
    if (instance == null) throw Exception('Workflow instance not found');

    final definition = await _repository.getDefinition(instance.definitionId);
    if (definition == null) throw Exception('Workflow definition not found');

    final currentStep = definition.steps.firstWhere((s) => s.order == instance.currentStepOrder);
    
    // Check if it's the last step
    final isLastStep = instance.currentStepOrder >= definition.steps.length - 1;
    
    final newHistory = List<WorkflowHistoryEntry>.from(instance.history)
      ..add(WorkflowHistoryEntry(
        userId: userId,
        userName: userName,
        action: 'APPROVE',
        comment: comment,
        timestamp: DateTime.now(),
        signaturePath: signaturePath,
      ));

    final updatedInstance = instance.copyWith(
      currentStepOrder: isLastStep ? instance.currentStepOrder : instance.currentStepOrder + 1,
      status: isLastStep ? WorkflowStatus.approved : WorkflowStatus.underReview,
      history: newHistory,
      updatedAt: DateTime.now(),
    );

    await _repository.saveInstance(updatedInstance);
    
    if (isLastStep) {
      await _executeWorkflowEffects(updatedInstance);
    }

    return updatedInstance;
  }

  /// Rejects the workflow instance.
  Future<WorkflowInstance> reject({
    required String instanceId,
    required String userId,
    required String userName,
    required String reason,
  }) async {
    final instance = await _repository.getInstance(instanceId);
    if (instance == null) throw Exception('Workflow instance not found');

    final newHistory = List<WorkflowHistoryEntry>.from(instance.history)
      ..add(WorkflowHistoryEntry(
        userId: userId,
        userName: userName,
        action: 'REJECT',
        comment: reason,
        timestamp: DateTime.now(),
      ));

    final updatedInstance = instance.copyWith(
      status: WorkflowStatus.rejected,
      history: newHistory,
      updatedAt: DateTime.now(),
    );

    await _repository.saveInstance(updatedInstance);
    return updatedInstance;
  }

  /// Finalizes the business logic once the workflow is approved.
  Future<void> _executeWorkflowEffects(WorkflowInstance instance) async {
    // Here we would call other services based on instance.definitionId
    // e.g., if (definitionId == 'member_creation') { memberService.create(...) }
    
    final finalInstance = instance.copyWith(
      status: WorkflowStatus.executed,
      updatedAt: DateTime.now(),
    );
    await _repository.saveInstance(finalInstance);
  }
}
