enum ProjectStatus { planned, in_progress, on_hold, completed }

class ConstructionProject {
  final String id;
  final String title;
  final String entityId;
  final double budget;
  final double spent;
  final double progress; // 0.0 to 1.0
  final ProjectStatus status;
  final DateTime startDate;
  final DateTime? endDate;

  ConstructionProject({
    required this.id,
    required this.title,
    required this.entityId,
    required this.budget,
    this.spent = 0.0,
    this.progress = 0.0,
    this.status = ProjectStatus.planned,
    required this.startDate,
    this.endDate,
  });
}
