import 'package:hive/hive.dart';

part 'hierarchy_models.g.dart';

// Les 5 niveaux d'entités de l'Église
@HiveType(typeId: 20)
enum EntityLevel {
  @HiveField(0) communaute,       // Niveau 1 : Local
  @HiveField(1) district,         // Niveau 2 : Regroupement de communautés
  @HiveField(2) champ,            // Niveau 3 : Regroupement de districts (ex: KSO)
  @HiveField(3) territoriale,     // Niveau 4 : Église d'un pays/région (ex: RDC Ouest)
  @HiveField(4) internationale,   // Niveau 5 : Église Néo-Apostolique Internationale
}

// Les Rôles Utilisateurs (RBAC)
@HiveType(typeId: 21)
enum UserRole {
  @HiveField(0) apotrePatriarche,     // Chef de l'Église Internationale (God-Mode)
  @HiveField(1) presidentTerritoriale, // Chef de l'Église Territoriale
  @HiveField(2) apotreChamp,          // Chef de Champ Apostolique
  @HiveField(3) apotreDistrict,       // Chef de District
  @HiveField(4) chefCommunaute,       // Responsable de communauté
  @HiveField(5) ministre,             // Diacre, Prêtre (sans responsabilité de communauté)
  @HiveField(6) respCommission,       // Responsable d'une commission à un niveau donné
  @HiveField(7) membre,               // Fidèle
  @HiveField(8) superAdmin,           // Administrateur système (Porte dérobée)
}

// Les Types de Commissions (Les 12 + Sacristie)
@HiveType(typeId: 22)
enum CommissionType {
  @HiveField(0) ecodim,
  @HiveField(1) confirmation,
  @HiveField(2) jeunesse,
  @HiveField(3) econfi,
  @HiveField(4) musique,
  @HiveField(5) medicale,
  @HiveField(6) aines,
  @HiveField(7) construction,
  @HiveField(8) securite,
  @HiveField(9) presse,
  @HiveField(10) papas,
  @HiveField(11) mamans,
  @HiveField(12) arimathee,
  @HiveField(13) sacristie,
  @HiveField(14) none,
}
