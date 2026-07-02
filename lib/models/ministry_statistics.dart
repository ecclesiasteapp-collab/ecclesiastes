import 'package:hive/hive.dart';
import 'hierarchy_models.dart';

part 'ministry_statistics.g.dart';

/// Modèle pour les statistiques spécifiques à un ministère au sein d'une entité
@HiveType(typeId: 119)
class MinistryStatistics extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String entiteId;

  @HiveField(2)
  final EntityLevel entiteLevel;

  @HiveField(3)
  final String ministerId;

  @HiveField(4)
  final String ministryType;

  @HiveField(5)
  final DateTime dateMesure;

  // Statistiques de présence
  @HiveField(6)
  final int totalMembres;

  @HiveField(7)
  final int presentsMesure;

  @HiveField(8)
  final double tauxPresence;

  // Statistiques de participation
  @HiveField(9)
  final int participantsActifs;

  @HiveField(10)
  final int participantsInactifs;

  // Statistiques d'activité
  @HiveField(11)
  final int activitesRealisees;

  @HiveField(12)
  final int activitesPlanifiees;

  @HiveField(13)
  final int rapportsRemis;

  @HiveField(14)
  final int rapportsEnAttente;

  // Données financières
  @HiveField(15)
  final double offrandesFC;

  @HiveField(16)
  final double offrandesUSD;

  @HiveField(17)
  final double budgetAlloue;

  // Données de croissance
  @HiveField(18)
  final int nouveauxMembres;

  @HiveField(19)
  final int saintScelles;

  @HiveField(20)
  final int confirmations;

  // Métadonnées
  @HiveField(21)
  final DateTime? dateCreation;

  @HiveField(22)
  final DateTime? dateModification;

  @HiveField(23)
  final String? notes;

  MinistryStatistics({
    required this.id,
    required this.entiteId,
    required this.entiteLevel,
    required this.ministerId,
    required this.ministryType,
    required this.dateMesure,
    required this.totalMembres,
    required this.presentsMesure,
    required this.tauxPresence,
    required this.participantsActifs,
    required this.participantsInactifs,
    required this.activitesRealisees,
    required this.activitesPlanifiees,
    required this.rapportsRemis,
    required this.rapportsEnAttente,
    required this.offrandesFC,
    required this.offrandesUSD,
    required this.budgetAlloue,
    required this.nouveauxMembres,
    required this.saintScelles,
    required this.confirmations,
    DateTime? dateCreation,
    DateTime? dateModification,
    this.notes,
  })  : dateCreation = dateCreation ?? DateTime.now(),
        dateModification = dateModification ?? DateTime.now();

  /// Calcule le taux de complétude des rapports
  double get tauxCompletionRapports {
    final total = rapportsRemis + rapportsEnAttente;
    if (total == 0) return 0;
    return (rapportsRemis / total) * 100;
  }

  /// Calcule le taux de participation
  double get tauxParticipation {
    final total = participantsActifs + participantsInactifs;
    if (total == 0) return 0;
    return (participantsActifs / total) * 100;
  }

  /// Calcule le taux de réalisation des activités
  double get tauxRealisationActivites {
    if (activitesPlanifiees == 0) return 0;
    return (activitesRealisees / activitesPlanifiees) * 100;
  }

  /// Calcule le total des offrandes
  double get totalOffrandes => offrandesFC + offrandesUSD;

  /// Calcule le taux d'utilisation du budget
  double get tauxUtilisationBudget {
    if (budgetAlloue == 0) return 0;
    return (totalOffrandes / budgetAlloue) * 100;
  }

  /// Crée une copie avec modifications
  MinistryStatistics copyWith({
    String? id,
    String? entiteId,
    EntityLevel? entiteLevel,
    String? ministerId,
    String? ministryType,
    DateTime? dateMesure,
    int? totalMembres,
    int? presentsMesure,
    double? tauxPresence,
    int? participantsActifs,
    int? participantsInactifs,
    int? activitesRealisees,
    int? activitesPlanifiees,
    int? rapportsRemis,
    int? rapportsEnAttente,
    double? offrandesFC,
    double? offrandesUSD,
    double? budgetAlloue,
    int? nouveauxMembres,
    int? saintScelles,
    int? confirmations,
    DateTime? dateCreation,
    DateTime? dateModification,
    String? notes,
  }) {
    return MinistryStatistics(
      id: id ?? this.id,
      entiteId: entiteId ?? this.entiteId,
      entiteLevel: entiteLevel ?? this.entiteLevel,
      ministerId: ministerId ?? this.ministerId,
      ministryType: ministryType ?? this.ministryType,
      dateMesure: dateMesure ?? this.dateMesure,
      totalMembres: totalMembres ?? this.totalMembres,
      presentsMesure: presentsMesure ?? this.presentsMesure,
      tauxPresence: tauxPresence ?? this.tauxPresence,
      participantsActifs: participantsActifs ?? this.participantsActifs,
      participantsInactifs: participantsInactifs ?? this.participantsInactifs,
      activitesRealisees: activitesRealisees ?? this.activitesRealisees,
      activitesPlanifiees: activitesPlanifiees ?? this.activitesPlanifiees,
      rapportsRemis: rapportsRemis ?? this.rapportsRemis,
      rapportsEnAttente: rapportsEnAttente ?? this.rapportsEnAttente,
      offrandesFC: offrandesFC ?? this.offrandesFC,
      offrandesUSD: offrandesUSD ?? this.offrandesUSD,
      budgetAlloue: budgetAlloue ?? this.budgetAlloue,
      nouveauxMembres: nouveauxMembres ?? this.nouveauxMembres,
      saintScelles: saintScelles ?? this.saintScelles,
      confirmations: confirmations ?? this.confirmations,
      dateCreation: dateCreation ?? this.dateCreation,
      dateModification: dateModification ?? this.dateModification,
      notes: notes ?? this.notes,
    );
  }
}

