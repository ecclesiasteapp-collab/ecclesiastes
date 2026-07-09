import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../entities/workflow/workflow_instance.dart';
import '../repositories/workflow_repository.dart';

class SignWorkflowStep {
  final WorkflowRepository repository;

  SignWorkflowStep(this.repository);

  Future<void> execute({
    required String instanceId,
    required String actorId,
    required String comment,
  }) async {
    final instance = await repository.getInstance(instanceId);
    
    // Generate a unique hash for this signature
    final String dataToHash = "$actorId|${instance.id}|${DateTime.now().toIso8601String()}";
    final String hash = sha256.convert(utf8.encode(dataToHash)).toString();

    final newLog = WorkflowLog(
      stepId: instance.currentStepId,
      actorId: actorId,
      action: WorkflowStatus.approved,
      timestamp: DateTime.now(),
      comment: comment,
      signatureHash: hash, // This is the "Electronic Seal"
    );

    final updatedHistory = List<WorkflowLog>.from(instance.history)..add(newLog);

    final updatedInstance = WorkflowInstance(
      id: instance.id,
      definitionId: instance.definitionId,
      entityId: instance.entityId,
      initiatorId: instance.initiatorId,
      status: WorkflowStatus.approved,
      currentStepId: "COMPLETED", // End of flow for this simplified example
      data: instance.data,
      history: updatedHistory,
    );

    await repository.saveInstance(updatedInstance);
  }
}
