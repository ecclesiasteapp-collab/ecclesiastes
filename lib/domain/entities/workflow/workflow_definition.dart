import '../../entities/ecclesiastical_entity.dart';

class WorkflowDefinition {
  final String id;
  final String name;
  final List<WorkflowStepDefinition> steps;

  WorkflowDefinition({
    required this.id,
    required this.name,
    required this.steps,
  });
}

class WorkflowStepDefinition {
  final String id;
  final String label;
  final List<String> allowedRoles; // Roles that can act at this step
  final EntityLevel targetLevel; // Level at which the action is performed

  WorkflowStepDefinition({
    required this.id,
    required this.label,
    required this.allowedRoles,
    required this.targetLevel,
  });
}
