import 'package:hive/hive.dart';
import 'hierarchy_models.dart';

part 'entity_directive.g.dart';

/// Énumération des types de directives et messages d'entité
@HiveType(typeId: 115)
enum DirectiveType {
  @HiveField(0) directive,          // Directive officielle
  @HiveField(1) message,             // Message informatif
  @HiveField(2) annonce,             // Annonce générale
  @HiveField(3) alerte,              // Alerte urgente
  @HiveField(4) formulaire,          // Formulaire à remplir
  @HiveField(5) document,            // Document confidentiel
}

/// Énumération de la priorité des directives
@HiveType(typeId: 116)
enum DirectivePriority {
  @HiveField(0) basse,
  @HiveField(1) normale,
  @HiveField(2) haute,
  @HiveField(3) urgente,
}

/// Énumération du statut de lecture
@HiveType(typeId: 117)
enum DirectiveStatus {
  @HiveField(0) nonLu,
  @HiveField(1) lu,
  @HiveField(2) enCours,
  @HiveField(3) complete,
}

/// Modèle pour les directives et messages d'entité destinés aux ministres
@HiveType(typeId: 118)
class EntityDirective extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String titre;

  @HiveField(2)
  final String contenu;

  @HiveField(3)
  final DirectiveType type;

  @HiveField(4)
  final DirectivePriority priorite;

  @HiveField(5)
  final String entiteId;

  @HiveField(6)
  final EntityLevel entiteLevel;

  @HiveField(7)
  final String auteurId;

  @HiveField(8)
  final String auteurNom;

  @HiveField(9)
  final DateTime dateCreation;

  @HiveField(10)
  final DateTime? dateExpiration;

  @HiveField(11)
  final List<String> destinatairesMinistresIds;

  @HiveField(12)
  final bool isConfidential;

  @HiveField(13)
  final String? documentPath;

  @HiveField(14)
  final String? documentNom;

  @HiveField(15)
  final Map<String, DirectiveStatus> lectureStatus;

  @HiveField(16)
  final List<String>? tagsCommissions;

  @HiveField(17)
  final String? lienExterne;

  EntityDirective({
    required this.id,
    required this.titre,
    required this.contenu,
    required this.type,
    required this.priorite,
    required this.entiteId,
    required this.entiteLevel,
    required this.auteurId,
    required this.auteurNom,
    required this.destinatairesMinistresIds,
    DateTime? dateCreation,
    this.dateExpiration,
    this.isConfidential = false,
    this.documentPath,
    this.documentNom,
    Map<String, DirectiveStatus>? lectureStatus,
    this.tagsCommissions,
    this.lienExterne,
  })  : dateCreation = dateCreation ?? DateTime.now(),
        lectureStatus = lectureStatus ?? {};

  /// Vérifie si la directive a expiré
  bool get isExpired {
    if (dateExpiration == null) return false;
    return DateTime.now().isAfter(dateExpiration!);
  }

  /// Compte le nombre de lectures
  int get lecturesCount => lectureStatus.values.where((s) => s != DirectiveStatus.nonLu).length;

  /// Obtient le taux de lecture en pourcentage
  double get tauxLecture {
    if (destinatairesMinistresIds.isEmpty) return 0;
    return (lecturesCount / destinatairesMinistresIds.length) * 100;
  }

  /// Marque la directive comme lue pour un ministre
  void marquerCommeLue(String ministerId) {
    lectureStatus[ministerId] = DirectiveStatus.lu;
  }

  /// Marque la directive comme en cours pour un ministre
  void marquerEnCours(String ministerId) {
    lectureStatus[ministerId] = DirectiveStatus.enCours;
  }

  /// Marque la directive comme complétée pour un ministre
  void marquerCommeComplete(String ministerId) {
    lectureStatus[ministerId] = DirectiveStatus.complete;
  }

  /// Obtient le statut de lecture pour un ministre
  DirectiveStatus? getStatutMinitre(String ministerId) {
    return lectureStatus[ministerId];
  }

  /// Crée une copie avec modifications
  EntityDirective copyWith({
    String? id,
    String? titre,
    String? contenu,
    DirectiveType? type,
    DirectivePriority? priorite,
    String? entiteId,
    EntityLevel? entiteLevel,
    String? auteurId,
    String? auteurNom,
    DateTime? dateCreation,
    DateTime? dateExpiration,
    List<String>? destinatairesMinistresIds,
    bool? isConfidential,
    String? documentPath,
    String? documentNom,
    Map<String, DirectiveStatus>? lectureStatus,
    List<String>? tagsCommissions,
    String? lienExterne,
  }) {
    return EntityDirective(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      contenu: contenu ?? this.contenu,
      type: type ?? this.type,
      priorite: priorite ?? this.priorite,
      entiteId: entiteId ?? this.entiteId,
      entiteLevel: entiteLevel ?? this.entiteLevel,
      auteurId: auteurId ?? this.auteurId,
      auteurNom: auteurNom ?? this.auteurNom,
      dateCreation: dateCreation ?? this.dateCreation,
      dateExpiration: dateExpiration ?? this.dateExpiration,
      destinatairesMinistresIds: destinatairesMinistresIds ?? this.destinatairesMinistresIds,
      isConfidential: isConfidential ?? this.isConfidential,
      documentPath: documentPath ?? this.documentPath,
      documentNom: documentNom ?? this.documentNom,
      lectureStatus: lectureStatus ?? this.lectureStatus,
      tagsCommissions: tagsCommissions ?? this.tagsCommissions,
      lienExterne: lienExterne ?? this.lienExterne,
    );
  }
}

