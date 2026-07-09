enum EntityLevel {
  internationale,
  territoriale,
  regionale,
  champ,
  district,
  communaute,
}

class EcclesiasticalEntity {
  final String id;
  final String name;
  final EntityLevel level;
  final String? parentId; // Pour la remontée hiérarchique
  final Map<String, dynamic>? metadata; // Adresse, GPS, etc.

  EcclesiasticalEntity({
    required this.id,
    required this.name,
    required this.level,
    this.parentId,
    this.metadata,
  });
}
