enum SocialActionType { health, education, food, housing, funeral, other }

class SocialAction {
  final String id;
  final String beneficiaryId; // ID de la Personne
  final SocialActionType type;
  final String entityId;
  final double amount;
  final String currency;
  final DateTime date;
  final String? description;

  SocialAction({
    required this.id,
    required this.beneficiaryId,
    required this.type,
    required this.entityId,
    required this.amount,
    required this.currency,
    required this.date,
    this.description,
  });
}
