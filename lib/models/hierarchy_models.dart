// ignore_for_file: constant_identifier_names
import 'package:hive/hive.dart';

part 'hierarchy_models.g.dart';

// Les 6 niveaux d'entités de l'Église (Conforme au DCG Juillet 2026)
@HiveType(typeId: 20)
enum EntityLevel {
  @HiveField(0) communaute,       // Niveau 6 : Local
  @HiveField(1) district,         // Niveau 5 : Regroupement
  @HiveField(2) champ,            // Niveau 4 : Supervision
  @HiveField(3) regionApostolique, // Niveau 3 : Région Apostolique
  @HiveField(4) territoriale,     // Niveau 2 : Église Territoriale
  @HiveField(5) internationale,   // Niveau 1 : Église Internationale
}


// Les Rangs Ministériels Officiels
@HiveType(typeId: 21)
enum UserRole {
  @HiveField(0) apotrePatriarche,
  @HiveField(1) apotreDistrict,
  @HiveField(2) apotreResponsable,
  @HiveField(3) apotre,
  @HiveField(4) eveque,
  @HiveField(5) ancien,
  @HiveField(6) lead,
  @HiveField(7) berger,
  @HiveField(8) evangeliste,
  @HiveField(9) pretre,
  @HiveField(10) diacre,
  @HiveField(11) sousDiacre,
  @HiveField(12) frereCharge,
  @HiveField(13) conductrice,
  @HiveField(14) membre,
  @HiveField(15) superAdmin,
  @HiveField(16) respCommission,
}


// Rôles au sein d'une commission
@HiveType(typeId: 23)
enum CommissionRole {
  @HiveField(0) responsable,
  @HiveField(1) adjoint,
  @HiveField(2) membre,
}

// Profils pour le filtrage documentaire
@HiveType(typeId: 24)
enum ProfilDocumentaire {
  @HiveField(0) ministre,
  @HiveField(1) formateur,
  @HiveField(2) membre,
}

// Les 12 Commissions Officielles
@HiveType(typeId: 22)
enum CommissionType {
  @HiveField(0) ecodim,
  @HiveField(1) econfi,
  @HiveField(2) jeunesse,
  @HiveField(3) papas,
  @HiveField(4) mamans,
  @HiveField(5) aines,
  @HiveField(6) musique,
  @HiveField(7) presseMediasSonorisation,
  @HiveField(8) josephArimathee,
  @HiveField(9) securiteProtocole,
  @HiveField(10) medicale,
  @HiveField(11) construction,
  @HiveField(12) sacristie,
  @HiveField(13) none,
}



// Types de programmes
@HiveType(typeId: 25)
enum ProgrammeType {
  @HiveField(0) mensuel,
  @HiveField(1) trimestriel,
  @HiveField(2) annuel,
  @HiveField(3) special,
}

// Statuts des programmes
@HiveType(typeId: 26)
enum StatutProgramme {
  @HiveField(0) brouillon,
  @HiveField(1) valide,
  @HiveField(2) publie,
  @HiveField(3) archive,
}

// Catégories de documents
@HiveType(typeId: 27)
enum DocumentCategorie {
  @HiveField(0) manuel_ministre,
  @HiveField(1) manuel_formateur,
  @HiveField(2) manuel_apprenant,
  @HiveField(3) pensee_directrice,
  @HiveField(4) catechisme,
  @HiveField(5) cantique,
  @HiveField(6) liturgie,
  @HiveField(7) rapport_template,
}


// Rôles de responsable au sein d'une entité (ex: responsable de communauté, suppléant)
@HiveType(typeId: 28)
enum EntityResponsibleRole {
  @HiveField(0) responsable,
  @HiveField(1) suppleant,
}

