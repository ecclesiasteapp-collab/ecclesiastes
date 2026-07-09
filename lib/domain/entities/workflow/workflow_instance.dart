enum WorkflowStatus { draft, submitted, inReview, approved, rejected }

class WorkflowInstance {
  final String id;
  final String definitionId; // Type de rapport (ex: "SACRISTIE")
  final String entityId;     // Entité concernée
  final String initiatorId;  // Personne qui a créé
  final WorkflowStatus status;
  final String currentStepId;
  final Map<String, dynamic> data; // Les données du rapport
  final List<WorkflowLog> history;

  WorkflowInstance({
    required this.id,
    required this.definitionId,
    required this.entityId,
    required this.initiatorId,
    this.status = WorkflowStatus.draft,
    required this.currentStepId,
    required this.data,
    this.history = const [],
  });
}

class WorkflowLog {
  final String stepId;
  final String actorId;
  final WorkflowStatus action;
  final DateTime timestamp;
  final String? comment;
  final String? signatureHash; // Digital signature link or hash

  WorkflowLog({
    required this.stepId,
    required this.actorId,
    required this.action,
    required this.timestamp,
    this.comment,
    this.signatureHash,
  });
}
