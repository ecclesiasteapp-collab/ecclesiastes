import '../entities/workflow/workflow_instance.dart';
import '../repositories/workflow_repository.dart';

class SubmitReportWorkflow {
  final WorkflowRepository repository;

  SubmitReportWorkflow(this.repository);

  Future<void> execute({
    required String reportType, // e.g., "SACRISTIE"
    required String entityId,
    required String initiatorId,
    required Map<String, dynamic> reportData,
  }) async {
    final instance = WorkflowInstance(
      id: "REP_${reportType}_${DateTime.now().millisecondsSinceEpoch}",
      definitionId: reportType,
      entityId: entityId,
      initiatorId: initiatorId,
      status: WorkflowStatus.submitted,
      currentStepId: "VALIDATION_RESPONSABLE", // Hardcoded first step for now
      data: reportData,
      history: [
        WorkflowLog(
          stepId: "SUBMISSION",
          actorId: initiatorId,
          action: WorkflowStatus.submitted,
          timestamp: DateTime.now(),
          comment: "Initial submission",
        )
      ],
    );

    await repository.saveInstance(instance);
  }
}
