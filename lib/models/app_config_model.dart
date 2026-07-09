import 'package:hive/hive.dart';

part 'app_config_model.g.dart';

@HiveType(typeId: 230)
class HierarchyLevelConfig {
  @HiveField(0)
  final int rank;
  @HiveField(1)
  final String id;
  @HiveField(2)
  final String label;
  @HiveField(3)
  final String officialResponsible;
  @HiveField(4)
  final String? parentId;
  @HiveField(5)
  final bool canHaveAdjoint;
  @HiveField(6)
  final bool canHaveSuppleant;
  @HiveField(7)
  final List<String> permissions;

  HierarchyLevelConfig({
    required this.rank,
    required this.id,
    required this.label,
    required this.officialResponsible,
    this.parentId,
    required this.canHaveAdjoint,
    required this.canHaveSuppleant,
    required this.permissions,
  });

  factory HierarchyLevelConfig.fromJson(Map<String, dynamic> json) {
    return HierarchyLevelConfig(
      rank: json['rank'],
      id: json['id'],
      label: json['label'],
      officialResponsible: json['official_responsible'],
      parentId: json['parent_id'],
      canHaveAdjoint: json['can_have_adjoint'] ?? false,
      canHaveSuppleant: json['can_have_suppleant'] ?? false,
      permissions: List<String>.from(json['permissions'] ?? []),
    );
  }
}

@HiveType(typeId: 231)
class OrganisationTypeConfig {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String label;
  @HiveField(2)
  final String? parentType;
  @HiveField(3)
  final List<String> standardBureau;

  OrganisationTypeConfig({
    required this.id,
    required this.label,
    this.parentType,
    required this.standardBureau,
  });

  factory OrganisationTypeConfig.fromJson(Map<String, dynamic> json) {
    return OrganisationTypeConfig(
      id: json['id'],
      label: json['label'],
      parentType: json['parent_type'],
      standardBureau: List<String>.from(json['standard_bureau'] ?? []),
    );
  }
}

@HiveType(typeId: 232)
class MinistryConfig {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String label;
  @HiveField(2)
  final int rankOrder;
  @HiveField(3)
  final bool isApostolic;
  @HiveField(4)
  final bool isSacerdoce;

  MinistryConfig({
    required this.id,
    required this.label,
    required this.rankOrder,
    this.isApostolic = false,
    this.isSacerdoce = false,
  });

  factory MinistryConfig.fromJson(Map<String, dynamic> json) {
    return MinistryConfig(
      id: json['id'],
      label: json['label'],
      rankOrder: json['rank_order'],
      isApostolic: json['is_apostolic'] ?? false,
      isSacerdoce: json['is_sacerdoce'] ?? false,
    );
  }
}
