class Family {
  final String id;
  final String name; // Ex: "Famille MBUYI"
  final String entityId; // Communauté de rattachement
  final String headOfFamilyId; // ID de la Personne (Chef de famille)
  final String address;
  final List<String> memberIds; // Liste des IDs des personnes du foyer

  Family({
    required this.id,
    required this.name,
    required this.entityId,
    required this.headOfFamilyId,
    required this.address,
    required this.memberIds,
  });
}
