enum MandateType {
  ordination,   // Ministères (Diacre, Prêtre, etc.)
  mandatement,  // Missions spécifiques (Coordinateur, etc.)
  nomination,   // Fonctions d'assistance (Adjoint, etc.)
  affectation,  // Fonctions administratives (Trésorier, etc.)
}

class Mandate {
  final String id;
  final String personId;
  final String entityId;
  final MandateType type;
  final String roleName; // Ex: "Diacre", "Responsable Jeunesse"
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final String? appointeeById; // Qui a nommé

  Mandate({
    required this.id,
    required this.personId,
    required this.entityId,
    required this.type,
    required this.roleName,
    required this.startDate,
    this.endDate,
    this.isActive = true,
    this.appointeeById,
  });
}
