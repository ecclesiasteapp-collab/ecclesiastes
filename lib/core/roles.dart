import 'package:flutter/material.dart';

/// Niveaux d'entités de l'Église
enum EntityLevel {
  internationale,
  territoriale,
  champ,
  district,
  communaute,
}

/// Rôles principaux utilisés dans l'application
enum UserRole {
  superAdmin,
  apotrePatriarche,
  presidentTerritoriale,
  apotreChamp,
  apotreDistrict,
  chefCommunaute,
  ministre,
  respCommission,
  membre,
}

/// Types de commissions
enum CommissionType {
  ecodim,
  confirmation,
  jeunesse,
  econfi,
  musique,
  medicale,
  aines,
  construction,
  securite,
  presse,
  papas,
  mamans,
  arimathee,
  sacristie,
  none,
}

extension EntityLevelExtension on EntityLevel {
  String get label {
    switch (this) {
      case EntityLevel.internationale:
        return 'Internationale';
      case EntityLevel.territoriale:
        return 'Territoriale';
      case EntityLevel.champ:
        return 'Champ Apostolique';
      case EntityLevel.district:
        return 'District';
      case EntityLevel.communaute:
        return 'Communauté';
    }
  }

  IconData get icon {
    switch (this) {
      case EntityLevel.internationale:
        return Icons.public;
      case EntityLevel.territoriale:
        return Icons.account_balance;
      case EntityLevel.champ:
        return Icons.business;
      case EntityLevel.district:
        return Icons.location_city;
      case EntityLevel.communaute:
        return Icons.home;
    }
  }
}

extension CommissionTypeExtension on CommissionType {
  String get displayName {
    switch (this) {
      case CommissionType.ecodim:
        return 'ECODIM';
      case CommissionType.confirmation:
        return 'Confirmation';
      case CommissionType.jeunesse:
        return 'Jeunesse';
      case CommissionType.econfi:
        return 'Econfi';
      case CommissionType.musique:
        return 'Musique';
      case CommissionType.medicale:
        return 'Médicale';
      case CommissionType.aines:
        return 'Aînés';
      case CommissionType.construction:
        return 'Construction';
      case CommissionType.securite:
        return 'Sécurité';
      case CommissionType.presse:
        return 'Presse';
      case CommissionType.papas:
        return 'Papas';
      case CommissionType.mamans:
        return 'Mamans';
      case CommissionType.arimathee:
        return 'Joseph d’Arimathée';
      case CommissionType.sacristie:
        return 'Sacristie';
      case CommissionType.none:
        return 'Aucune';
    }
  }
}

