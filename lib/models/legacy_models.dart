// Ce fichier est déprécié et son contenu a été commenté pour éviter les conflits avec les nouveaux modèles basés sur Hive.
// Veuillez vous référer à hierarchy_models.dart, user.dart et event.dart pour les modèles à jour.

/*
// Énumérations pour les niveaux d'utilisateurs
enum UserLevel {
  apostle,      // Apôtre
  bishop,       // Évêque
  deacon,       // Diacre
  committeeLead, // Responsable Commission
  minister,     // Ministre
  member        // Membre
}

// Note: EntityLevel legacy removed because it conflicts with hierarchy_models.dart
// EventType legacy removed because it conflicts with isar/event.dart

/// Modèle pour un utilisateur (Legacy SQL)
class AppUser {
  final String id;
  final String name;
  final String email;
  final UserLevel level;
  final String? ministry;
  final String apostleField;
  final String district;
  final String community;
  final bool isActive;
  
  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.level,
    this.ministry,
    required this.apostleField,
    required this.district,
    required this.community,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'level': level.toString(),
      'ministry': ministry,
      'apostleField': apostleField,
      'district': district,
      'community': community,
      'isActive': isActive,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      level: UserLevel.values.firstWhere(
        (e) => e.toString() == map['level'],
        orElse: () => UserLevel.member,
      ),
      ministry: map['ministry'] as String?,
      apostleField: map['apostleField'] as String,
      district: map['district'] as String,
      community: map['community'] as String,
      isActive: map['isActive'] as bool? ?? true,
    );
  }
}

/// Modèle pour un événement (Legacy SQL)
class ChurchEventLegacy {
  final String id;
  final String title;
  final String type;
  final DateTime startDate;
  final DateTime? endDate;
  final String location;
  final String? apostleField;
  final String? district;
  final String? community;
  final String officiator;
  final List<String> assistants;
  final String description;
  final int expectedMembers;
  final int actualMembers;
  final double offering;
  final String offeringCurrency;
  final String status; // planned, ongoing, completed
  final DateTime createdAt;
  final String createdBy;
  
  ChurchEventLegacy({
    required this.id,
    required this.title,
    required this.type,
    required this.startDate,
    this.endDate,
    required this.location,
    this.apostleField,
    this.district,
    this.community,
    required this.officiator,
    required this.assistants,
    required this.description,
    this.expectedMembers = 0,
    this.actualMembers = 0,
    this.offering = 0,
    this.offeringCurrency = 'FC',
    this.status = 'planned',
    required this.createdAt,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'location': location,
      'apostleField': apostleField,
      'district': district,
      'community': community,
      'officiator': officiator,
      'assistants': assistants.join(','),
      'description': description,
      'expectedMembers': expectedMembers,
      'actualMembers': actualMembers,
      'offering': offering,
      'offeringCurrency': offeringCurrency,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
    };
  }

  factory ChurchEventLegacy.fromMap(Map<String, dynamic> map) {
    return ChurchEventLegacy(
      id: map['id'] as String,
      title: map['title'] as String,
      type: map['type'] as String,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate'] as String) : null,
      location: map['location'] as String,
      apostleField: map['apostleField'] as String?,
      district: map['district'] as String?,
      community: map['community'] as String?,
      officiator: map['officiator'] as String,
      assistants: (map['assistants'] as String).split(',').where((e) => e.isNotEmpty).toList(),
      description: map['description'] as String,
      expectedMembers: map['expectedMembers'] as int? ?? 0,
      actualMembers: map['actualMembers'] as int? ?? 0,
      offering: (map['offering'] as num?)?.toDouble() ?? 0,
      offeringCurrency: map['offeringCurrency'] as String? ?? 'FC',
      status: map['status'] as String? ?? 'planned',
      createdAt: DateTime.parse(map['createdAt'] as String),
      createdBy: map['createdBy'] as String,
    );
  }
}

// SacristyReport, Commission, EntityResponsible removed from here
// because they are now in their own Hive-compatible files.
*/

